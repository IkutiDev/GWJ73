class_name PlayerVisual
extends Node

@export var player_character : PlayerCharacter
@export var animated_sprite_2d : AnimatedSprite2D

var funny_animation_time := 0.0

var funny_animation_timer := 0.0

var disable_animations := false

func _enter_tree() -> void:
	player_character.player_jump.pressed_jump.connect(pressed_jump)
	player_character.player_jump.landed.connect(landed)
	player_character.player_health.player_death.connect(death)
	funny_animation_time = randf_range(5.0, 15.0)

func _process(delta: float) -> void:
	
	if disable_animations:
		return
	
	if player_character.player_climb.is_climbing and player_character.is_on_wall_only():
		if player_character.velocity.y == 0:
			animated_sprite_2d.stop()
		else:
			animated_sprite_2d.play("climb")
		return
	
	if not Input.is_anything_pressed():
		funny_animation_timer += delta
		if funny_animation_timer > funny_animation_time:
			funny_animation_time = randf_range(5.0, 15.0)
			animated_sprite_2d.play("bonus")
	else:
		funny_animation_timer = 0
	
	if player_character.velocity.y != 0:
		if player_character.velocity.y > 0.0 && animated_sprite_2d.animation != "in_air":
			animated_sprite_2d.play("in_air")
		return
	if not player_character.is_on_floor():
		return
	if player_character.player_move.direction_x != 0 and not player_character.frozen_movement:
		animated_sprite_2d.play("run")
	else:
		if (animated_sprite_2d.animation == "land" or animated_sprite_2d.animation == "bonus") and animated_sprite_2d.is_playing():
			return
		animated_sprite_2d.play("idle")

func pressed_jump() -> void:
	if disable_animations:
		return
	if player_character.frozen_movement:
		return
	if player_character.is_on_floor():
		animated_sprite_2d.play("jump")
		
func landed() -> void:
	if disable_animations:
		return
	animated_sprite_2d.play("land")

func play_push_animation() -> void:
	animated_sprite_2d.play("push")
	disable_animations = true

func stop_push_animation() -> void:
	animated_sprite_2d.stop()
	disable_animations = false

func death() -> void:
	animated_sprite_2d.play("death")
	disable_animations = true

func respawn() -> void:
	disable_animations = false


func _on_animated_sprite_2d_animation_changed() -> void:
	var current_aniamtion = $AnimatedSprite2D.animation
	if current_aniamtion == "run":
		$StepAdjuster.play("start")
	else:
		$StepAdjuster.play("stop")
	pass # Replace with function body.
