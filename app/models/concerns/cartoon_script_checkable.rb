module CartoonScriptCheckable
  def cartoon_script?
    try(:category) == ContentCategory::BLOOMY_CARTOON_SCRIPT
  end

  def cartoon_shorts_script?
    try(:category) == ContentCategory::CARTOON_BLOOMY_SHORTS_SCRIPT
  end

  def cartoon_shorts_complex_script?
    try(:category) == ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT
  end

  def cartoon_shorts_format?
    cartoon_shorts_script? || cartoon_shorts_complex_script?
  end

  def cartoon_workflow?
    cartoon_script? || cartoon_shorts_format?
  end
end
