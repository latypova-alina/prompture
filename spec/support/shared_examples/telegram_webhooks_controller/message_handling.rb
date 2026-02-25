RSpec.shared_examples "message handling" do
  context "when command is known" do
    include_context "telegram callback setup"

    before { setup_parent_message }

    let(:expected_message) do
      <<~HTML.strip
        Here is your prompt:

        <blockquote>cute white kitten</blockquote>

        What do you want to do next? You can:

        🔹 extend the prompt

        🔹 generate an image using one of the processors (Mystic/Gemini/Imagen)
      HTML
    end

    let(:expected_markup) do
      {
        inline_keyboard: [
          [{ text: "Extend prompt", callback_data: "extend_prompt" }],
          [{ text: "Mystic (2 credits)", callback_data: "mystic_image" }],
          [{ text: "Gemini (1 credit)", callback_data: "gemini_image" }],
          [{ text: "Imagen (0 credits)", callback_data: "imagen_image" }]
        ]
      }
    end

    it "replies with MessagePresenter data" do
      expect { dispatch_message(prompt) }
        .to send_telegram_message(bot)
        .with(
          text: a_string_including("Here is your prompt:"),
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

    context "when command is token" do
      let(:command) { "token" }

      context "when token is valid" do
        before { create(:token, code: "valid_token") }

        let(:prompt) { "valid_token" }

        let(:expected_text) do
          "Hello, Rihanna!\n\n✅ Your token has been successfully activated!\n\n🎉 You have received 100 credits.\n"
        end

        it { is_expected.to respond_with_message(expected_text) }
      end

      context "when token is invalid" do
        let(:expected_text) do
          "Sorry, the token you provided is invalid. You can ask administrator for a valid token."
        end

        it { is_expected.to respond_with_message(expected_text) }
      end
    end
  end

  context "when command was not selected" do
    let(:expected_text) do
      "Oops! It looks like you haven’t selected a command yet. Please choose one and follow the instructions."
    end

    it { is_expected.to respond_with_message(expected_text) }
  end
end
