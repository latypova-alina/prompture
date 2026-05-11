require "rails_helper"

describe ScriptGenerator::ExtractTemplateName do
  describe ".call" do
    it "extracts template name from command text" do
      result = described_class.call(message_body: { "message" => { "text" => "/generate_script daily_news" } })

      expect(result).to be_success
      expect(result.template_name).to eq("daily_news")
    end

    it "sets template_name to nil when argument is missing" do
      result = described_class.call(message_body: { "message" => { "text" => "/generate_script" } })

      expect(result).to be_failure
      expect(result.error).to eq(TemplateNameError)
      expect(result.template_name).to be_nil
    end
  end
end
