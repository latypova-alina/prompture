RSpec.shared_examples "message handling" do
  context "when command is known" do
    include_context "telegram callback setup"

    before do
      setup_parent_message
      allow(Moderation::OpenaiModeration).to receive(:flagged?).and_return(false)
    end

    let(:expected_message) do
      <<~HTML.strip
        <blockquote>cute white kitten</blockquote>

        What do you want to do next? You can:

        🔹 extend the prompt

        🔹 generate an image using one of the processors (Mystic/Gemini/Imagen)
      HTML
    end

    let(:expected_markup) do
      {
        inline_keyboard: [
          [{ text: "Extend prompt (1 credit)", callback_data: "extend_prompt" }],
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
          text: a_string_including("<blockquote>cute white kitten</blockquote>"),
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

    context "when message is flagged by moderation" do
      before do
        allow(Moderation::OpenaiModeration).to receive(:flagged?).and_return(true)
      end

      let(:expected_text) do
        "Your message cannot be processed because it violates our content policy. See the rules: /prompt_policy"
      end

      it { is_expected.to respond_with_message(expected_text) }
    end

    context "when command is activate_token" do
      let(:command) { "activate_token" }

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

    context "when message contains an image URL and command is image_to_video" do
      let(:command) { "image_to_video" }
      let!(:command_request) { create(:command_image_to_video_request, chat_id:) }
      let(:image_url) { "https://cdn-magnific.freepik.com/image.png" }
      let(:prompt) { image_url }

      let(:expected_text) do
        "#{I18n.t('telegram_webhooks.message.image_message_reply')}\n"
      end

      let(:image_url_options) do
        {
          "entities" => [{ "offset" => 0, "length" => image_url.length, "type" => "url" }]
        }
      end

      let(:user_message) { dispatch_message(prompt, image_url_options) }

      before do
        allow_any_instance_of(RecordValidators::UrlInspector::ImageUrlInspector).to receive(:valid?).and_return(true)
        allow(StoreImage::Job).to receive(:perform_async)
      end

      it "enqueues StoreImage::Job" do
        user_message

        expect(StoreImage::Job).to have_received(:perform_async)
      end

      context "when the image URL is invalid" do
        before do
          allow_any_instance_of(RecordValidators::UrlInspector::ImageUrlInspector).to receive(:valid?).and_return(false)
        end

        let(:expected_text) do
          I18n.t("errors.image_url_invalid")
        end

        it { is_expected.to respond_with_message(expected_text) }
      end
    end

    context "when message contains a picture and command is image_to_video" do
      let(:command) { "image_to_video" }
      let!(:command_request) { create(:command_image_to_video_request, chat_id:) }
      let(:prompt) { nil }
      let(:picture_options) do
        {
          "photo" => [
            { "file_id" => "small", "width" => 320, "height" => 240, "file_size" => 1000 },
            { "file_id" => "large", "width" => 1280, "height" => 720, "file_size" => 5000 }
          ]
        }
      end
      let(:user_message) { dispatch_message(prompt, picture_options) }

      before do
        allow(StoreImage::Job).to receive(:perform_async)
      end

      it "enqueues StoreImage::Job" do
        user_message

        expect(StoreImage::Job).to have_received(:perform_async)
      end
    end

    context "when message contains a file and command is image_to_video" do
      let(:command) { "image_to_video" }
      let!(:command_request) { create(:command_image_to_video_request, chat_id:) }
      let(:prompt) { nil }
      let(:file_options) do
        {
          "document" => {
            "file_name" => "image.png",
            "mime_type" => "image/png",
            "file_id" => "BQACAgIAAxkBAAIHp_file",
            "file_size" => 1_226_192
          }
        }
      end
      let(:user_message) { dispatch_message(prompt, file_options) }

      before do
        allow(StoreImage::Job).to receive(:perform_async)
      end

      it "enqueues StoreImage::Job" do
        user_message

        expect(StoreImage::Job).to have_received(:perform_async)
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
