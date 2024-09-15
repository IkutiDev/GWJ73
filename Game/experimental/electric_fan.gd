extends Node2D

# ON HIATUS

@export var start_powered = true

var powered = false

func _ready() -> void:
	if start_powered:
		toggle_power()

func toggle_power():
	powered = !powered
