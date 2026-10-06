require "rails_helper"

describe AdminNewReviewNotifierJob do
  subject(:perform) { described_class.new.perform(review.id) }

  let(:review) { create(:review) }
  let(:bot) { instance_double(Telegram::Bot::Client, send_message: true) }

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    stub_const("ENV", ENV.to_hash.merge("ADMIN_CHAT_ID" => "-100"))
  end

  it "sends the review summary to the admin chat" do
    perform

    expect(bot).to have_received(:send_message)
      .with(chat_id: "-100", text: Reviews::AdminNotificationPresenter.new(review).text)
  end
end
