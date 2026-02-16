module Billing
  class Base
    def self.call(...)
      new(...).call
    end

    def initialize(user:, amount:, source:)
      @user   = user
      @amount = amount
      @source = source
    end

    def call
      validate_amount!

      ActiveRecord::Base.transaction do
        balance.with_lock do
          check_for_sufficient_funds!

          create_transaction!
          handle_balance!
        end
      end
    rescue ActiveRecord::RecordNotUnique
      nil
    end

    private

    attr_reader :user, :amount, :source

    def balance
      user.balance
    end

    def check_for_sufficient_funds!
      raise NotImplementedError
    end

    def validate_amount!
      raise ArgumentError, "Amount must be positive" if amount <= 0
    end

    def handle_balance!
      raise NotImplementedError
    end

    def create_transaction!
      raise NotImplementedError
    end

    def source_type
      source.class.name
    end

    def source_id
      source.id
    end
  end
end
