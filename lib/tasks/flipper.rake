namespace :flipper do
  desc "Create and enable :improve_prompt_with_freepik feature for admins"
  task improve_prompt_with_freepik: :environment do
    Flipper.add(:improve_prompt_with_freepik)
    Flipper[:improve_prompt_with_freepik].enable_group(:admins)
    puts "Flipper feature :improve_prompt_with_freepik enabled for :admins group"
  end
end
