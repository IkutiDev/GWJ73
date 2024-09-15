extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_kill_player_pressed() -> void:
	get_tree().get_nodes_in_group("player")[0].queue_free()
	pass # Replace with function body.
