extends Node

@export var mute_in_editor := false
@export_group("References")
@export var background_music_player : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.has_feature("standalone"):
		background_music_player.volume_db = -80 if mute_in_editor else 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
