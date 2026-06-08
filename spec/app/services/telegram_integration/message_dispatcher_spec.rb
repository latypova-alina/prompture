require "rails_helper"

describe TelegramIntegration::MessageDispatcher do
  subject { described_class.call(command:, chat_id:, user_message:, name:, locale:) }

  let(:chat_id) { 456 }
  let(:name) { "Rihanna" }
  let(:user_message) { { "text" => "ABC123" } }
  let(:locale) { :en }

  describe ".call" do
    context "when command is activate_token" do
      let(:command) { "activate_token" }
      let(:result) { double(failure?: false) }

      it "calls TokenHandler::HandleToken with correct arguments" do
        expect(TokenHandler::HandleToken)
          .to receive(:call)
          .with(chat_id:, token_code: "ABC123", name:, locale:)
          .and_return(result)

        subject
      end

      context "when interactor fails" do
        let(:error_class) { TokenExpiredError }
        let(:result) do
          double(
            failure?: true,
            error: error_class
          )
        end

        it "raises the error" do
          allow(TokenHandler::HandleToken)
            .to receive(:call)
            .and_return(result)

          expect { subject }.to raise_error(error_class)
        end
      end
    end

    context "when command is not token" do
      let(:command) { "something_else" }
      let(:result) { double(failure?: false) }

      it "calls MediaGenerator::MessageHandler::HandleMessage" do
        expect(MediaGenerator::MessageHandler::HandleMessage)
          .to receive(:call)
          .with(command:, user_message:)
          .and_return(result)

        subject
      end
    end

    context "when command is image_to_video and message contains an image" do
      let(:command) { "image_to_video" }
      let(:user_message) do
        {
          "photo" => [
            { "file_id" => "large", "width" => 1280, "height" => 720, "file_size" => 5000 }
          ]
        }
      end
      let(:result) { double(failure?: false) }

      it "calls ImageMessageHandler::HandleImageMessage" do
        expect(MediaGenerator::MessageHandler::ImageMessageHandler::HandleImageMessage)
          .to receive(:call)
          .with(command:, user_message:)
          .and_return(result)

        subject
      end
    end

    context "when command is image_to_video and message is a prompt" do
      let(:command) { "image_to_video" }
      let(:user_message) { { "text" => "a cat walking in the rain" } }
      let(:result) { double(failure?: false) }

      it "calls ImageToVideoMessageHandler::HandlePromptMessage" do
        expect(MediaGenerator::MessageHandler::ImageToVideoMessageHandler::HandlePromptMessage)
          .to receive(:call)
          .with(command:, user_message:)
          .and_return(result)

        subject
      end
    end

    context "when command is edit_image and message contains an image" do
      let(:command) { "edit_image" }
      let(:user_message) do
        {
          "photo" => [
            { "file_id" => "large", "width" => 1280, "height" => 720, "file_size" => 5000 }
          ]
        }
      end
      let(:result) { double(failure?: false) }

      it "calls EditImageMessageHandler::HandleImageMessage" do
        expect(MediaGenerator::MessageHandler::EditImageMessageHandler::HandleImageMessage)
          .to receive(:call)
          .with(command:, user_message:)
          .and_return(result)

        subject
      end
    end

    context "when command is edit_image and message is a prompt" do
      let(:command) { "edit_image" }
      let(:user_message) { { "text" => "make it brighter" } }
      let(:result) { double(failure?: false) }

      it "calls EditImageMessageHandler::HandlePromptMessage" do
        expect(MediaGenerator::MessageHandler::EditImageMessageHandler::HandlePromptMessage)
          .to receive(:call)
          .with(command:, user_message:)
          .and_return(result)

        subject
      end
    end
  end
end
