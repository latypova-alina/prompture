require "uri"

module RecordValidators
  module UrlInspector
    class RedirectUrlResolver
      def resolve(current_uri:, location:)
        return nil if location.blank?

        redirected_uri = URI.parse(location)
        return redirected_uri if redirected_uri.absolute?

        URI.join(current_uri.to_s, location)
      rescue URI::InvalidURIError
        nil
      end
    end
  end
end
