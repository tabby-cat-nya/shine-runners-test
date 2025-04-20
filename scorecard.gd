extends Control
class_name Scorecard

var score : int = 0
var id : int = 0
var alive : bool = true

@export_group("Node References")
@export var score_label : Label
@export var sprite : AnimatedSprite2D
@export var back : TextureRect
@export var alive_texture : Texture
@export var dead_texture : Texture

func _process(delta: float) -> void:
	
	
	if alive:
		back.texture = alive_texture
		score_label.text = str(score)
		sprite.frame = id
	else:
		back.texture = dead_texture
	
	
