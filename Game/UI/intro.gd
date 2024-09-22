class_name Intro
extends Control

signal intro_finished

@export var video_player : VideoStreamPlayer


func _enter_tree() -> void:
	AudioServer.set_bus_mute(0,true)

func _process(delta: float) -> void:
	if video_player.stream_position >= 8.0 and not video_player.paused:
		video_player.paused = true
		
		intro_finished.emit()

func _exit_tree() -> void:
	AudioServer.set_bus_mute(0,false)
