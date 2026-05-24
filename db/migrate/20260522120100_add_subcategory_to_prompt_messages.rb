class AddSubcategoryToPromptMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :prompt_messages, :subcategory, :string
    add_index :prompt_messages, :subcategory
  end
end
