require "rails_helper"

describe Buttons::ForSetLocale do
  describe ".build" do
    subject(:result) { described_class.build }

    it "returns array of arrays (one button per row)" do
      expect(result).to eq(
        [
          [
            {
              text: "English",
              callback_data: "set_locale:en"
            }
          ],
          [
            {
              text: "Русский",
              callback_data: "set_locale:ru"
            }
          ],
          [
            {
              text: "Español",
              callback_data: "set_locale:es"
            }
          ]
        ]
      )
    end
  end
end
