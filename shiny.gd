extends RigidBody2D



func _on_body_entered(body: Player) -> void:
	print(body.name)
	if body is Player:
		body.score += 1
		body.scorecard.score = body.score
		queue_free()
