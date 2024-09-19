extends Area2D

func _enter_tree() -> void:
	body_entered.connect(_body_entered)


func _body_entered(body: Node2D) -> void:
	var player_character : PlayerCharacter = body as PlayerCharacter
	if player_character != null:
		player_character.freeze_movement()
		LevelManager.load_next_level()
