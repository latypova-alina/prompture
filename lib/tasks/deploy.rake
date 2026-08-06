namespace :deploy do
  task setup: :environment do
    Rake::Task["db:migrate"].invoke
    Rake::Task["telegram:sync_commands"].invoke
    Rake::Task["flipper:sync"].invoke
  end
end
