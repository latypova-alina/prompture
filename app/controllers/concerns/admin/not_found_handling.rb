module Admin
  module NotFoundHandling
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound do
        render plain: "Not found", status: :not_found
      end
    end
  end
end
