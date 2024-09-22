extends Control
@export_group("Buttons")
@export var new_game_button : Button
@export var credits_button : Button
@export var settings_button : Button
@export var exit_game_button : Button
@export var level_selection_button : Button
@export_group("Panels")
@export var title_screen_panel : Control
@export var credits_panel : Control
@export var level_select_panel : Control
@export var settings_panel : Control
@export_group("Spawnables")
@export var level_select_button : PackedScene
@export var level_select_buttons_list : Control

var current_panel : Control = null
func _enter_tree() -> void:
	if OS.get_name() == "Web":
		exit_game_button.queue_free()
	else:
		exit_game_button.pressed.connect(exit_game)
	credits_button.pressed.connect(show_credits)
	settings_button.pressed.connect(show_settings)
	new_game_button.pressed.connect(start_new_game)
	level_selection_button.pressed.connect(show_level_select)
	
	for i in LevelManager.gameplay_levels.size():
		var level_button_instance = level_select_button.instantiate() as LevelSelectButton
		level_button_instance.level_index = i
		if LevelManager.latest_index_level < i:
			level_button_instance.disabled = true
			level_button_instance.focus_mode = Control.FOCUS_NONE
			level_button_instance.text = ""
		else:	
			level_button_instance.text = LevelManager.gameplay_levels[i].instantiate().name
		level_select_buttons_list.add_child(level_button_instance)
		


func exit_game() -> void:
	if OS.get_name() == "Web":
		return
	get_tree().quit()

func start_new_game() -> void:
	$Click.play()
	LevelManager.load_level_by_index(0)


func show_credits() -> void:
	show_subpanel(credits_panel)

func show_settings() -> void:
	show_subpanel(settings_panel)

func show_level_select() -> void:
	show_subpanel(level_select_panel)

func show_subpanel(panel : Control) -> void:
	title_screen_panel.hide()
	panel.show()
	current_panel = panel
	
func hide_current_subpanel() -> void:
	if current_panel != null:
		current_panel.hide()
	current_panel = null
	title_screen_panel.show()
