require "rails_helper"

describe CartoonScriptCheckable do
  it "is included in all command request models" do
    expected_models = ApplicationRecord.descendants.select { |model| model.name.start_with?("Command") }

    expected_models.each do |model|
      expect(model.ancestors).to include(CartoonScriptCheckable),
                                 "#{model.name} does not include CartoonScriptCheckable"
    end
  end
end
