require "rails_helper"

describe SessionAccessor do
  let(:dummy_class) do
    Class.new do
      include SessionAccessor
      attr_accessor :session
    end
  end

  subject(:instance) do
    dummy_class.new.tap do |obj|
      obj.session = { "user_id" => 123, "token" => "abc123" }
    end
  end

  describe "#safe_session" do
    subject { instance.send(:safe_session) }

    it { is_expected.to eq({ user_id: 123, token: "abc123" }) }
  end

  describe "#session_parser" do
    let(:parser_double) { instance_double(SessionParser) }

    subject { instance.send(:session_parser) }
    it "creates a SessionParser with the safe_session data" do
      # You can stub SessionParser if it does complex work
      expect(SessionParser).to receive(:new).with(user_id: 123, token: "abc123").and_return(parser_double)

      expect(subject).to eq(parser_double)
    end
  end
end
