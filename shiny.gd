extends RigidBody2D



func _on_body_entered(body: Node) -> void:
	#print(body.name)
	if body is Player:
		body.score += 1
		queue_free()
