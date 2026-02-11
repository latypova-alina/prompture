class TelegramMessage < ApplicationRecord
  has_one :balance, depemdent: :destroy
  has_many :tokens, dependent: :destroy
end
