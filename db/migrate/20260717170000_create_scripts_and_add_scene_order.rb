class CreateScriptsAndAddSceneOrder < ActiveRecord::Migration[8.0]
  def up
    create_table :scripts do |t|
      t.boolean :chained_references, null: false, default: false

      t.timestamps
    end

    add_reference :scenes, :script, foreign_key: true, null: true
    add_column :scenes, :order, :integer, null: false, default: 1
    add_index :scenes, %i[script_id order]

    backfill_scripts_and_scene_orders

    change_column_null :scenes, :script_id, false
  end

  def down
    remove_index :scenes, %i[script_id order]
    remove_reference :scenes, :script, foreign_key: true
    remove_column :scenes, :order
    drop_table :scripts
  end

  private

  def backfill_scripts_and_scene_orders
    script_id = insert_backfill_script
    return if script_id.blank?

    execute(<<~SQL.squish)
      UPDATE scenes
      SET script_id = #{script_id}, "order" = 1
      WHERE script_id IS NULL
    SQL
  end

  def insert_backfill_script
    result = execute(<<~SQL.squish)
      INSERT INTO scripts (chained_references, created_at, updated_at)
      VALUES (FALSE, NOW(), NOW())
      RETURNING id
    SQL

    result.first&.fetch("id")
  end
end
