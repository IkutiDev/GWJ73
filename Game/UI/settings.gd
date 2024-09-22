extends Control

@export var music_volume_slider : HSlider
@export var sfx_volume_slider : HSlider
func _enter_tree() -> void:
	var music_index = AudioServer.get_bus_index("Music")
	music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))*100
	var sfx_index = AudioServer.get_bus_index("SFX")
	sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index))*100


func _on_h_slider_value_changed_music(value: float) -> void:
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value/100))

func _on_h_slider_value_changed_sfx(value: float) -> void:
	var sfx_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value/100))


func _on_back_button_pressed() -> void:
	SettingsTracker.save_audio_layout()
