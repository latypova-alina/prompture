require Rails.root.join("app/middleware/admin_subdomain_auth")

Rails.application.config.middleware.use AdminSubdomainAuth
