class_name PlayerHealth
extends Node

signal player_death

@export var health_points := 1
@export var death_time := 1

var current_health_points := 1


func _enter_tree() -> void:
	current_health_points = health_points

func deal_damage(damage : int = 1) -> void:
	current_health_points -= damage
	
	if current_health_points <= 0:
		death()

func death() -> void:
	player_death.emit()
	await get_tree().create_timer(death_time).timeout
	LevelManager.reset_current_level()
