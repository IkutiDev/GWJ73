extends Node2D

@export var start_powered = true

var powered = false


func _ready() -> void:
	if start_powered:
		toggle_power()
		

func toggle_power():
	powered = !powered
	var current_heat_state = $HeaterAnimator.current_animation_position
	if powered :
		$HeaterAnimator.play("heat_up")
		$HeaterAnimator.seek(current_heat_state)
	else:
		
		$HeaterAnimator.play_backwards("heat_up")
		$HeaterAnimator.seek(min(3.8,current_heat_state))
		$DeathSentence/CollisionShape2D.set_deferred("disabled",true)
		
		
	pass

func killer_heat():
	$DeathSentence/CollisionShape2D.set_deferred("disabled",false)
	pass
