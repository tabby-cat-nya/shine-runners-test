extends Control
class_name Scorecard

var score : int = 0
var id : int = 0

@export_group("Node References")
@export var score_label : Label
@export var sprite : AnimatedSprite2D

func _process(delta: float) -> void:
	score_label.text = str(score)
	sprite.frame = id
	
