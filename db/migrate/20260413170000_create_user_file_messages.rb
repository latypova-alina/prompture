class CreateUserFileMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :user_file_messages do |t|
      t.string :file_id
      t.integer :size
      t.references :parent_request, polymorphic: true, null: false
      t.references :command_request, polymorphic: true, null: false
      t.timestamps
      t.bigint :tg_message_id
    end
  end
end
