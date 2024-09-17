class_name PlayerJump
extends Node

signal pressed_jump
signal landed

@export_storage var this_is_needed_for_tooltip_to_work_if_we_start_with_category := false
@export_category("Jumping Stats")
## Maximum jump height
@export_range(0.0, 100.0) var jump_height : float = 45.0
@export_range(0.2, 1.25) var time_to_jump_apex : float  = 0.2
@export_range(0.0, 5.0) var upward_movement_multiplier : float = 1
@export_range(1.0,10.0) var downward_movement_multiplier : float = 6.17
@export_range(0,1) var max_air_jumps : int = 0

@export_category("Options")
@export var variable_jump_height : bool
@export_range(1.0, 10.0) var jump_cut_off : float
@export var speed_limit : float
@export_range(0.0, 0.3) var jump_buffer : float = 0.15
@export_range(0.0, 0.3) var coyote_time : float = 0.15

@export_group("References")
#@export var ground : PlayerGroundCheck
@export var character_body_2d : PlayerCharacter
const GRAVITY_MULTIPLIER : float = 0.5

var gravity_scale : float
var velocity : Vector2
#region Calculations
var jump_speed : float
var default_gravity_scale : float = -1.0
var grav_multiplier : float
#endregion
#region Current State
var desired_jump : bool
var pressing_jump : bool
var on_ground : bool
var can_jump_again : bool = false
var jump_buffer_counter : float
var coyote_time_counter : float = 0
var currently_jumping : bool

@export var jump_boost : float = 0
#endregion

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		pressed_jump.emit()
		desired_jump = true
		pressing_jump = true
	if event.is_action_released("jump"):
		pressing_jump = false

func _process(delta: float) -> void:
	set_physics()
	on_ground = character_body_2d.is_on_floor()
	
	if jump_buffer > 0:
		if desired_jump:
			jump_buffer_counter += delta
			
			if jump_buffer_counter > jump_buffer:
				desired_jump = false
				jump_buffer_counter = 0
				
	if not currently_jumping and not on_ground:
		coyote_time_counter += delta
	else:
		coyote_time_counter = 0
	
func _physics_process(delta: float) -> void:
	velocity = character_body_2d.velocity
	if not on_ground:
		velocity += character_body_2d.get_gravity() * delta * gravity_scale
		
	if desired_jump:
		do_a_jump()
		character_body_2d.velocity = velocity
		return
	calculate_gravity()

func set_physics() -> void:
	var new_gravity : Vector2 = Vector2(0, (-2 * jump_height) / (time_to_jump_apex * time_to_jump_apex))
	
	gravity_scale = (new_gravity.y / character_body_2d.get_gravity().y) * grav_multiplier * GRAVITY_MULTIPLIER
	#print(grav_multiplier)

var falling_down

func calculate_gravity() -> void:
	# if going up
	if character_body_2d.velocity.y < -0.01:
		if on_ground:
			grav_multiplier = default_gravity_scale
		else:
			if variable_jump_height:
				if pressing_jump and currently_jumping:
					grav_multiplier = -upward_movement_multiplier
				else:
					grav_multiplier = -jump_cut_off
			else:
				grav_multiplier = -upward_movement_multiplier
	# if going down
	elif character_body_2d.velocity.y > 0.01:
		falling_down = true
		if on_ground:
			grav_multiplier = default_gravity_scale
		else:
			grav_multiplier = -downward_movement_multiplier
			
	else:
		if on_ground:
			if falling_down:
				landed.emit()
			currently_jumping = false
			falling_down = false
			
			
		grav_multiplier = default_gravity_scale
			
	character_body_2d.velocity = Vector2(velocity.x, clampf(velocity.y, -INF, speed_limit))
			
	

func do_a_jump() -> void:
	
	if character_body_2d.frozen_movement:
		return
	
	if on_ground or (coyote_time_counter > 0.03 and coyote_time_counter < coyote_time) or can_jump_again:
		desired_jump = false
		jump_buffer_counter = 0
		coyote_time_counter = 0
		can_jump_again = (max_air_jumps == 1 and can_jump_again == false)
		
		var current_jump_height = jump_height + jump_height * jump_boost
		jump_speed = sqrt(2.0 * character_body_2d.get_gravity().y * current_jump_height) * 0.15
		
		if velocity.y < 0.0:
			print("Less Y")
			jump_speed = maxf(jump_speed + (velocity.y*0.1), 0)
		elif velocity.y > 0.0:
			print("Big Y")
			jump_speed += absf(character_body_2d.velocity.y* 0.1)
		
		
		velocity.y += -(jump_speed * 10)
		
		currently_jumping = true
		
	if jump_buffer == 0:
		desired_jump = false
