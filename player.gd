extends RigidBody2D
class_name Player

var id : int = 0
var score : int = 0
var scorecard : Scorecard
@export var start_speed = 100

@export var animated_sprite : AnimatedSprite2D

func _ready() -> void:
	var frame : int = randi_range(0, animated_sprite.sprite_frames.get_frame_count("default")-1)
	var direction : Vector2 = Vector2 (randf_range(-1,1), randf_range(-1,1))
	
	apply_force( direction.normalized() * start_speed)
	#animated_sprite.frame = frame

func setup():
	animated_sprite.frame = id
