class User < ApplicationRecord
  has_one :balance, dependent: :destroy
  has_many :tokens, dependent: :destroy
end
