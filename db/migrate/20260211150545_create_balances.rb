class CreateBalances < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.bigint :chat_id, null: false, index: { unique: true }

      t.timestamps
    end
    
    create_table :balances do |t|
      t.integer :credits, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      
      t.timestampse
    end

    create_table :tokens do |t|
      t.string :code, null: false
      t.integer :credits, null: false
      t.references :user, null: false, foreign_key: true
      t.date :expires_at, null: false
      t.date :used_at

      t.timestamps
    end
  end
end
