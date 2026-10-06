require "rails_helper"

describe Reviews::SurveyPresenter do
  subject(:survey) { described_class.new(locale: "es").as_json }

  it {
    expect(survey[:questions].map do |question|
      question[:id]
    end).to eq(%w[rating use_cases features missing frustrations])
  }
  it { expect(survey[:ui][:submit]).to eq(I18n.t("reviews.mini_app.submit", locale: :es)) }
  it { expect(survey[:errors][:too_short]).to include("20") }

  it "localizes options and adds other where the question allows it" do
    use_cases = survey[:questions].find { |question| question[:id] == "use_cases" }

    expect(use_cases[:options].first).to eq(id: "social_media",
                                            label: I18n.t("reviews.survey.v1.questions.use_cases.options.social_media",
                                                          locale: :es))
    expect(use_cases[:other]).to eq(label: I18n.t("reviews.mini_app.other_label", locale: :es), min_length: 20)
  end
end
