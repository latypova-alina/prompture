class TelegramMessage < ApplicationRecord
  belongs_to :request, polymorphic: true
end
