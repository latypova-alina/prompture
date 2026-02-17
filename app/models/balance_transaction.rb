class BalanceTransaction < ApplicationRecord
  TRANSACTION_TYPES = %w[CHARGE REFUND GRANT].freeze

  validates :amount, presence: true
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }

  belongs_to :user
  belongs_to :source, polymorphic: true
end
