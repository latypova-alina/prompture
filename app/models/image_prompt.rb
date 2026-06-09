class ImagePrompt < ApplicationRecord
  has_one :script, dependent: :nullify
end
