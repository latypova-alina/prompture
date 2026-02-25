module Generator
  module WithLocaleInterface
    include Memery

    private

    memoize def request
      request_class.includes(command_request: :user).find(button_request_id)
    end

    memoize def locale
      request.user.locale.to_s
    end

    def request_class
      raise NotImplementedError
    end

    def button_request_id
      raise NotImplementedError
    end
  end
end
