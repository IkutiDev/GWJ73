class_name PlayerVisual
extends Node

@export var player_movement : PlayerMovement
@export var animated_sprite_2d : AnimatedSprite2D
func _process(delta: float) -> void:
	if player_movement.direction_x != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
