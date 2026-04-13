class BotTelegramMessage < ApplicationRecord
  belongs_to :request, polymorphic: true
end
