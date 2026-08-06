namespace :flipper do
  task sync: :environment do
    Flipper::Synchronizer.call(desired: Flipper::DesiredState.call)
  end
end
