extends PanelContainer

var player_data = PlayerData
@export var displayname_label : Label
@export var bank_label : Label
@export var bet_sprite : AnimatedSprite2D
@export var wager_label : Label

func _process(delta: float) -> void:
	displayname_label.text = player_data.username
	bank_label.text = str(player_data.money)
	bet_sprite.frame = player_data.current_bet
	wager_label.text = str(player_data.current_wager)
	apply_effects()
	
func apply_effects():
	displayname_label.modulate = Color.WHITE 
	if Twitch.game_node.state != Twitch.game_node.State.prep and !player_data.betting:
		displayname_label.modulate = Color.DIM_GRAY 
	if Twitch.game_node.state == Twitch.game_node.State.end:
		if player_data.result == PlayerData.Result.win:
			displayname_label.modulate = Color.GREEN
		elif player_data.result == PlayerData.Result.lose:
			displayname_label.modulate = Color.RED 
