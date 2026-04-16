require "rails_helper"

describe ErrorI18nResolver do
  subject(:resolver) { resolver_class.new }

  let(:resolver_class) do
    Class.new do
      include ErrorI18nResolver

      def resolve(error_class_name)
        send(:error_i18n_key, error_class_name)
      end
    end
  end

  describe "#error_i18n_key" do
    it "returns mapped i18n key for known error class" do
      expect(resolver.resolve("ImageResolutionError")).to eq("errors.image_resolution")
    end

    it "returns fallback key for unknown error class" do
      expect(resolver.resolve("SomeUnknownError")).to eq("errors.unknown")
    end
  end
end
