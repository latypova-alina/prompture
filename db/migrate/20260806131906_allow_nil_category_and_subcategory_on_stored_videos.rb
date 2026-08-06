class AllowNilCategoryAndSubcategoryOnStoredVideos < ActiveRecord::Migration[8.0]
  def change
    change_column_null :stored_videos, :category, true
    change_column_null :stored_videos, :subcategory, true
  end
end
