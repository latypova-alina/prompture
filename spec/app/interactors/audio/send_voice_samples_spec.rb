require "rails_helper"

RSpec.describe Audio::SendVoiceSamples do
  subject(:result) do
    described_class.call(chat_id:)
  end

  let(:chat_id) { 456 }
  let!(:user) { create(:user, chat_id:, locale: "en") }

  before do
    stub_const("ENV", ENV.to_hash.merge("INTERNAL_BUCKET_BASE_URL" => "https://bucket.example"))
    allow(Telegram.bot).to receive(:send_message)
  end

  it "sends the samples message" do
    expect(result).to be_success

    expect(Telegram.bot).to have_received(:send_message).with(
      hash_including(
        chat_id:,
        parse_mode: "HTML",
        text: a_string_including("Here are the voice samples 🔊", "audio/samples/adam.mp3")
      )
    )
  end
end
