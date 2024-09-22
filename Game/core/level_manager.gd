extends Node

@export var animation_player : AnimationPlayer

@export var gameplay_levels : Array[PackedScene]
@export var end_game_screen : PackedScene

@export var pause_menu_spawn_slot : CanvasLayer
@export var pause_menu_scene : PackedScene
@export var pause_menu_button : TextureButton

@export var main_menu : PackedScene

@export var intro_scene : PackedScene

var current_gameplay_level_index := 0
var latest_index_level := 0

var resetting_level := false
var loading_level := false
var playing_intro := false

var paused := false

func _enter_tree() -> void:
	animation_player.animation_finished.connect(fade_animation_finished)
	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")

	if err == OK:
		latest_index_level = config.get_value("Player", "levelIndex", TYPE_INT)
	
func start_new_game() -> void:
	current_gameplay_level_index = 0
	playing_intro = true
	animation_player.play("fade_out")
	
func load_level_by_index(index : int) -> void:
	current_gameplay_level_index = index
	loading_level = true
	animation_player.play("fade_out")

func load_next_level() -> void:
	current_gameplay_level_index += 1
	loading_level = true
	animation_player.play("fade_out")
	
func reset_current_level() -> void:
	var player_character : PlayerCharacter = null
	if get_tree().get_nodes_in_group("player").size() > 0:
		player_character = get_tree().get_nodes_in_group("player")[0]
	if player_character != null:
		player_character.freeze_movement()
	resetting_level = true
	animation_player.play("fade_out")
	
func open_pause_menu() -> void:
	
	if get_tree().current_scene.name == "MainMenu":
		return
	if resetting_level or loading_level:
		return
	if not animation_player.current_animation == "":
		return
	
	Engine.time_scale = 0
	var pause_menu_instance = pause_menu_scene.instantiate()
	pause_menu_spawn_slot.add_child(pause_menu_instance)
	paused = true
	
func close_pause_menu() -> void:
	paused = false
	
	for c in pause_menu_spawn_slot.get_children():
		if c is PauseMenu:
			c.queue_free()
			break
	Engine.time_scale = 1
	
func open_main_menu() -> void:
	close_pause_menu()
	get_tree().current_scene.queue_free()
	var main_menu_instance = main_menu.instantiate()
	get_tree().root.add_child(main_menu_instance)
	get_tree().current_scene = main_menu_instance
	
func _process(delta: float) -> void:
	var is_main_menu : bool = get_tree().current_scene.name == "MainMenu" or get_tree().current_scene.name == "WinGameScreen" or get_tree().current_scene.name == "Intro"
	
	pause_menu_button.disabled = is_main_menu
	if is_main_menu:
		pause_menu_button.hide()
	else:
		pause_menu_button.show()
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("pause"):
		var current_scene_name := get_tree().current_scene.name
		if current_scene_name == "MainMenu" or current_scene_name == "WinGameScreen" or current_scene_name == "Intro":
			return
		if resetting_level or loading_level:
			return
		if not animation_player.current_animation == "":
			return
		if paused:
			close_pause_menu()
		else:
			open_pause_menu()
	
	if OS.has_feature("standalone"):
		return
	if event.is_action_pressed("cheat_go_next_level"):
		load_next_level()

func fade_animation_finished(anim : StringName) -> void:
	if anim == "fade_out":
		var player_character : PlayerCharacter = null
		if get_tree().get_nodes_in_group("player").size() > 0:
			player_character = get_tree().get_nodes_in_group("player")[0]
		if resetting_level:
			get_tree().reload_current_scene()
		if loading_level:
			if get_tree().current_scene.name == "Intro":
				get_tree().current_scene.queue_free()
			creating_next_level_instance()
		if playing_intro:
			play_intro()
		if player_character != null:
			player_character.freeze_movement()
		resetting_level = false
		loading_level = false
		animation_player.play("fade_in")
	
	if anim == "fade_in":
		if playing_intro:
			return
		if get_tree().get_nodes_in_group("player").size() > 0:
			var player_character : PlayerCharacter = get_tree().get_nodes_in_group("player")[0]
			player_character.unfreeze_movement()

func play_intro() -> void:
	get_tree().current_scene.queue_free()
	var intro_instance := intro_scene.instantiate() as Intro
	get_tree().root.add_child(intro_instance)
	get_tree().current_scene = intro_instance
	intro_instance.intro_finished.connect(end_intro)

func end_intro() -> void:
	playing_intro = false
	load_level_by_index(0)

func creating_next_level_instance() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")

	if err == OK:
		latest_index_level = config.get_value("Player", "levelIndex", TYPE_INT)
	if latest_index_level < current_gameplay_level_index:
		latest_index_level = current_gameplay_level_index
		config.set_value("Player", "levelIndex", latest_index_level)
		config.save("user://save.cfg")
		
	get_tree().current_scene.queue_free()
	var scene_instance
	if current_gameplay_level_index >= gameplay_levels.size():
		scene_instance = end_game_screen.instantiate()
	else:
		scene_instance = gameplay_levels[current_gameplay_level_index].instantiate()
	get_tree().root.add_child(scene_instance)
	get_tree().current_scene = scene_instance
