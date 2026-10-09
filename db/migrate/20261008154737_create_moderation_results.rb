class CreateModerationResults < ActiveRecord::Migration[8.0]
  def change
    create_table :moderation_results do |t|
      t.references :moderatable, polymorphic: true, null: true
      t.references :command_request, polymorphic: true, null: false
      t.string :input_kind, null: false
      t.text :input_text
      t.string :model, null: false
      t.boolean :blocked, null: false, default: false
      t.string :blocked_by
      t.boolean :openai_flagged
      t.jsonb :result
      t.text :error

      t.timestamps
    end

    add_index :moderation_results, :blocked
  end
end
