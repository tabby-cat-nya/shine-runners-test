extends RigidBody2D
class_name Player

var id : int = 0
var score : int = 0
var scorecard : Scorecard
var alive : bool = true
var lifetime : float = 0
@export var start_speed = 100

@export var animated_sprite : AnimatedSprite2D

func _ready() -> void:
	var frame : int = randi_range(0, animated_sprite.sprite_frames.get_frame_count("default")-1)
	
	
	#animated_sprite.frame = frame

func start_engine():
	var direction : Vector2 = Vector2 (randf_range(-1,1), randf_range(-1,1))
	
	apply_force( direction.normalized() * start_speed)

func setup():
	animated_sprite.frame = id

func respawn_shiny():
	var shiny = load("res://shiny.tscn").instantiate()
	var ranPos = randi_range(0,GM.shine_spawns.size()-1)
	shiny.position = GM.shine_spawns[ranPos].position
	get_tree().get_root().add_child(shiny)

func _process(delta: float) -> void:
	scorecard.score = score
	scorecard.alive = alive
	lifetime += delta
	if(linear_velocity.length() < 35 and lifetime > 10):
		linear_velocity *= 1.1
	if(not alive):
		modulate = Color("ffffff42")
		contact_monitor = false
		scorecard.alive = false
		for i in range(score):
			respawn_shiny()
		process_mode = Node.PROCESS_MODE_DISABLED

func _on_body_entered(body: Node) -> void:
	#print("mew")
	if body.is_in_group("player") :
		print("playersHit")
		if(score > 0):
			#score -= 1
			#respawn_shiny()
			pass
