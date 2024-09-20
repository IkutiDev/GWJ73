extends StaticBody2D

var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func apply_jump_boost(power : float):
	player.get_node("MovementControl").get_node("Jump").jump_boost = power
	pass

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		$CoilAniamtor.play("coiling")
	pass # Replace with function body.


func _on_player_detector_body_exited(body: Node2D) -> void:
	$CoilAniamtor.play("RESET")
	$Release.play()
	apply_jump_boost(0.0)
	pass # Replace with function body.
