class_name PlayerClimb
extends Node

signal wall_grabbed

const MULTIPLIER : float = 10.0

@export var enable_climbing : bool
@export var timed_climbing : bool
@export_range(0, 2) var grab_time : float
@export var max_speed : float
@export var friction : float

var on_wall : bool
var is_climbing : bool
var desired_climb : bool
var remaining_grab_time : float
var direction_y : float
var desired_velocity : Vector2

@export_group("References")
@export var character_body_2d : PlayerCharacter
@export var animated_sprite : AnimatedSprite2D

func _input(event: InputEvent) -> void:
	if character_body_2d.frozen_movement:
		return
		
	if not enable_climbing:
		return
	
	if event.is_action_pressed("climb"):
		desired_climb = true
		is_climbing = true
	if event.is_action_released("climb"):
		is_climbing = false

	direction_y = Input.get_axis("move_up","move_down")

	
func _process(delta: float) -> void:
	if character_body_2d.is_on_wall_only() and is_climbing:
		if desired_climb:
			desired_climb = false
			wall_grabbed.emit()
		if timed_climbing:
			remaining_grab_time -= delta
			if remaining_grab_time <= 0:
				remaining_grab_time = grab_time
				is_climbing = false
	elif character_body_2d.is_on_floor():
		remaining_grab_time = grab_time
	
	desired_velocity = Vector2(0, direction_y) * max(max_speed - friction, 0.0) * MULTIPLIER

func _physics_process(delta: float) -> void:
	if character_body_2d.is_on_wall_only() and is_climbing:
		character_body_2d.velocity.y = desired_velocity.y
