class ButtonVideoProcessingRequest < ApplicationRecord
  belongs_to :parent_request, polymorphic: true

  has_one :button_child_message, as: :request, dependent: :destroy
end
