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
      
      t.timestamps
    end

    create_table :tokens do |t|
      t.string :code, null: false
      t.integer :credits, null: false
      t.text :greeting
      t.references :user, null: true, foreign_key: true
      t.date :expires_at, null: false
      t.date :used_at

      t.timestamps
    end
    add_index :tokens, :code, unique: true

    create_table :balance_transactions do |t|
      t.integer :amount, null: false
      t.string :transaction_type, null: false

      t.references :user, null: false, foreign_key: true

      t.string :source_type, null: false
      t.bigint :source_id, null: false

      t.timestamps
    end

    add_index :balance_transactions, [:source_type, :source_id]
    add_index :balance_transactions,
      [:user_id, :transaction_type, :source_type, :source_id],
      unique: true,
      name: "index_balance_transactions_uniqueness"
  end
end
