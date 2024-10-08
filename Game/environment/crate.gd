extends RigidBody2D


var push_force = Vector2(1080,0)
var max_speed = 65

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func push_start(direction : int):
	$TheClamper.start()
	$AudioFade.play("RESET")
	add_constant_central_force(direction * push_force)

func push_end():
	$TheClamper.stop()
	constant_force.x = 0
	$AudioFade.play("fade_out")
	pass


func _on_the_clamper_timeout() -> void:
	if !$Drag.playing and abs(linear_velocity.x) > max_speed:
		$Drag.play()

	if abs(linear_velocity.x) > max_speed :
		linear_velocity.x = clamp(linear_velocity.x,-max_speed,max_speed)
	pass # Replace with function body.


func _on_push_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var push_direction = sign(global_position.x - body.global_position.x)
		var player_character : PlayerCharacter = body
		if player_character != null:
			player_character.player_visual.play_push_animation()
		push_start(push_direction)
	pass # Replace with function body.


func _on_push_detector_body_exited(body: Node2D) -> void:
	var player_character : PlayerCharacter = body
	if player_character != null:
		player_character.player_visual.stop_push_animation()
	push_end()
	pass # Replace with function body.
