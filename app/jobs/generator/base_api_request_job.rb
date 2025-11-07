module Generator
  class BaseApiRequestJob
    include Sidekiq::Job
    include Memery

    private

    def response
      raise NotImplementedError
    end

    def api_url
      raise NotImplementedError unless self.class.const_defined?(:API_URL)

      self.class::API_URL
    end

    memoize def connection
      Clients::Generator::Connection.new(api_url).connection
    end
  end
end
