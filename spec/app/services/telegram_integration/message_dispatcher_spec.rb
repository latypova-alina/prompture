require "rails_helper"

describe TelegramIntegration::MessageDispatcher do
  subject { described_class.call(command:, chat_id:, user_message:, name:) }

  let(:chat_id) { 456 }
  let(:name) { "Rihanna" }
  let(:user_message) { { "text" => "ABC123" } }

  describe ".call" do
    context "when command is token" do
      let(:command) { "token" }
      let(:result) { double(failure?: false) }

      it "calls TokenHandler::HandleToken with correct arguments" do
        expect(TokenHandler::HandleToken)
          .to receive(:call)
          .with(chat_id:, token_code: "ABC123", name:)
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

      it "calls MessageHandler::HandleMessage" do
        expect(MessageHandler::HandleMessage)
          .to receive(:call)
          .with(command:, user_message:)
          .and_return(result)

        subject
      end
    end
  end
end
