class CreateImageMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :image_messages do |t|
      t.string :image_url
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false

      t.timestamps
    end
  end
end
