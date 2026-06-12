module CartoonScriptCheckable
  def cartoon_script?
    category == ContentCategory::CARTOON_SCRIPT
  end

  def cartoon_shorts_script?
    category == ContentCategory::CARTOON_SHORTS_SCRIPT
  end

  def cartoon_workflow?
    cartoon_script? || cartoon_shorts_script?
  end
end
