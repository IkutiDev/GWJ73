class_name PlayerVisual
extends Node

@export var player_movement : PlayerMovement
@export var player_jump : PlayerJump
@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

func _enter_tree() -> void:
	player_jump.pressed_jump.connect(pressed_jump)

func _process(delta: float) -> void:
	if character_body_2d.velocity.y != 0:
		if character_body_2d.velocity.y > 0.0 && animated_sprite_2d.animation != "fall":
			animated_sprite_2d.play("fall")
		return
	if player_movement.direction_x != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	#print(character_body_2d.velocity.y)

func pressed_jump() -> void:
	animated_sprite_2d.play("jump")
