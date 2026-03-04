class ApplicationJob
  include Sidekiq::Job
  include LocaleSupport
end
