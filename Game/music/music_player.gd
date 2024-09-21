extends Node

@export var mute_in_editor := false
@export_group("References")
@export var background_music_player : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.has_feature("editor"):
		background_music_player.volume_db = 0
	else:
		background_music_player.volume_db = -80 if mute_in_editor else 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_music_finished() -> void:
	$Music.stream = load("res://music/A Quest For A Hero Music_Loop.mp3")
	$Music.play()
	pass # Replace with function body.
