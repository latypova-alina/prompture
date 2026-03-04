require "rails_helper"

describe Generator::Media::Image::TaskCreatorJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_image_processing_request, status: "PENDING") }

  describe "#perform" do
    context "when task creator succeeds" do
      before do
        allow(
          Generator::Media::Image::CreateTask::TaskCreator
        ).to receive(:call)
      end

      it "calls TaskCreator with loaded request" do
        expect(
          Generator::Media::Image::CreateTask::TaskCreator
        ).to receive(:call).with(button_request)

        perform_job
      end

      it "does not call FailureHandler" do
        expect(
          Generator::Media::Image::CreateTask::FailureHandler
        ).not_to receive(:call)

        perform_job
      end
    end

    context "when Freepik::ResponseError is raised" do
      before do
        allow(
          Generator::Media::Image::CreateTask::TaskCreator
        ).to receive(:call)
          .and_raise(Freepik::ResponseError)
      end

      it "calls FailureHandler with request" do
        expect(
          Generator::Media::Image::CreateTask::FailureHandler
        ).to receive(:call).with(button_request)

        perform_job
      end
    end
  end
end
