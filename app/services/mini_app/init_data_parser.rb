module MiniApp
  class InitDataParser
    include Memery

    def initialize(init_data:)
      @init_data = init_data
    end

    def user_id
      telegram_user["id"]
    end

    def user_name
      telegram_user["first_name"]
    end

    private

    attr_reader :init_data

    memoize def telegram_user
      JSON.parse(params["user"])
    rescue JSON::ParserError
      {}
    end

    memoize def params
      URI.decode_www_form(init_data.to_s).to_h
    end
  end
end
