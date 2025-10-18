require "rails_helper"

shared_context "check task interactor" do
  let(:task_id) { "abc123" }
  let(:client) { instance_double(retriever_class) }
  let(:image_url) { "https://example.com/image.png" }

  describe "#call" do
    context "when task eventually completes" do
      before do
        allow(retriever_class).to receive(:new).with(task_id).and_return(client)
        allow(client).to receive(:status).and_return("PROCESSING", "PROCESSING", "COMPLETED")
        allow(client).to receive(:image_url).and_return(image_url)
        allow_any_instance_of(described_class).to receive(:sleep)
      end

      it "sets context.image_url to the client image_url" do
        expect(interactor).to be_a_success
        expect(interactor.image_url).to eq(image_url)
      end

      it "calls status multiple times until completed" do
        interactor
        expect(client).to have_received(:status).at_least(3).times
      end
    end

    context "when task fails" do
      before do
        allow(retriever_class).to receive(:new).with(task_id).and_return(client)
        allow(client).to receive(:status).and_return("FAILED")
        allow(client).to receive(:image_url).and_return(image_url)
        allow_any_instance_of(described_class).to receive(:sleep)
      end

      it "raises Freepik::ImageGenerationFailed" do
        expect { interactor }.to raise_error(Freepik::ImageGenerationFailed)
      end
    end

    context "when task never completes within max attempts" do
      before do
        allow(retriever_class).to receive(:new).with(task_id).and_return(client)
        allow(client).to receive(:status).and_return("PROCESSING")
        allow(client).to receive(:image_url).and_return(image_url)
        allow_any_instance_of(described_class).to receive(:sleep)
      end

      it "calls client.status MAX_ATTEMPTS times" do
        expect(client).to receive(:status).exactly(described_class::MAX_ATTEMPTS).times.and_return("PROCESSING")
        allow_any_instance_of(described_class).to receive(:sleep)
        expect { interactor }.to raise_error(Freepik::ImageGenerationTimeout)
      end
    end
  end
end
