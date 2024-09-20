extends StaticBody2D

signal switch_toggled

@export var connected_devices : Array[NodePath]

@export var starting_state = true

@export var left_flipped = true

var turned_on : bool

func _ready():
	turned_on = starting_state
	for device_path in connected_devices:
		connect("switch_toggled",Callable(get_node(device_path),"toggle_power"))
	if left_flipped:
		flip_left()
	else:
		flip_right()
	await $Click.finished
	$Click.volume_db = -6
	pass

func toggle():
	turned_on = !turned_on
	emit_signal("switch_toggled")
	#print("switch toggled to ",turned_on)
	pass

func flip_left():
	$LeftSwitch/CollisionShape2D.set_deferred("disabled",true)
	$RightSwitch/CollisionShape2D.set_deferred("disabled",false)
	$RightSwitch.visible = true
	$LeftSwitch.visible = false
	$Click.global_position = $LeftSwitch.global_position
	$Click.pitch_scale = 1.18
	$Click.play()
	pass

func flip_right():
	$LeftSwitch/CollisionShape2D.set_deferred("disabled",false)
	$RightSwitch/CollisionShape2D.set_deferred("disabled",true)
	$RightSwitch.visible = false
	$LeftSwitch.visible = true
	$Click.global_position = $RightSwitch.global_position
	$Click.pitch_scale = 1.12
	$Click.play()
	pass

func _on_right_switch_body_entered(body: Node2D) -> void:
	if $LeftSwitch.has_overlapping_bodies():
		return
	
	flip_right()
	toggle()
	pass # Replace with function body.


func _on_left_switch_body_entered(body: Node2D) -> void:
	if $RightSwitch.has_overlapping_bodies():
		return
	flip_left()
	toggle()
	pass # Replace with function body.
