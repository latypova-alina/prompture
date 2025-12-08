class ButtonVideoProcessingRequest < ApplicationRecord
  belongs_to :parent_request, polymorphic: true
end
