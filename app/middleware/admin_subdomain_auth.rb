class AdminSubdomainAuth
  ADMIN_HOST = "admin.caivemanator.com".freeze

  def initialize(app)
    @app = app
    @basic_auth = Rack::Auth::Basic.new(app) do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch("ADMIN_USERNAME", "")) &
        ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch("ADMIN_PASSWORD", ""))
    end
  end

  def call(env)
    request = Rack::Request.new(env)
    return @app.call(env) unless request.host == ADMIN_HOST

    @basic_auth.call(env)
  end
end
