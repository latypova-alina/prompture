class ButtonExtendPromptRequest < ApplicationRecord
  belongs_to :parent_request, polymorphic: true

  has_one :button_parent_message, as: :request, dependent: :destroy
  has_one :button_child_message, as: :request, dependent: :destroy
end
