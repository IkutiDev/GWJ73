extends Control

func _ready() -> void:
	MusicPlayer.play_victory()

func _back_to_main_menu() -> void:
	LevelManager.open_main_menu()
