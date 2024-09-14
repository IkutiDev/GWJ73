class_name PlayerJump
extends Node

signal pressed_jump

@export_storage var this_is_needed_for_tooltip_to_work_if_we_start_with_category := false
@export_category("Jumping Stats")
## Maximum jump height
@export_range(0.0, 100.0) var jump_height : float = 45.0
@export_range(0,1) var max_air_jumps : int = 0

@export_category("Options")
@export_range(0.0, 0.3) var jump_buffer : float = 0.15

@export_group("References")
#@export var ground : PlayerGroundCheck
@export var character_body_2d : CharacterBody2D

var gravity_scale := 0.5

#region Current State
var desired_jump : bool
var pressing_jump : bool
var on_ground : bool
var can_jump_again : bool = false
var jump_buffer_counter : float
#endregion

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		pressed_jump.emit()
		desired_jump = true
		pressing_jump = true
	if event.is_action_released("jump"):
		pressing_jump = false

func _process(delta: float) -> void:
	on_ground = character_body_2d.is_on_floor()
	
	if jump_buffer > 0:
		if desired_jump:
			jump_buffer_counter += delta
			
			if jump_buffer_counter > jump_buffer:
				desired_jump = false
				jump_buffer_counter = 0
	
func _physics_process(delta: float) -> void:
	if not on_ground:
		character_body_2d.velocity += character_body_2d.get_gravity() * delta * gravity_scale
		
	if desired_jump:
		do_a_jump()


func do_a_jump() -> void:
	print("Doing a jump")
	print("On Ground "+str(on_ground))
	print("Can jump again "+str(can_jump_again))
	if on_ground or can_jump_again:
		desired_jump = false
		jump_buffer_counter = 0
		can_jump_again = (max_air_jumps == 1 and can_jump_again == false)
		
		character_body_2d.velocity.y = -(jump_height * 10)
		
	if jump_buffer == 0:
		desired_jump = false
