class ButtonChildMessage < ApplicationRecord
  belongs_to :request, polymorphic: true
  belongs_to :button_parent_message
end
