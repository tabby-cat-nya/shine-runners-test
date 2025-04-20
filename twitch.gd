extends Node

func _ready() -> void:
	VerySimpleTwitch.get_token_and_login_chat()
	VerySimpleTwitch.chat_message_received.connect(print_chatter_message)
	
func _process(delta: float) -> void:
	pass
	
func print_chatter_message(chatter: VSTChatter):
	print("Message received from %s: %s" % [chatter.tags.display_name, chatter.message])
