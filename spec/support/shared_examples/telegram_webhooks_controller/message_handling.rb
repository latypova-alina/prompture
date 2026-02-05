RSpec.shared_examples "message handling" do
  context "when command is known" do
    include_context "telegram callback setup"

    before { setup_parent_message }

    let(:expected_message) do
      <<~HTML.strip
        Here is your prompt:

        <blockquote>cute white kitten</blockquote>

        What do you want to do next?
      HTML
    end

    let(:expected_markup) do
      {
        inline_keyboard: [
          [{ text: "Extend prompt", callback_data: "extend_prompt" }],
          [{ text: "Gemini (0.035€)", callback_data: "gemini_image" }],
          [{ text: "Imagen3 (0.04€)", callback_data: "imagen_image" }],
          [{ text: "Mystic (0.1€)", callback_data: "mystic_image" }]
        ]
      }
    end

    it "replies with MessagePresenter data" do
      expect { dispatch_message(prompt) }
        .to send_telegram_message(bot)
        .with(
          text: "#{expected_message}\n",
          parse_mode: "HTML",
          reply_markup: expected_markup,
          chat_id: 456
        )
    end

    context "when message does not contain text" do
      let(:prompt) { nil }

      let(:expected_text) do
        "The type of message you sent is not suitable for this command. " \
        "Please send the correct type of message and try again."
      end

      it { is_expected.to respond_with_message(expected_text) }
    end
  end

  context "when command was not selected" do
    let(:expected_text) do
      "Oops! It looks like you haven’t selected a command yet. Please choose one and follow the instructions."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end
end
