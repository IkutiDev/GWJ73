extends ColorRect
@export var main_menu_scene : PackedScene
func back_to_game() -> void:
	LevelManager.close_pause_menu()

func reset_level() -> void:
	LevelManager.close_pause_menu()
	LevelManager.reset_current_level()

func main_menu() -> void:
	LevelManager.close_pause_menu()
	get_tree().current_scene.queue_free()
	var main_menu_instance = main_menu_scene.instantiate()
	get_tree().root.add_child(main_menu_instance)
	get_tree().current_scene = main_menu_instance
