module CartoonScriptCheckable
  def cartoon_script?
    return false unless respond_to?(:category)

    category == ContentCategory::CARTOON_SCRIPT
  end
end
