module Admin
  # A sortable column header: links to the same page with all current filters, sorted by `key`.
  # Clicking the active column flips its direction; any other column starts in its first direction.
  module SortLinksHelper
    ARROWS = { "asc" => "▲", "desc" => "▼" }.freeze

    def sortable_header(label, key, sort)
      active = sort.key == key
      direction = active ? flipped_direction(sort) : Admin::SortParams.first_direction(key)
      text = active ? "#{label} #{ARROWS.fetch(sort.direction)}" : label

      link_to text, sort_path(key, direction), class: ["sortable", ("sortable-active" if active)]
    end

    private

    def flipped_direction(sort)
      sort.desc? ? "asc" : "desc"
    end

    def sort_path(key, direction)
      query = request.query_parameters.except("page").merge("sort" => key, "direction" => direction)
      "#{request.path}?#{query.to_query}"
    end
  end
end
