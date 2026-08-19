RSpec.shared_examples "fal task retriever context" do
  describe "#task_id" do
    it "returns request_id from callback body" do
      expect(context.task_id).to eq("task_1")
    end
  end

  describe "#status" do
    context "when callback status is OK" do
      it "returns COMPLETED" do
        expect(context.status).to eq("COMPLETED")
      end
    end

    context "when callback status indicates failure" do
      let(:callback_status) { "ERROR" }

      it "returns FAILED" do
        expect(context.status).to eq("FAILED")
      end
    end
  end

  describe "#error_reason" do
    context "when callback status is OK" do
      it "returns nil" do
        expect(context.error_reason).to be_nil
      end
    end
  end

  describe "#flagged_message" do
    context "when callback status is OK" do
      it "returns nil" do
        expect(context.flagged_message).to be_nil
      end
    end
  end
end
