extends Node

@export var animation_player : AnimationPlayer

@export var gameplay_levels : Array[PackedScene]

var current_gameplay_level_index := 0

var resetting_level := false
var loading_next_level := false

func _ready() -> void:
	animation_player.animation_finished.connect(fade_animation_finished)

func load_next_level() -> void:
	loading_next_level = true
	animation_player.play("fade_out")
	
func reset_current_level() -> void:
	resetting_level = true
	animation_player.play("fade_out")
	
	
func _unhandled_input(event: InputEvent) -> void:
	
	if OS.has_feature("standalone"):
		return
	if event.is_action_pressed("cheat_go_next_level"):
		print("test")
		load_next_level()

func fade_animation_finished(anim : StringName) -> void:
	if anim == "fade_out":
		if resetting_level:
			get_tree().reload_current_scene()
		if loading_next_level:
			creating_next_level_instance()
		
		resetting_level = false
		loading_next_level = false
		animation_player.play("fade_in")

func creating_next_level_instance() -> void:
	current_gameplay_level_index += 1
	
	if current_gameplay_level_index >= gameplay_levels.size():
		push_error("Trying to load level index that's out of bounds! "+str(current_gameplay_level_index))
		return
	
	get_tree().current_scene.queue_free()
	var level_instance = gameplay_levels[current_gameplay_level_index].instantiate()
	get_tree().root.add_child(level_instance)
