class CommandImageFromReferenceRequest < ApplicationRecord
  # TODO: fill this model later

  has_many :button_image_processing_requests, as: :parent_request, dependent: :destroy
end
