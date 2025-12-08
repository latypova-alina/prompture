class ButtonImageProcessingRequest < ApplicationRecord
  belongs_to :parent_request, polymorphic: true
end
