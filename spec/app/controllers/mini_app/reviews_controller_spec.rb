require "rails_helper"

describe MiniApp::ReviewsController, type: :request do
  include_context "signed mini app init data"

  subject { response }

  let(:bot) { instance_double(Telegram::Bot::Client, send_message: true) }
  let!(:user) { create(:user, chat_id: telegram_user_id, locale: "ru") }

  let(:answers) do
    {
      rating: 4,
      use_cases: { selected: %w[fun other], other: "making birthday cards for friends" },
      features: { selected: %w[video image_editing] },
      missing: "longer videos and more voices please",
      frustrations: "videos sometimes take too long to generate"
    }
  end

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(AdminNewReviewNotifierJob).to receive(:perform_async)
  end

  def post_json(path, payload)
    post path, params: payload.to_json, headers: { "Content-Type" => "application/json" }
  end

  describe "GET /mini_app/review" do
    before { get "/mini_app/review" }

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to include('"/mini_app/review/survey"') }
  end

  describe "POST /mini_app/review/survey" do
    before { post_json("/mini_app/review/survey", init_data:) }

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.parsed_body["already_reviewed"]).to be(false) }

    it do
      expect(response.parsed_body.dig("survey", "questions", 0, "title"))
        .to eq(I18n.t("reviews.survey.v1.questions.rating.title", locale: :ru))
    end

    context "when the user already reviewed" do
      let!(:user) { create(:user, chat_id: telegram_user_id).tap { |user| create(:review, user:) } }

      it { expect(response.parsed_body["already_reviewed"]).to be(true) }
    end

    context "when init_data is invalid" do
      let(:init_data) { "user=%7B%7D&hash=forged" }

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end

  describe "POST /mini_app/review" do
    let(:submitted_answers) { answers }

    before { post_json("/mini_app/review", init_data:, answers: submitted_answers) }

    context "with complete answers" do
      it { is_expected.to have_http_status(:created) }
      it { expect(response.parsed_body["message"]).to eq(I18n.t("reviews.mini_app.success", locale: :ru)) }
      it { expect(user.reload.review).to have_attributes(rating: 4, survey_version: 1, locale: "ru") }

      it do
        expect(user.reload.review.answers["use_cases"])
          .to eq("selected" => %w[fun other], "other" => "making birthday cards for friends")
      end

      it { expect(AdminNewReviewNotifierJob).to have_received(:perform_async).with(Review.last.id) }

      it do
        expect(bot).to have_received(:send_message)
          .with(chat_id: telegram_user_id, text: I18n.t("reviews.thank_you", locale: :ru))
      end
    end

    context "when an answer is missing" do
      let(:submitted_answers) { answers.except(:frustrations) }

      it { is_expected.to have_http_status(:unprocessable_content) }
      it { expect(Review.count).to eq(0) }

      it do
        expect(response.parsed_body["errors"])
          .to eq("frustrations" => I18n.t("reviews.mini_app.errors.required", locale: :ru))
      end
    end

    context "when a text answer is too short" do
      let(:submitted_answers) { answers.merge(missing: "videos") }

      it { is_expected.to have_http_status(:unprocessable_content) }
      it { expect(Review.count).to eq(0) }
      it { expect(response.parsed_body["errors"].keys).to eq(["missing"]) }
    end

    context "when an option is not in the survey" do
      let(:submitted_answers) { answers.merge(features: { selected: %w[video teleportation] }) }

      it { is_expected.to have_http_status(:unprocessable_content) }
      it { expect(Review.count).to eq(0) }
    end

    ["nope", [1]].each do |raw_answers|
      context "when answers is #{raw_answers.inspect} instead of an object" do
        let(:submitted_answers) { raw_answers }

        it { is_expected.to have_http_status(:unprocessable_content) }
        it { expect(Review.count).to eq(0) }

        context "and init_data is invalid" do
          let(:init_data) { "user=%7B%7D&hash=forged" }

          it { is_expected.to have_http_status(:unauthorized) }
        end
      end
    end

    context "when the user already reviewed" do
      let!(:user) { create(:user, chat_id: telegram_user_id).tap { |user| create(:review, user:) } }

      it { is_expected.to have_http_status(:conflict) }
      it { expect(Review.count).to eq(1) }
    end

    context "when init_data is invalid" do
      let(:init_data) { "user=%7B%7D&hash=forged" }

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect(Review.count).to eq(0) }
    end
  end

  describe "POST /mini_app/review when the thank you message can't be sent" do
    before do
      allow(bot).to receive(:send_message).and_raise(Telegram::Bot::Forbidden)
      allow(Sentry).to receive(:capture_exception)

      post_json("/mini_app/review", init_data:, answers:)
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(user.reload.review).to be_present }
    it { expect(Sentry).to have_received(:capture_exception).with(Telegram::Bot::Forbidden, extra: { review_id: Review.last.id }) }
  end

  describe "with the review bonus on" do
    let!(:user) do
      create(:user, chat_id: telegram_user_id, locale: "ru").tap do |user|
        create(:balance, user:, credits: 2)
      end
    end

    before { Flipper.enable_actor(:flipper_review_bonus, user) }

    context "when loading the survey" do
      before { post_json("/mini_app/review/survey", init_data:) }

      it { expect(response.parsed_body.dig("survey", "ui", "reward")).to include("50") }
    end

    context "when submitting a complete review" do
      before { post_json("/mini_app/review", init_data:, answers:) }

      it { is_expected.to have_http_status(:created) }
      it { expect(user.balance.reload.credits).to eq(52) }
      it do
        expect(BalanceTransaction.find_by!(source: user.review))
          .to have_attributes(transaction_type: "GRANT", amount: 50)
      end

      it do
        expect(bot).to have_received(:send_message).with(
          chat_id: telegram_user_id,
          text: Reviews::ThankYouPresenter.new(locale: "ru", reward_credits: 50, balance: 52).text
        )
      end
    end

    context "when submitting a second time" do
      before do
        post_json("/mini_app/review", init_data:, answers:)
        post_json("/mini_app/review", init_data:, answers:)
      end

      it { is_expected.to have_http_status(:conflict) }
      it { expect(user.balance.reload.credits).to eq(52) }
    end
  end

  describe "POST /mini_app/review/survey with the review bonus off" do
    before { post_json("/mini_app/review/survey", init_data:) }

    it { expect(response.parsed_body.dig("survey", "ui")).not_to have_key("reward") }
  end
end
