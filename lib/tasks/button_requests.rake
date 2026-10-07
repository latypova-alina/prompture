namespace :button_requests do
  desc "One-off: mark old PENDING button requests that were never sent to fal or charged as FAILED"
  task fail_abandoned: :environment do
    counts = ButtonRequests::AbandonedCleanup.call

    counts.each { |type, count| puts "#{type}: #{count}" }
    puts "Total: #{counts.values.sum}"
  end
end
