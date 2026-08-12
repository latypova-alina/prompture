require "rails_helper"

describe ScriptGenerator::ForBloomy::GenerateVideosCta::PresenterSelector do
  subject(:reply_data) { described_class.new(pairs_count:, locale: :en).presenter.reply_data }

  let(:pairs_count) { 2 }

  it "builds reply data for the generate videos CTA" do
    expect(reply_data[:text]).to eq(
      I18n.t("telegram_webhooks.message.bloomy_complex.all_images_generated")
    )
    expect(reply_data[:reply_markup][:inline_keyboard]).to eq(
      [[{
        callback_data: ButtonActions::GENERATE_BLOOMY_COMPLEX_VIDEOS,
        text: "Generate videos (12 stones 💎)"
      }]]
    )
  end
end
