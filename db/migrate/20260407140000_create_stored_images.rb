class CreateStoredImages < ActiveRecord::Migration[8.0]
  def change
    create_table :stored_images do |t|
      t.string :image_url, null: false
      t.references :source_message, polymorphic: true, null: false

      t.timestamps
    end

    add_index :stored_images, %i[source_message_type source_message_id], unique: true
  end
end
