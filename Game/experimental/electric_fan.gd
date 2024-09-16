extends Node2D

var tracked_player : CharacterBody2D

const wind_power = Vector2(0,-500)

@export var start_powered = true

var powered = false

func _ready() -> void:
	if start_powered:
		toggle_power()

func toggle_power():
	powered = !powered
	if powered:
		$FanAnimator.play("turn_on")
		$Wind.set_deferred("monitoring",true)
	else:
		$FanAnimator.play("RESET")
		$Wind.set_deferred("monitoring",false)
		if tracked_player != null:
			player_left_fan()

func player_eneterd_fan():
	$VelocityUpdate.start()
	pass

func player_left_fan():
	$VelocityUpdate.stop()
	apply_velocity_to_player(Vector2(0,0))
	tracked_player = null
	pass

func update_player_velocity():
	# assume tracked_player is player
	# check new velocity based on distace from player to fan
	var calcualted_velocity = wind_power * smoothstep($WindMin.global_position.y,$WindMax.global_position.y,tracked_player.global_position.y)
	
	# send velocity to player via apply_velocity_to_player
	apply_velocity_to_player(calcualted_velocity)
	pass

func apply_velocity_to_player(velocity : Vector2):
	# assume tracked_player is player
	# send velocity to player
	print(velocity)
	pass

func _on_wind_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		tracked_player = body
		player_eneterd_fan()
	pass # Replace with function body.


func _on_wind_body_exited(body: Node2D) -> void:
	player_left_fan()
	pass # Replace with function body.


func _on_velocity_update_timeout() -> void:
	update_player_velocity()
	pass # Replace with function body.
