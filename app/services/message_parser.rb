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
    verify_document_is_image

    document["file_id"]
  end

  def image_id
    return nil unless photo

    photo.max_by { |pic| pic["file_size"] }["file_id"]
  end

  def verify_document_is_image
    return nil unless document

    nil if document["mime_type"].start_with?("image/")
  end
end
