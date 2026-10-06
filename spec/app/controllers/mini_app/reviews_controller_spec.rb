require "rails_helper"

describe MiniApp::ReviewsController, type: :request do
  include_context "signed mini app init data"

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

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.body).to include("fetch(path").and include('"/mini_app/review/survey"') }
  end

  describe "POST /mini_app/review/survey" do
    before { post_json("/mini_app/review/survey", init_data:) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body["already_reviewed"]).to be(false) }

    it "returns the survey in the user's language" do
      expect(response.parsed_body.dig("survey", "questions", 0, "title"))
        .to eq(I18n.t("reviews.survey.v1.questions.rating.title", locale: :ru))
    end

    context "when the user already reviewed" do
      let!(:user) { create(:user, chat_id: telegram_user_id).tap { |user| create(:review, user:) } }

      it { expect(response.parsed_body["already_reviewed"]).to be(true) }
    end

    context "when init_data is invalid" do
      let(:init_data) { "user=%7B%7D&hash=forged" }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "POST /mini_app/review" do
    subject(:submit) { post_json("/mini_app/review", init_data:, answers:) }

    it "creates the review with normalized answers" do
      expect { submit }.to change(Review, :count).by(1)

      expect(user.reload.review).to have_attributes(rating: 4, survey_version: 1, locale: "ru")
      expect(user.review.answers["use_cases"]).to eq("selected" => %w[fun other],
                                                     "other" => "making birthday cards for friends")
    end

    it "responds 201 with a thank you" do
      submit

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["message"]).to eq(I18n.t("reviews.mini_app.success", locale: :ru))
    end

    it "enqueues the admin notification" do
      submit

      expect(AdminNewReviewNotifierJob).to have_received(:perform_async).with(Review.last.id)
    end

    it "sends a thank you message in the chat" do
      submit

      expect(bot).to have_received(:send_message)
        .with(chat_id: telegram_user_id, text: I18n.t("reviews.thank_you", locale: :ru))
    end

    context "when an answer is missing" do
      let(:answers) { super().except(:frustrations) }

      it { expect { submit }.not_to change(Review, :count) }

      it "responds 422 with per-question errors" do
        submit

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["errors"])
          .to eq("frustrations" => I18n.t("reviews.mini_app.errors.required", locale: :ru))
      end
    end

    context "when a text answer is too short" do
      let(:answers) { super().merge(missing: "videos") }

      it { expect { submit }.not_to change(Review, :count) }

      it "responds 422" do
        submit

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["errors"].keys).to eq(["missing"])
      end
    end

    context "when an option is not in the survey" do
      let(:answers) { super().merge(features: { selected: %w[video teleportation] }) }

      it { expect { submit }.not_to change(Review, :count) }
    end

    context "when the user already reviewed" do
      before { create(:review, user:) }

      it { expect { submit }.not_to change(Review, :count) }

      it "responds 409" do
        submit

        expect(response).to have_http_status(:conflict)
      end
    end

    context "when init_data is invalid" do
      let(:init_data) { "user=%7B%7D&hash=forged" }

      it { expect { submit }.not_to change(Review, :count) }

      it "responds 401" do
        submit

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
