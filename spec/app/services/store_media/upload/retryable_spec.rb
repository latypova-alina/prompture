require "rails_helper"

describe StoreMedia::Upload::Retryable do
  subject(:retrier) { retrier_class.new }

  let(:retrier_class) do
    Class.new do
      include StoreMedia::Upload::Retryable

      def call(max_attempts: 3, on: StandardError, &block)
        with_retries(max_attempts:, on:, &block)
      end
    end
  end

  before do
    allow(retrier).to receive(:sleep)
  end

  it "returns the block's result when it succeeds on the first attempt" do
    expect(retrier.call { "success" }).to eq("success")
  end

  it "retries until the block succeeds" do
    attempts = 0

    result = retrier.call do
      attempts += 1
      raise StandardError, "boom" if attempts < 3

      "success"
    end

    expect(result).to eq("success")
    expect(attempts).to eq(3)
  end

  it "gives up and raises after max_attempts" do
    attempts = 0

    expect do
      retrier.call(max_attempts: 2) do
        attempts += 1
        raise StandardError, "boom"
      end
    end.to raise_error(StandardError, "boom")

    expect(attempts).to eq(2)
  end

  it "only retries the exception class given in on:" do
    expect do
      retrier.call(on: ArgumentError) { raise StandardError, "boom" }
    end.to raise_error(StandardError, "boom")
  end
end
