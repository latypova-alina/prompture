# A completed /review survey. A row only exists once every question was answered and validated,
# so "has reviewed" is simply "has a row" (one per user, enforced by a unique index).
class Review < ApplicationRecord
  belongs_to :user

  validates :rating, inclusion: { in: 1..5 }
  validates :survey_version, :locale, presence: true
end
