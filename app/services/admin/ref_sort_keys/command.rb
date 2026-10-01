module Admin
  module RefSortKeys
    class Command < Base
      # Zero-padded so "CommandX#9" sorts before "CommandX#10".
      def expression
        table = klass.quoted_table_name
        Arel.sql("#{table}.command_request_type || '#' || LPAD(#{table}.command_request_id::text, 20, '0')")
      end
    end
  end
end
