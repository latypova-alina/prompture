class StoredImage < ApplicationRecord
  belongs_to :source_message, polymorphic: true
end
