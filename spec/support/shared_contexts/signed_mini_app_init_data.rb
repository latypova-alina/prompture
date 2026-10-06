RSpec.shared_context "signed mini app init data" do
  let(:bot_token) { "test-bot-token" }
  let(:telegram_user_id) { 110_542_578 }

  let(:signed_params) do
    { "auth_date" => "1700000000", "user" => { id: telegram_user_id, first_name: "Alina" }.to_json }
  end

  let(:init_data) do
    data_check_string = signed_params.sort.map { |key, value| "#{key}=#{value}" }.join("\n")
    secret_key = OpenSSL::HMAC.digest("SHA256", "WebAppData", bot_token)
    hash = OpenSSL::HMAC.hexdigest("SHA256", secret_key, data_check_string)

    URI.encode_www_form(signed_params.merge("hash" => hash))
  end

  before { stub_const("ENV", ENV.to_hash.merge("TELEGRAM_BOT_TOKEN" => bot_token)) }
end
