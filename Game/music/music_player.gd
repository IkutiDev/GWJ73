extends Node

@export var mute_in_editor := false
@export_group("References")
@export var background_music_player : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.has_feature("editor"):
		AudioServer.set_bus_mute(1,false)
		#background_music_player.volume_db = 0
	else:
		AudioServer.set_bus_mute(1,true) if mute_in_editor else 0


func play_death():
	if $Death.playing:
		return
	var music_position = $Music.get_playback_position()
	print(music_position)
	$Music.stop()
	$Music.volume_db = -80
	$Death.play()
	await get_tree().create_timer(1.8).timeout
	$Music.play(music_position)
	var sound_tween = get_tree().create_tween()
	sound_tween.tween_property($Music,"volume_db",0,1.0)

	pass

func _on_music_finished() -> void:
	$Music.stream = load("res://music/A Quest For A Hero Music_Loop.mp3")
	$Music.play()
	pass # Replace with function body.
