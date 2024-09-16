extends Area2D




func _on_body_entered(body: Node2D) -> void:
	var player_character : PlayerCharacter = body as PlayerCharacter
	if player_character != null:
		player_character.player_health.deal_damage()
				
	pass # Replace with function body.
