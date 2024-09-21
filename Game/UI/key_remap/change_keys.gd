extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func un_set_other_buttons(node):
	for child in $ButtonLayout.get_children():
		if child != node:
			child.listen_for_input = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
