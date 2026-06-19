require "rails_helper"

describe Generator::Media::Interim::MessageSender do
  subject(:call_service) { described_class.call(request:) }

  let(:request) { create(:button_video_processing_request, interim_tg_message_id: nil) }
  let(:response_sender) { instance_double(Generator::Media::Interim::ResponseSender, tg_message_id: 55_002) }

  before do
    allow(Generator::Media::Interim::ResponseSender)
      .to receive(:new)
      .with(request:)
      .and_return(response_sender)
  end

  it "stores interim telegram message id on request" do
    expect { call_service }
      .to change { request.reload.interim_tg_message_id }
      .from(nil)
      .to(55_002)
  end
end
