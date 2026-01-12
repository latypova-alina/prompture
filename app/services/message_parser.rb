MessageParser = Struct.new(:message) do
  def message_text
    message["text"]
  end

  def picture_id
    image_as_document_id || image_id
  end

  def chat_id
    message["chat"]["id"]
  end

  private

  def photo
    message["photo"]
  end

  def document
    message["document"]
  end

  def image_as_document_id
    return nil unless document

    document["file_id"] if document_is_image?
  end

  def image_id
    return nil unless photo

    photo.max_by { |pic| pic["file_size"] }["file_id"]
  end

  def document_is_image?
    document["mime_type"].start_with?("image/")
  end
end
