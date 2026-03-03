module Clients
  module Generator
    module BaseApiRequest
      include Memery

      private

      def response
        raise NotImplementedError
      end

      memoize def connection
        Connection.new(api_url).connection
      end
    end
  end
end
