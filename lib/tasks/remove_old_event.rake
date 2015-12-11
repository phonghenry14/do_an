desc "remove old event"
task remove_old_event: :environment do
  Event.remove_old_event
end
