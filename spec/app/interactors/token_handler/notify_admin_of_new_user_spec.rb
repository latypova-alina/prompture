require "rails_helper"

describe TokenHandler::NotifyAdminOfNewUser do
  subject(:call) { described_class.call(user:) }

  let(:user) { create(:user) }

  context "when user was newly created" do
    before { allow(user).to receive(:previously_new_record?).and_return(true) }

    it "enqueues the admin notifier job" do
      expect(AdminNewUserNotifierJob).to receive(:perform_async)

      call
    end
  end

  context "when user was not newly created" do
    before { allow(user).to receive(:previously_new_record?).and_return(false) }

    it "does not enqueue the admin notifier job" do
      expect(AdminNewUserNotifierJob).not_to receive(:perform_async)

      call
    end
  end
end
