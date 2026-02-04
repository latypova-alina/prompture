RSpec.shared_examples "command handling" do |command:|
  subject { -> { dispatch_command command } }

  it { is_expected.to respond_with_message(expected_text) }
end
