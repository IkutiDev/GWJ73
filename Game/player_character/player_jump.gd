extends Node

@export_storage var this_is_needed_for_tooltip_to_work_if_we_start_with_category := false
@export_category("Jumping Stats")
## Maximum jump height
@export_range(2.0, 15.0) var jump_height : float = 7.3
## How long it takes to reach that height before coming back down
@export_range(0.2, 1.25) var time_to_jump_apex : float = 0.2
## Gravity multiplier to apply when going up
@export_range(0.0, 5.0) var upward_movement_multiplier : float
## Gravity multiplier to apply when coming down
@export_range(1.0, 10.0) var downward_movement_multiplier : float = 6.17
## How many times can you jump in the air?
@export_range(0, 1) var max_air_jumps : int = 0

@export_category("Options")
## Should the character drop when you let go of jump?
@export var variable_jump_height : bool
## Gravity multiplier when you let go of jump
@export_range(1.0, 10.0) var jump_cut_off : float
## The fastest speed the character can fall
@export var speed_limit : float
## How long should coyote time last?
@export_range(0.0, 0.3) var coyote_time : float = 0.15
## How far from ground should we cache your jump?"
@export_range(0.0, 0.3) var jump_buffer : float = 0.15

@export_group("References")
@export var ground : PlayerGroundCheck
@export var character_body_2d : CharacterBody2D

var velocity : Vector2

#region Calculations
var jump_speed : float
var default_gravity_scale : float
var grav_multiplier : float
var gravity_scale : float = 1.0
#endregion

#region Current State
var can_jump_again : bool = false
var desired_jump : bool
var jump_buffer_counter : float
var coyote_time_counter : float = 0
var pressing_jump : bool
var on_ground : bool
var currently_jumping : bool
#endregion



func _enter_tree() -> void:
	default_gravity_scale = 1.0
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		desired_jump = true
		pressing_jump = true
		print(pressing_jump)
	if event.is_action_released("ui_accept"):
		pressing_jump = false
		print(pressing_jump)
	
func _process(delta: float) -> void:
	set_physics()
	on_ground = ground.get_on_ground()
	
	if jump_buffer > 0:
		pass
	
	if not currently_jumping and not on_ground:
		coyote_time_counter += delta
	else:
		coyote_time_counter = 0
	
	
func _physics_process(delta: float) -> void:
	if not on_ground:
		#print(gravity_scale)
		character_body_2d.velocity += character_body_2d.get_gravity() * (-gravity_scale) * delta
		#print(character_body_2d.velocity)
		
	velocity = character_body_2d.velocity
	
	if desired_jump:
		do_a_jump()
		character_body_2d.velocity = velocity
		return
		
	calculate_gravity()
	#print("After grav "+ str(character_body_2d.velocity))
	
func calculate_gravity() -> void:
	if character_body_2d.velocity.y > 0.01:
		if on_ground:
			grav_multiplier = default_gravity_scale
		else:
			if variable_jump_height:
				if pressing_jump and currently_jumping:
					grav_multiplier = upward_movement_multiplier
				else:
					grav_multiplier = jump_cut_off
			else:
				grav_multiplier = upward_movement_multiplier
	elif character_body_2d.velocity.y < -0.01:
		if on_ground:
			grav_multiplier = default_gravity_scale
		else:
			grav_multiplier = downward_movement_multiplier
	else:
		if on_ground:
			currently_jumping = false
		grav_multiplier = default_gravity_scale
		
	character_body_2d.velocity = Vector2(velocity.x, clampf(velocity.y, -speed_limit, 100))
	
func do_a_jump() -> void:
	if on_ground or (coyote_time_counter > 0.03 and coyote_time_counter < coyote_time) or can_jump_again:
		print("Jump!")
		desired_jump = false
		jump_buffer_counter = 0
		coyote_time_counter = 0
		
		can_jump_again = max_air_jumps == 1 and can_jump_again == false
		
		jump_speed = sqrt(-2.0 * character_body_2d.get_gravity().y * gravity_scale * jump_height)
		print(jump_speed)
		if velocity.y > 0.0:
			jump_speed = -maxf(jump_speed - velocity.y, 0)
		elif velocity.y < 0.0:
			jump_speed -= absf(character_body_2d.velocity.y)
		
		velocity.y -= jump_speed
		currently_jumping = true
		
	if jump_buffer == 0:
		desired_jump = false
	
func set_physics() -> void:
	var new_gravity : Vector2 = Vector2(0, (-2 * jump_height) / (time_to_jump_apex * time_to_jump_apex)) 
	#print(new_gravity.y)
	#print(character_body_2d.get_gravity().y)
	#print(grav_multiplier)
	gravity_scale = (new_gravity.y / (character_body_2d.get_gravity().y/100.0)) * grav_multiplier
	#print(gravity_scale)
	#TODO: Implement gravity scale here
	#character_body_2d.gravi	
