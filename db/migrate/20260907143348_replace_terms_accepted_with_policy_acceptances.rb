class ReplaceTermsAcceptedWithPolicyAcceptances < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :terms_accepted_at, :datetime

    create_table :policy_acceptances do |t|
      t.references :user, null: false, foreign_key: true
      t.string :privacy_policy_version, null: false
      t.string :terms_version, null: false
      t.datetime :accepted_at, null: false

      t.timestamps
    end
  end
end
