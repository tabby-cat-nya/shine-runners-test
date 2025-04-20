extends Node2D

@export var shyguy_mode : bool
var player_spawns : Array[Node]
var starting_shine_spawns : Array[Node]
var shine_spawns : Array[Node]
var players : Array[Player]

@export_group("Node References")
@export var player_spawns_nodes : Node2D
@export var starting_shine_nodes : Node2D
@export var shine_nodes : Node2D
@export var scorecard_container : VBoxContainer 
@export var elim_timer_label : Label
@export var game_timer_label : Label

var game_timer : float = 0
var elim_timer : float = 60

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
		shiny.position = shine_spawns[i].position
		add_child(shiny)

func _process(delta: float) -> void:
	elim_timer -= delta
	game_timer += delta
	update_ui()

func update_ui():
	elim_timer_label.text = format_time(elim_timer, false)
	game_timer_label.text = format_time(game_timer, true)
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
