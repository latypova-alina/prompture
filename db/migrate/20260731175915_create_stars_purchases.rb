class CreateStarsPurchases < ActiveRecord::Migration[8.0]
  def change
    create_table :stars_purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.string :telegram_payment_charge_id, null: false
      t.string :pack_key, null: false
      t.integer :stars_amount, null: false
      t.integer :credits_amount, null: false

      t.timestamps
    end

    add_index :stars_purchases, :telegram_payment_charge_id, unique: true
  end
end
