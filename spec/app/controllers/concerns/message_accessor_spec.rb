require "rails_helper"

describe MessageAccessor do
  let(:dummy_class) do
    Class.new do
      include MessageAccessor
      attr_accessor :user_message
    end
  end

  subject(:instance) do
    dummy_class.new.tap do |obj|
      obj.user_message = "hello world"
    end
  end

  describe "#message_parser" do
    subject { instance.send(:message_parser) }

    it { should be_a(MessageParser) }
    it { should have_attributes(message: "hello world") }
  end
end
