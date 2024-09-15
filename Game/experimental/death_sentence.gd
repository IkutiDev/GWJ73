extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var children = body.get_children()
		
		for c in children:
			var player_visual : PlayerVisual = c as PlayerVisual
			if player_visual != null:
				player_visual.death()
				
		await get_tree().create_timer(1.0).timeout
		print("kill player")
		body.queue_free()
	pass # Replace with function body.
