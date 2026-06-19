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

    context "when callback status indicates cancellation" do
      let(:callback_status) { "ERROR" }
      let(:params) do
        super().merge(error: "Invalid status code: 499")
      end

      it "returns CANCELLED" do
        expect(context.status).to eq("CANCELLED")
      end
    end
  end
end
