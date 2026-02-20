class CommandImageFromReferenceRequest < ApplicationRecord
  belongs_to :user

  has_many :button_image_processing_requests, as: :parent_request, dependent: :destroy
end
