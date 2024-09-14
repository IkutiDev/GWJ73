class_name PlayerMovement
extends Node
const MULTIPLIER : float = 10.0

@export_storage var this_is_needed_for_tooltip_to_work_if_we_start_with_category := false
@export_category("Movement Stats")
## Maximum Movement Speed
@export_range(0.0, 20.0) var max_speed : float = 10.0
## How fast to reach max speed
@export_range(0.0, 100.0) var max_acceleration : float = 52.0
## How fast to stop after letting go
@export_range(0.0, 100.0) var max_decceleration : float = 52.0
## How fast to stop when changing direction
@export_range(0.0, 100.0) var max_turn_speed : float = 80.0
## How fast to reach max speed when in mid-air
@export_range(0.0, 100.0) var max_air_acceleration : float
## How fast to stop in mid-air when no direction is used
@export_range(0.0, 100.0) var max_air_decceleration : float
## How fast to stop when changing direction when in mid-air
@export_range(0.0, 100.0) var max_air_turn_speed : float = 80.0
## Friction to apply against movement on stick
@export var friction : float

@export_group("Extra Options")
## When false, the charcter will skip acceleration and deceleration and instantly move and stop
@export var use_acceleration : bool

@export_group("References")
#@export var ground : PlayerGroundCheck
@export var character_body_2d : CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

#region Calculations
var direction_x : float
var desired_velocity : Vector2
var velocity : Vector2
var max_speed_change : float
var acceleration : float
var decceleration : float
var turn_speed : float
#endregion

#region Current State
var on_ground : bool
var pressing_key : bool
#endregion
	
func _input(event: InputEvent) -> void:
	direction_x = Input.get_axis("move_left","move_right")
	
	
func _process(delta: float) -> void:
	#print(direction_x)
	
	if direction_x != 0:
		animated_sprite.flip_h = direction_x < 0
		pressing_key = true
	else:
		pressing_key = false
		
	desired_velocity = Vector2(direction_x, 0) * max(max_speed - friction, 0.0) * MULTIPLIER
	
	#print(desired_velocity)


func _physics_process(delta: float) -> void:
	on_ground = character_body_2d.is_on_floor()
	
	#print(on_ground)
	
	velocity = character_body_2d.velocity
	
	if use_acceleration:
		run_with_acceleration(delta)
	else:
		if on_ground:
			run_withouth_acceleration()
		else:
			run_with_acceleration(delta)
	
	#print("Actual velocity "+str(character_body_2d.velocity))
	character_body_2d.move_and_slide()	
		
func run_with_acceleration(delta : float) -> void:
	acceleration = max_acceleration if on_ground else max_air_acceleration
	decceleration = max_decceleration if on_ground else max_air_decceleration
	turn_speed = max_turn_speed if on_ground else max_air_turn_speed
	
	if pressing_key:
		if sign(direction_x) != sign(velocity.x):
			max_speed_change = turn_speed * delta
		else:
			max_speed_change = acceleration * delta
	else:
		max_speed_change = decceleration * delta
		
	max_speed_change = max_speed_change * MULTIPLIER	
		
	velocity.x = move_toward(velocity.x, desired_velocity.x, max_speed_change)
	
	character_body_2d.velocity = velocity
		
func run_withouth_acceleration() -> void:
	velocity.x = desired_velocity.x
	
	character_body_2d.velocity = velocity		
