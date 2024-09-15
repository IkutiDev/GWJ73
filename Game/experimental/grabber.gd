extends Area2D

var held_item : RigidBody2D


func grab_item(da_item : RigidBody2D):
	da_item.freeze = true
	held_item = da_item
	da_item.global_position = $OverHead.global_position
	da_item.reparent($OverHead)
	pass

func drop_held_item():
	held_item.freeze = false
	held_item.reparent(get_parent().get_parent()) # this is bad :V
	held_item = null
	pass

func _on_grab_pressed() -> void:
	
	# is player already holding something?
	if held_item != null:
		drop_held_item()
		return
	var valid_targets = get_overlapping_bodies()
	
	# can we grab sometinhg?
	if valid_targets.size() == 0:
		return
	
	# grab the first valid target
	grab_item(valid_targets[0])
	pass # Replace with function body.
