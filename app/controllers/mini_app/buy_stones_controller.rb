module MiniApp
  class BuyStonesController < ApplicationController
    include Memery

    layout false

    skip_before_action :verify_authenticity_token, only: :packs

    def show; end

    def packs
      return render_unauthorized if result.failure?

      render json: { buy_button:, terms_required:, packs: result.packs }
    end

    private

    delegate :buy_button, :terms_required, to: :result

    memoize def result
      BuyStones::LoadPacks.call(init_data: params[:init_data], terms_accepted: params[:terms_accepted])
    end

    def render_unauthorized
      render json: { error: I18n.t("mini_app.buy_stones.error", locale: I18n.default_locale) }, status: :unauthorized
    end
  end
end
