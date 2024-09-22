class_name PauseMenu
extends ColorRect
func back_to_game() -> void:
	LevelManager.close_pause_menu()

func reset_level() -> void:
	LevelManager.close_pause_menu()
	LevelManager.reset_current_level()

func main_menu() -> void:
	LevelManager.open_main_menu()
