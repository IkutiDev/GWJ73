extends Node2D

@export var player_character : Resource

signal player_created (player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$SpawnPoint.visible = false
	$ScreenTransitions.play("start")
	pass # Replace with function body.

func spawn_player():
	var new_player = player_character.instantiate() as Node2D
	new_player.global_position = $SpawnPoint.global_position
	new_player.connect("tree_exited",Callable(self, "player_died"))
	add_child(new_player)
	emit_signal("player_created",new_player)
	pass


func player_died():
	$ScreenTransitions.play("death")
	pass


func _on_screen_transitions_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		get_tree().reload_current_scene()
	if anim_name == "start":
		spawn_player()
	pass # Replace with function body.
