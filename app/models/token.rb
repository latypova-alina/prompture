class TelegramMessage < ApplicationRecord
  belongs_to :user, optional: true
end
