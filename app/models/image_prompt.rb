class ImagePrompt < ApplicationRecord
  has_one :scene, dependent: :nullify
  has_many :stored_images, dependent: :nullify
end
