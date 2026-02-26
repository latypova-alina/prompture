require "rails_helper"

describe SetLocale::ButtonHandler::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          SetLocale::ButtonHandler::UpdateUser,
          SetLocale::ButtonHandler::NotifyUser
        ]
      )
    end
  end
end
