require "rails_helper"

describe BuildMysticImage::CheckStatus do
  subject(:interactor) { described_class.call(task_id:) }

  let(:task_id) { "abc123" }
  let(:mystic_client) { instance_double(Clients::Mystic::TaskRetriever) }

  describe "#call" do
    context "when task eventually completes" do
      before do
        allow(Clients::Mystic::TaskRetriever).to receive(:new).with(task_id).and_return(mystic_client)
        allow(mystic_client).to receive(:status).and_return("PROCESSING", "PROCESSING", "COMPLETED")
        allow(mystic_client).to receive(:image_url).and_return("https://example.com/image.png")
        allow_any_instance_of(described_class).to receive(:sleep)
      end

      it "sets context.image_url to the mystic_client image_url" do
        expect(interactor).to be_a_success
        expect(interactor.image_url).to eq("https://example.com/image.png")
      end

      it "calls status multiple times until completed" do
        described_class.call(task_id:)
        expect(mystic_client).to have_received(:status).at_least(3).times
      end
    end

    context "when task fails" do
      before do
        allow(Clients::Mystic::TaskRetriever).to receive(:new).with(task_id).and_return(mystic_client)
        allow(mystic_client).to receive(:status).and_return("FAILED")
        allow(mystic_client).to receive(:image_url).and_return("https://example.com/image.png")
        allow_any_instance_of(described_class).to receive(:sleep)
      end

      it "raises Mystic::ImageGenerationFailed" do
        expect { interactor }.to raise_error(Mystic::ImageGenerationFailed)
      end
    end

    context "when task never completes within max attempts" do
      before do
        allow(Clients::Mystic::TaskRetriever).to receive(:new).with(task_id).and_return(mystic_client)
        allow(mystic_client).to receive(:status).and_return("PROCESSING")
        allow(mystic_client).to receive(:image_url).and_return("https://example.com/image.png")
        allow_any_instance_of(described_class).to receive(:sleep)
      end

      it "calls mystic_client.status MAX_ATTEMPTS times" do
        expect(mystic_client).to receive(:status).exactly(described_class::MAX_ATTEMPTS).times.and_return("PROCESSING")
        allow_any_instance_of(described_class).to receive(:sleep)
        expect { interactor }.to raise_error(Mystic::ImageGenerationTimeout)
      end
    end
  end
end
