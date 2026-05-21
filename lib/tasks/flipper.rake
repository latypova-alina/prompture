namespace :flipper do
  desc "Create and enable :improve_prompt_with_freepik feature for admins"
  task improve_prompt_with_freepik: :environment do
    Flipper.add(:improve_prompt_with_freepik)
    Flipper[:improve_prompt_with_freepik].enable_group(:admins)
    puts "Flipper feature :improve_prompt_with_freepik enabled for :admins group"
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
end
