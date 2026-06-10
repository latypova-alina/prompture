class ImagePrompt < ApplicationRecord
  has_one :script, dependent: :nullify
  has_many :stored_images, dependent: :nullify
end
