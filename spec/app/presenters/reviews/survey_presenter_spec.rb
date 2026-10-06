require "rails_helper"

describe Reviews::SurveyPresenter do
  subject(:survey) { described_class.new(locale: "es").as_json }

  let(:use_cases) { survey[:questions].find { |question| question[:id] == "use_cases" } }

  it { expect(survey[:questions].pluck(:id)).to eq(%w[rating use_cases features missing frustrations]) }
  it { expect(survey[:ui][:submit]).to eq(I18n.t("reviews.mini_app.submit", locale: :es)) }
  it { expect(survey[:errors][:too_short]).to include("10") }

  it do
    expect(use_cases[:options].first).to eq(
      id: "social_media",
      label: I18n.t("reviews.survey.v1.questions.use_cases.options.social_media", locale: :es)
    )
  end

  it { expect(use_cases[:other]).to eq(label: I18n.t("reviews.mini_app.other_label", locale: :es), min_length: 10) }
end
