require "rails_helper"

describe MessagePresenter do
  let(:message) { "Sample message" }
  let(:message_type) { "initial_message" }

  subject { described_class.new(message, message_type) }

  let(:expected_reply_data) do
    {
      parse_mode: "HTML",
      reply_markup: {
        inline_keyboard: [
          [
            {
              callback_data: "extend_prompt",
              text: "Extend prompt"
            }
          ],
          [
            {
              callback_data: "mystic_image",
              text: "Mystic (Realistic, 0.1€)"
            }
          ]
        ]
      },
      text: "Here is your prompt:\n\nSample message\n\nWhat do you want to do next?\n"
    }
  end

  describe "#reply_data" do
    subject { super().reply_data }

    it { is_expected.to eq(expected_reply_data) }

    context "when message_type is prompt_message" do
      let(:message_type) { "prompt_message" }
      let(:expected_reply_data) do
        {
          parse_mode: "HTML",
          reply_markup: {
            inline_keyboard: [
              [
                {
                  callback_data: "mystic_image",
                  text: "Mystic (Realistic, 0.1€)"
                }
              ]
            ]
          },
          text: "Sample message"
        }
      end

      it { is_expected.to eq(expected_reply_data) }
    end
  end
end
