require "rails_helper"

describe AdminNewUserNotifierJob do
  subject(:perform) { described_class.new.perform }

  before do
    create_list(:user, 2)
  end

  it "sends the new user notification to the admin chat with the total user count" do
    expect(Telegram.bot).to receive(:send_message).with(
      chat_id: ENV.fetch("ADMIN_CHAT_ID"),
      text: I18n.t("admin_notifications.new_user", count: User.count)
    )

    perform
  end
end
