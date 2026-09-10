module Backup
  class ObjectKeyBuilder
    FOLDER = "backups/db".freeze

    def call
      "#{FOLDER}/#{Time.now.utc.strftime('%Y%m%d-%H%M%S')}.dump"
    end
  end
end
