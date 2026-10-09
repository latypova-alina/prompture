# What is being moderated and where it belongs. input_text is kept for text inputs only;
# moderatable is nil when there's no record for the input (yet).
Moderation::Input = Struct.new(:input_kind, :command_request, :input_text, :moderatable, keyword_init: true)
