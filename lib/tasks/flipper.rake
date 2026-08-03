namespace :flipper do
  desc "Remove :improve_prompt_with_freepik feature flag"
  task remove_improve_prompt_with_freepik: :environment do
    Flipper.remove(:improve_prompt_with_freepik)
    puts "Flipper feature :improve_prompt_with_freepik removed"
  end

  desc "Remove :prompt_to_audio feature flag"
  task remove_prompt_to_audio: :environment do
    Flipper.remove(:prompt_to_audio)
    puts "Flipper feature :prompt_to_audio removed"
  end

  desc "Remove :image_to_video feature flag"
  task remove_image_to_video: :environment do
    Flipper.remove(:image_to_video)
    puts "Flipper feature :image_to_video removed"
  end

  desc "Enable :stars_payments feature flag for the :admins group"
  task enable_stars_payments_for_admins: :environment do
    Flipper.enable_group(:stars_payments, :admins)
    puts "Flipper feature :stars_payments enabled for :admins group"
  end

  desc "Enable :stars_payments feature flag for everyone"
  task enable_stars_payments: :environment do
    Flipper.enable(:stars_payments)
    puts "Flipper feature :stars_payments enabled for everyone"
  end

  desc "Enable :test_credit_pack feature flag for the :admins group"
  task enable_test_credit_pack_for_admins: :environment do
    Flipper.enable_group(:test_credit_pack, :admins)
    puts "Flipper feature :test_credit_pack enabled for :admins group"
  end
end
