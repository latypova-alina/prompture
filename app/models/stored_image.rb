class StoredImage < ApplicationRecord
  belongs_to :source_message, polymorphic: true
  belongs_to :image_prompt, optional: true
end
