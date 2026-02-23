namespace :deploy do
  task setup: :environment do
    Rake::Task["db:migrate"].invoke
    Rake::Task["telegram:set_commands"].invoke
  end
end
