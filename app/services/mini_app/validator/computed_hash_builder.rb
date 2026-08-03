module MiniApp
  module Validator
    class ComputedHashBuilder
      include Memery

      def initialize(params:)
        @params = params
      end

      def computed_hash
        OpenSSL::HMAC.hexdigest("SHA256", secret_key, data_check_string)
      end

      private

      attr_reader :params

      memoize def data_check_string
        params.except("hash").sort.map { |key, value| "#{key}=#{value}" }.join("\n")
      end

      memoize def secret_key
        OpenSSL::HMAC.digest("SHA256", "WebAppData", ENV.fetch("TELEGRAM_BOT_TOKEN"))
      end
    end
  end
end
