module MiniApp
  module Validator
    class ProvidedHashReader
      def initialize(params:)
        @params = params
      end

      def provided_hash
        params["hash"]
      end

      private

      attr_reader :params
    end
  end
end
