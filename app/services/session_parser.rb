SessionParser = Struct.new(:image_prompt, :image_url, :chat_id) do
  def image_prompt
    self[:image_prompt].to_s
  end

  def image_url
    self[:image_url].to_s
  end

  def chat_id
    self[:chat_id].to_i
  end
end
