module Flipper
  class Synchronizer
    include Interactor::Organizer

    organize SyncDesiredFlags, RemoveStaleFlags, UpdateManagedRegistry
  end
end
