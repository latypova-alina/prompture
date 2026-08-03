CREDIT_PACKS = Rails.application.config_for(:credit_packs).deep_symbolize_keys
TEST_CREDIT_PACKS = CREDIT_PACKS.transform_values { |pack| pack.merge(stars: 1) }
