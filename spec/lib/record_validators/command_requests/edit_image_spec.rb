require "rails_helper"

describe RecordValidators::CommandRequests::EditImage do
  subject(:validator) do
    described_class.new(
      command_request:,
      message_text:,
      picture_id:
    )
  end

  let(:command_request) { create(:command_edit_image_request) }
  let(:message_text) { "make it brighter" }
  let(:picture_id) { nil }

  before do
    picture_message = create(
      :user_picture_message,
      command_request:,
      parent_request: command_request
    )
    create(:stored_image, source_message: picture_message, image_url: "https://internal.example/image.png")
  end

  it "does not raise an error" do
    expect { validator.validate }.not_to raise_error
  end

  context "when prompt was already provided" do
    let(:command_request) { create(:command_edit_image_request, prompt: "existing prompt") }

    it "raises MessageTypeError" do
      expect { validator.validate }.to raise_error(MessageTypeError)
    end
  end

  context "when image is not ready" do
    before do
      StoredImage.delete_all
    end

    it "raises ImageNotReadyError" do
      expect { validator.validate }.to raise_error(ImageNotReadyError)
    end
  end

  context "when no image was sent yet" do
    let(:command_request) { create(:command_edit_image_request) }

    before do
      UserPictureMessage.delete_all
      UserImageUrlMessage.delete_all
      StoredImage.delete_all
    end

    it "raises MessageTypeError" do
      expect { validator.validate }.to raise_error(MessageTypeError)
    end
  end
end
