module MiniApp
  class BuyCreditsController < ApplicationController
    include Memery

    layout false

    skip_before_action :verify_authenticity_token, only: :packs

    def show; end

    def packs
      return render_unauthorized unless validator.valid?

      render json: { buy_button: I18n.t("mini_app.buy_credits.buy_button", locale:), packs: pack_data }
    end

    private

    delegate :pack_data, to: :pack_data_builder
    delegate :user_id, :user_name, to: :parser
    delegate :user, to: :user_resolver
    delegate :locale, to: :user, prefix: true

    memoize def pack_data_builder
      StarsPayment::PackDataBuilder.new(locale:)
    end

    memoize def validator
      MiniApp::InitDataValidator.new(init_data: params[:init_data])
    end

    memoize def parser
      MiniApp::InitDataParser.new(init_data: params[:init_data])
    end

    memoize def user_resolver
      UserResolver.new(chat_id: user_id, name: user_name, locale: I18n.default_locale.to_s)
    end

    def locale
      Rails.application.config.x.supported_locales.include?(user_locale) ? user_locale : I18n.default_locale.to_s
    end

    def render_unauthorized
      render json: { error: I18n.t("mini_app.buy_credits.error", locale: I18n.default_locale) }, status: :unauthorized
    end
  end
end
