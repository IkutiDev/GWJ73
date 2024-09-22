class_name LevelSelectButton
extends Button

var level_index := -1

func _enter_tree() -> void:
	pressed.connect(_enter_level)
	
func _enter_level() -> void:
	$Click.play()
	LevelManager.load_level_by_index(level_index)
