require "rails_helper"

describe Generator::Media::Video::TaskCreatorJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_video_processing_request, status: "PENDING") }

  describe "#perform" do
    context "when task creator succeeds" do
      before do
        allow(
          Generator::Media::Video::CreateTask::TaskCreator
        ).to receive(:call)
      end

      it "calls TaskCreator with loaded request" do
        expect(
          Generator::Media::Video::CreateTask::TaskCreator
        ).to receive(:call).with(button_request)

        perform_job
      end

      it "does not call FailureHandler" do
        expect(
          Generator::Media::Video::CreateTask::FailureHandler
        ).not_to receive(:call)

        perform_job
      end
    end

    context "when Freepik::ResponseError is raised" do
      let(:error) { Freepik::ResponseError.new }

      before do
        allow(
          Generator::Media::Video::CreateTask::TaskCreator
        ).to receive(:call)
          .and_raise(error)
      end

      it "calls FailureHandler with request" do
        expect(
          Generator::Media::Video::CreateTask::FailureHandler
        ).to receive(:call).with(button_request, error:)

        perform_job
      end
    end
  end
end
