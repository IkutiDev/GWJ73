extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("kill player")
		body.queue_free()
	pass # Replace with function body.
