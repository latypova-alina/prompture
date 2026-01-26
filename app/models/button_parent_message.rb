class ButtonParentMessage < ApplicationRecord
  belongs_to :request, polymorphic: true

  has_many :button_child_messages, dependent: :destroy
end
