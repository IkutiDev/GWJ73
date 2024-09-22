extends VBoxContainer

signal setting_input(node)

var input_event_button_scene = preload("res://UI/key_remap/input_event_button.tscn")

@export_enum("Left", "Right", "Jump") var action: int

var linked_action : String

var linked_input_events = []

var listen_for_input = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match action:
		0: 
			linked_action = "move_left"
		1:
			linked_action = "move_right"
		2:
			linked_action = "jump"
	$AddNewInputEvent.text = linked_action
	for key in InputMap.action_get_events(linked_action):
		if key.is_class("InputEventKey"):
			add_input_event(key)

	pass # Replace with function body.


func add_input_event(event : InputEventKey):
	InputMap.action_add_event(linked_action,event)
	var new_input_event_button = input_event_button_scene.instantiate()
	new_input_event_button.text = event.as_text()
	new_input_event_button.linked_action = linked_action
	new_input_event_button.linked_input_event = event
	add_child(new_input_event_button)
	pass

func _input(event: InputEvent) -> void:
	if listen_for_input and event.is_class("InputEventKey"):
		if InputMap.action_get_events(linked_action).size() > 5:
			return
		add_input_event(event)
		listen_for_input = false
		SettingsTracker.save_input_map()
		#print(InputMap.action_get_events(linked_action))


func _on_add_new_input_event_button_down() -> void:
	listen_for_input = true
	emit_signal("setting_input",self)
	pass # Replace with function body.
