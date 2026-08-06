class CreateFlipperManagedFeatures < ActiveRecord::Migration[8.0]
  def change
    create_table :flipper_managed_features do |t|
      t.string :feature_key, null: false

      t.timestamps
    end

    add_index :flipper_managed_features, :feature_key, unique: true
  end
end
