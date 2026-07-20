class Script < ApplicationRecord
  has_many :scenes, -> { order(:order) }, dependent: :destroy, inverse_of: :script
end
