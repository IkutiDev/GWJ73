extends Path2D

@export var wire_color : Color

var length_to_spark_ratio = 89.0

var zap_wait_time = 1.2

@export var start_powered = true

var powered = false

func toggle_power():
	powered = !powered
	if powered:
		$SparkMover/AnimationPlayer.play("new_animation")
		$SparkMover/DeathSentence.set_deferred("monitoring",true)
	else:
		$SparkMover/AnimationPlayer.play("RESET")
		$SparkMover/DeathSentence.set_deferred("monitoring",false)
	
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	

	var wire_length = curve.get_baked_length()
	$SparkMover/SparkEmitter.amount = int(wire_length/length_to_spark_ratio)
	for point in curve.get_baked_points():
		$Isolation.add_point(point)
		
	$Isolation.texture.height = int(wire_length / 240.0)
	$Isolation.texture.color_ramp.set_color(0,wire_color)
	
	$Isolation.visible = true
	$SparkMover.visible = true
	zap_wait_time = (length_to_spark_ratio * zap_wait_time) / wire_length
	if start_powered:
		toggle_power()
	pass # Replace with function body.


func _on_zapper_finished() -> void:
	await get_tree().create_timer(zap_wait_time + randf() * 0.5).timeout
	$SparkMover/Zapper.play()
	pass # Replace with function body.
