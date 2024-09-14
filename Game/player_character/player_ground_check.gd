class_name PlayerGroundCheck
extends Node

@export var raycasts : Array[RayCast2D]

func get_on_ground() -> bool:
	for r in raycasts:
		if r.is_colliding():
			return true
			
	return false		
