require "rails_helper"

describe Generator::TaskCreatorSelectorJob do
  let(:job) { described_class.new }

  let(:image_prompt) { "cute white kitten" }
  let(:image_url) { "http://example.com/img.png" }
  let(:chat_id) { 123 }

  before do
    described_class::PROMPT_EXTENSION_JOBS.each_value do |klass|
      allow(klass).to receive(:perform_async)
    end

    described_class::IMAGE_GENERATOR_JOBS.each_value do |klass|
      allow(klass).to receive(:perform_async)
    end

    described_class::VIDEO_GENERATOR_JOBS.each_value do |klass|
      allow(klass).to receive(:perform_async)
    end
  end

  describe "#perform" do
    context "when button_request is for prompt extension" do
      it "calls the correct Prompt Extension job" do
        described_class::PROMPT_EXTENSION_JOBS.each do |key, klass|
          job.perform(image_prompt, image_url, key, chat_id)

          expect(klass).to have_received(:perform_async)
            .with(image_prompt, chat_id)
        end
      end
    end

    context "when button_request is for image generation" do
      it "calls the correct Image Generator job" do
        described_class::IMAGE_GENERATOR_JOBS.each do |key, klass|
          job.perform(image_prompt, image_url, key, chat_id)

          expect(klass).to have_received(:perform_async)
            .with(image_prompt, key, chat_id)
        end
      end
    end

    context "when button_request is for video generation" do
      it "calls the correct Video Generator job" do
        described_class::VIDEO_GENERATOR_JOBS.each do |key, klass|
          job.perform(image_prompt, image_url, key, chat_id)

          expect(klass).to have_received(:perform_async)
            .with(image_prompt, image_url, key, chat_id)
        end
      end
    end

    context "when button_request is unknown" do
      it "does nothing" do
        unknown = "does_not_exist"

        job.perform(image_prompt, image_url, unknown, chat_id)

        described_class::PROMPT_EXTENSION_JOBS.each_value do |klass|
          expect(klass).not_to have_received(:perform_async)
        end

        described_class::IMAGE_GENERATOR_JOBS.each_value do |klass|
          expect(klass).not_to have_received(:perform_async)
        end

        described_class::VIDEO_GENERATOR_JOBS.each_value do |klass|
          expect(klass).not_to have_received(:perform_async)
        end
      end
    end
  end
end
