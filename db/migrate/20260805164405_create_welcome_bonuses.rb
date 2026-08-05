class CreateWelcomeBonuses < ActiveRecord::Migration[8.0]
  CAP = 100

  def change
    create_table :welcome_bonuses do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :slot_number, null: false

      t.timestamps
    end

    add_index :welcome_bonuses, :slot_number, unique: true
    add_check_constraint :welcome_bonuses, "slot_number <= #{CAP}", name: "welcome_bonuses_slot_number_cap"
  end
end
