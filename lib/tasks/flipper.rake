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
end
