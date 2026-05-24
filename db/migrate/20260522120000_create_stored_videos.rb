class CreateStoredVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :stored_videos do |t|
      t.string :video_url, null: false
      t.string :category, null: false
      t.string :subcategory, null: false
      t.text :prompt
      t.references :source, polymorphic: true, null: false

      t.timestamps
    end

    add_index :stored_videos, %i[category subcategory]
    add_index :stored_videos, %i[source_type source_id], unique: true
  end
end
