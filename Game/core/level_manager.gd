extends Node

@export var animation_player : AnimationPlayer

@export var gameplay_levels : Array[PackedScene]

var current_gameplay_level_index := 0
var latest_index_level := 0

var resetting_level := false
var loading_level := false

func _enter_tree() -> void:
	animation_player.animation_finished.connect(fade_animation_finished)
	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")

	if err == OK:
		latest_index_level = config.get_value("Player", "levelIndex", TYPE_INT)
	
func load_level_by_index(index : int) -> void:
	current_gameplay_level_index = index
	loading_level = true
	animation_player.play("fade_out")

func load_next_level() -> void:
	current_gameplay_level_index += 1
	loading_level = true
	animation_player.play("fade_out")
	
func reset_current_level() -> void:
	resetting_level = true
	animation_player.play("fade_out")
	
	
func _unhandled_input(event: InputEvent) -> void:
	
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
			creating_next_level_instance()
		if player_character != null:
			player_character.freeze_movement()
		resetting_level = false
		loading_level = false
		animation_player.play("fade_in")
	
	if anim == "fade_in":
		var player_character : PlayerCharacter = get_tree().get_nodes_in_group("player")[0]
		player_character.unfreeze_movement()

func creating_next_level_instance() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://save.cfg")

	if err == OK:
		latest_index_level = config.get_value("Player", "levelIndex", TYPE_INT)
	if latest_index_level < current_gameplay_level_index:
		latest_index_level = current_gameplay_level_index
		config.set_value("Player", "levelIndex", latest_index_level)
		config.save("user://save.cfg")
	if current_gameplay_level_index >= gameplay_levels.size():
		push_error("Trying to load level index that's out of bounds! "+str(current_gameplay_level_index))
		return
	
	get_tree().current_scene.queue_free()
	var level_instance = gameplay_levels[current_gameplay_level_index].instantiate()
	get_tree().root.add_child(level_instance)
	get_tree().current_scene = level_instance
