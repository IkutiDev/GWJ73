extends Node

const FILE_PATH = "user://settings.cfg"

var settings_file : ConfigFile

func _ready():

	settings_file = ConfigFile.new()
	var err = settings_file.load(FILE_PATH)

	if err == 7:
		print("settings file does not exist")
		save_audio_layout()
	else:
		print("loading existing settings file")
		load_audio_layout()
func save_audio_layout():
	var bus_layout = {}
	for bus in AudioServer.bus_count:
		settings_file.set_value("Audio",AudioServer.get_bus_name(bus),AudioServer.get_bus_volume_db(bus))


	pass

func load_audio_layout():
	var audio_settings = settings_file.get_section_keys("Audio")
	for bus in audio_settings:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus),settings_file.get_value("Audio",bus))
	

	pass
