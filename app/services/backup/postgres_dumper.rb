require "open3"

module Backup
  class PostgresDumper
    def call
      stdout, stderr, status = Open3.capture3(*cmd, binmode: true)
      raise "pg_dump failed: #{stderr}" unless status.success?

      stdout
    end

    private

    def cmd
      ["pg_dump", ENV.fetch("DATABASE_URL"), "-Fc"]
    end
  end
end
