class CreatePictureMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :picture_messages do |t|
      t.string :picture_id
      t.integer :size
      t.integer :width
      t.integer :height
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false

      t.timestamps
    end
  end
end
