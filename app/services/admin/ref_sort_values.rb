module Admin
  # For one request class and sort key: the extra SQL expression to pluck next to id/created_at
  # (nil when the value is derived in Ruby), and how a plucked value becomes the ref's sort value.
  class RefSortValues
    include Memery

    EXPRESSIONS = {
      "user" => :user_expression,
      "status" => :status_expression,
      "category" => :category_expression,
      "processor" => :processor_expression,
      "cost" => :processor_expression,
      "command" => :command_expression
    }.freeze

    VALUES = {
      "created" => :created_value,
      "type" => :type_value,
      "kind" => :kind_value,
      "processor" => :processor_value,
      "cost" => :cost_value
    }.freeze

    def initialize(klass:, key:)
      @klass = klass
      @key = key
    end

    def expression
      method_name = EXPRESSIONS[key]
      send(method_name) if method_name
    end

    def value(plucked, created_at)
      method_name = VALUES[key]
      method_name ? send(method_name, plucked, created_at) : plucked
    end

    private

    attr_reader :klass, :key

    def user_expression
      Arel.sql(Admin::UserNameSql.call(klass))
    end

    def status_expression
      Arel.sql("UPPER(#{klass.quoted_table_name}.status)") if column?("status")
    end

    def category_expression
      :category if column?("category")
    end

    def processor_expression
      :processor if column?("processor")
    end

    # Zero-padded so "CommandX#9" sorts before "CommandX#10".
    def command_expression
      table = klass.quoted_table_name
      Arel.sql("#{table}.command_request_type || '#' || LPAD(#{table}.command_request_id::text, 20, '0')")
    end

    def created_value(_plucked, created_at)
      created_at
    end

    def type_value(_plucked, _created_at)
      klass.name
    end

    def kind_value(_plucked, _created_at)
      Admin::CommandRequestsQuery::TYPES.include?(klass) ? "Command" : "Button"
    end

    def processor_value(plucked, _created_at)
      plucked || fixed_processor
    end

    def cost_value(plucked, _created_at)
      cost_for(plucked)
    end

    def column?(name)
      klass.column_names.include?(name)
    end

    # ButtonExtendPromptRequest has no processor column, just a fixed #processor.
    memoize def fixed_processor
      klass.new.try(:processor)
    end

    memoize def cost_for(processor)
      Admin::ButtonRequestCost.call(klass, processor)
    end
  end
end
