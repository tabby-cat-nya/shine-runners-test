extends Node2D
class_name GM

enum State {
	prep,
	game,
	end
}

@export var shyguy_mode : bool
@export var autoplay_mode : bool = false
@export var max_shinies : int = 9
var player_spawns : Array[Node]
var starting_shine_spawns : Array[Node]
static var shine_spawns : Array[Node]
var players : Array[Player]
var autoplay_timer : float = 20
var autoreset_timer : float = 20
var bets_closed : bool = false

@export_group("Node References")
@export var player_spawns_nodes : Node2D
@export var starting_shine_nodes : Node2D
@export var shine_nodes : Node2D
@export var scorecard_container : VBoxContainer 
@export var elim_timer_label : Label
@export var game_timer_label : Label
@export var chime_player : AudioStreamPlayer
@export var music_player : AudioStreamPlayer
@export var win_player : AudioStreamPlayer
@export var flyover_player : AudioStreamPlayer
@export var intro_player : AudioStreamPlayer
@export var start_button : Button

var state : State = State.prep
var game_timer : float = 0
var elim_timer : float = 60
var shiny_spawn_timer : float = 5
var shiny_count : int = 4
var play_next_chime : float = 5


func _ready() -> void:
	player_spawns = player_spawns_nodes.get_children()
	starting_shine_spawns = starting_shine_nodes.get_children()
	shine_spawns = shine_nodes.get_children()
	createPlayers()
	spawn_shinies()

func createPlayers():
	for i in range(8):
		spawnPlayer(i)

func spawnPlayer(id : int):
	var player : Player = load("res://player.tscn").instantiate()
	var scorecard : Scorecard = load("res://scorecard.tscn").instantiate() 
	
	player.id = id
	scorecard.id = id
	if(shyguy_mode):
		player.id += 12
		scorecard.id += 12
	player.position = player_spawns[id].position
	player.scorecard = scorecard
	player.setup()
	players.append(player)
	add_child(player)
	scorecard_container.add_child(scorecard)

func spawn_shinies():
	for i in range(4):
		var shiny = load("res://shiny.tscn").instantiate()
		shiny.position = starting_shine_spawns[i].position
		add_child(shiny)

func spawn_new_shiny():
	var shiny = load("res://shiny.tscn").instantiate()
	var ranPos = randi_range(0,shine_spawns.size()-1)
	shiny.position = shine_spawns[ranPos].position
	shiny_spawn_timer = 5
	shiny_count += 1
	add_child(shiny)
	


func _process(delta: float) -> void:
	if (state == State.prep and autoplay_mode):
		autoplay_timer -= delta
		if autoplay_timer <= 0 and not bets_closed:
			bets_closed = true
			autoplay_timer == 0
			_on_start_button_pressed()
	if (state == State.end and autoplay_mode):
		autoreset_timer -= delta
		if autoreset_timer <= 0:
			_on_reset_button_pressed()
	if(state == State.game):
		elim_timer -= delta
		game_timer += delta
		
		shiny_spawn_timer -= delta
		if(shiny_spawn_timer<=0 and shiny_count < max_shinies):
			spawn_new_shiny()
		if(elim_timer <= 0):
			elim_players()
	update_ui()
	
	if elim_timer < play_next_chime:
		if play_next_chime > 0:
			play_next_chime -= 1
		chime_player.play(0.9)

func elim_players():
	var lowestScore : int = 99999
	var highestScore : int = 0
	for player in players:
		if player.score < lowestScore and player.alive:
			lowestScore = player.score
		if player.score > highestScore and player.alive:
			highestScore = player.score
	for player in players:
		if player.score == lowestScore and player.alive and player.score != highestScore:
			player.alive = false
	elim_timer = 30
	play_next_chime = 5
	check_win_con()

func check_win_con():
	var gamers : int = 0
	for player in players:
		if player.alive:
			gamers += 1
	if gamers == 1:
		music_player.stop()
		win_player.play()
		state = State.end

func update_ui():
	elim_timer_label.text = format_time(elim_timer, false)
	game_timer_label.text = format_time(game_timer, true)
	if (state == State.prep and autoplay_mode and not bets_closed):
		elim_timer_label.text = "Bets close: " + format_time(autoplay_timer, false)
	if (state == State.end and autoplay_mode):
		elim_timer_label.text = "New round: " + format_time(autoreset_timer, false)
	order_scoreboard()

func order_scoreboard():
	pass
	

func format_time(time : float, include_minutes : bool) -> String:
	var minutes : int = floor(time / 60)
	var seconds : int = time - 60*minutes
	var millis : float = time - floor(time)
	var millis_2dp : int = floor(millis*100)
	if(include_minutes):
		return str(minutes).pad_zeros(2) +":"+ str(seconds).pad_zeros(2)+"."+str(millis_2dp).pad_zeros(2)
	else:
		return str(seconds).pad_zeros(2)+"."+str(millis_2dp).pad_zeros(2)


func _on_intro_player_finished() -> void:
	state = State.game
	music_player.play()
	for player in players:
		player.lifetime = 0
		player.start_engine()
	


func _on_start_button_pressed() -> void:
	flyover_player.stop()
	intro_player.play()
	start_button.disabled = true


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
