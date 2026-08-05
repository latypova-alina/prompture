class WelcomeBonus < ApplicationRecord
  self.table_name = "welcome_bonuses"

  belongs_to :user

  before_validation :assign_slot_number, on: :create

  private

  def assign_slot_number
    self.slot_number ||= (WelcomeBonus.maximum(:slot_number) || 0) + 1
  end
end
