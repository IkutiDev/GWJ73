extends Node

const FILE_PATH = "user://settings.cfg"

var settings_file : ConfigFile

func _enter_tree() -> void:

	settings_file = ConfigFile.new()
	var err = settings_file.load(FILE_PATH)

	if err == 7:
		print("settings file does not exist")
		save_audio_layout()
	else:
		print("loading existing settings file")
		load_audio_layout()
		load_input_map()
		
func save_input_map():
	for a in InputMap.get_actions():
		if a.contains("ui_"):
			continue
		settings_file.erase_section("Input/"+a)
	
	for a in InputMap.get_actions():
		print(a)
		for i in InputMap.action_get_events(a):
			print(i)
			print(i.as_text())
			settings_file.set_value("Input/"+a,i.as_text(),i)
			
			
	settings_file.save(FILE_PATH)

func load_input_map():
	#First erase all since we have predefined saved
	for a in InputMap.get_actions():
		if not settings_file.has_section("Input/"+a):
			continue
		InputMap.action_erase_events(a)
		
	#Now load all
	
	for a in InputMap.get_actions():
		if not settings_file.has_section("Input/"+a):
			continue
		var input_events =settings_file.get_section_keys("Input/"+a)
		
		for i in input_events:
			InputMap.action_add_event(a, settings_file.get_value("Input/"+a, i, TYPE_OBJECT))
	
			
func save_audio_layout():
	var bus_layout = {}
	for bus in AudioServer.bus_count:
		settings_file.set_value("Audio",AudioServer.get_bus_name(bus),AudioServer.get_bus_volume_db(bus))

	settings_file.save(FILE_PATH)


	pass

func load_audio_layout():
	var audio_settings = settings_file.get_section_keys("Audio")
	for bus in audio_settings:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus),settings_file.get_value("Audio",bus))
	

	pass
