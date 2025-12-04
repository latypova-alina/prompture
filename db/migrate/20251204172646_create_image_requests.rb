class CreateImageRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :image_requests do |t|
      t.string :prompt, null: false
      t.string :status, null: false, default: "pending"
      t.string :image_url
      t.bigint :chat_id, null: false
      t.timestamps
    end
  end
end
