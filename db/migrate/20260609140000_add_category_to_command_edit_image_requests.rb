class AddCategoryToCommandEditImageRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :command_edit_image_requests, :category, :string
    add_index :command_edit_image_requests, :category
  end
end
