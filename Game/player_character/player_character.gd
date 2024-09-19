class_name PlayerCharacter
extends CharacterBody2D
# Use this script as an easy way to interact with deeper components
@export var player_jump : PlayerJump
@export var player_move : PlayerMovement
@export var player_climb : PlayerClimb
@export var player_health : PlayerHealth
@export var player_visual : PlayerVisual
var frozen_movement : bool = false

func _ready() -> void:
	player_health.player_death.connect(freeze_movement)
	
func freeze_movement() -> void:
	frozen_movement = true
func unfreeze_movement() -> void:
	frozen_movement = false
