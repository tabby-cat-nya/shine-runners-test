extends Node

var save : Save
var save_path : String = "C:\\Users\\Tabby\\Documents\\Godot\\Projects\\shine-runners-test\\data\\save.tres"
var game_node : Node2D
var current_winner : int = -1

func _ready() -> void:
	VerySimpleTwitch.get_token_and_login_chat()
	VerySimpleTwitch.chat_message_received.connect(handle_message)
	game_node = get_node("/root/Game")
	#test_save()
	
func _process(delta: float) -> void:
	pass
	
func handle_message(chatter: VSTChatter):
	print("Message received from %s: %s" % [chatter.tags.display_name, chatter.message])
	var found_player : bool = false
	for player in save.player_database:
		if(chatter.tags.user_id == player.user_id):
			found_player = true
			# do whatever we want for a found player
			player.playing = true
			var splits : PackedStringArray = chatter.message.split(" ")
			#print(splits)
			if splits[0] == "!bet" and player.betting == false and splits.size() == 3 and game_node.state == game_node.State.prep: #player has not already submitted a bet
				if int(splits[1]) <= player.money and player.money >= 0: #they have the money to bet
					if int(splits[2]) < 8: #they are betting on a valid character
						player.betting = true
						player.money -= int(splits[1])
						player.current_wager = int(splits[1])
						player.current_bet = int(splits[2])
			
	if(not found_player):
		create_new_player(chatter.tags.user_id, chatter.tags.display_name)
	game_node.load_userboard()

func create_new_player(id : String, name : String) -> PlayerData:
	var player : PlayerData = PlayerData.new()
	player.user_id = id
	player.username = name
	player.money = 100
	player.playing = true
	save.player_database.append(player)
	return player

func start_round():
	for data in save.player_database:
		if data.money < 100:
			data.money = clampi(data.money + 5, 0, 100)


func end_round(winning_character : int):
	current_winner = winning_character
	for data in save.player_database:
		if data.current_bet == winning_character:
			data.money += data.current_wager*8
			data.result = PlayerData.Result.win
		else: 
			data.result = PlayerData.Result.lose
		if data.betting == false:
			data.result = PlayerData.Result.none
		data.current_bet = 20
		data.betting = false
		data.current_wager = 0 
	save_database()


#do before the round
func load_database():
	if ResourceLoader.exists(save_path):
		save = ResourceLoader.load(save_path)
	else:
		save = Save.new()
		save.player_database = []

#do just before every reset 
func save_database():
	ResourceSaver.save(save, save_path)

func test_save():
	save = Save.new()
	var player1 : PlayerData = PlayerData.new()
	player1.user_id = "1"
	player1.money = 100
	save.player_database = [player1]
	#save.player_database.append(player1)
	var player2 : PlayerData = PlayerData.new()
	player2.user_id = "22"
	player2.money = 200
	save.player_database.append(player2)
	var player3 : PlayerData = PlayerData.new()
	player3.user_id = "333"
	player3.money = 300
	save.player_database.append(player3)
	ResourceSaver.save(save, save_path)
