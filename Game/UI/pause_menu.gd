class_name PauseMenu
extends ColorRect

@export var settings_panel : Control
@export var buttons : Control

func back_to_game() -> void:
	LevelManager.close_pause_menu()

func reset_level() -> void:
	LevelManager.close_pause_menu()
	LevelManager.reset_current_level()

func main_menu() -> void:
	LevelManager.open_main_menu()

func show_settings() -> void:
	settings_panel.show()
	buttons.hide()

func hide_settings() -> void:
	settings_panel.hide()
	buttons.show()
