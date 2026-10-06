class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :rating, null: false
      t.jsonb :answers, null: false, default: {}
      t.integer :survey_version, null: false
      t.string :locale, null: false
      t.timestamps
    end

    add_check_constraint :reviews, "rating BETWEEN 1 AND 5", name: "reviews_rating_range"
  end
end
