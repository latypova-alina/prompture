class VideoPrompt < ApplicationRecord
  has_one :script, dependent: :nullify
end
