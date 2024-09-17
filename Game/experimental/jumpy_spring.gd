extends StaticBody2D

var tracked_player : CharacterBody2D

const SPROING_SCALE_MIN = 0.6
const SPROING_SCALE_MAX = 1.0

const PAD_REST_POS = -30.0
const PAD_MAX_POS = 10.0

const PLAYER_OFFSET = 22.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func apply_jump_boost(power : float):
	#tracked_player.get_node("MovementControl").get_node("Jump").jump_boost = power
	print(power)
	pass

func update_jump_boost():
	# track the visual part
	$LaunchPad.global_position.y = tracked_player.global_position.y + PLAYER_OFFSET
	var spring_offset = ($LaunchPad.position.y - PAD_REST_POS) / PAD_MAX_POS
	
	# add a safeguard that skips apply_jump_boost if spring is at it's MIN position

	$Sproing.scale.y = lerp(SPROING_SCALE_MAX,SPROING_SCALE_MIN, spring_offset)
	# calcualte power based on deforamtion
	apply_jump_boost(spring_offset)
	pass

func player_entered_spring():
	
	$JumpAdjuster.start()
	pass

func player_left_spring():
	#reset the visual part
	$JumpAdjuster.stop()
	apply_jump_boost(0)
	$Sproing.scale.y = SPROING_SCALE_MAX
	$LaunchPad.position.y = PAD_REST_POS
	tracked_player = null
	pass

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		tracked_player = body
		update_jump_boost()
		$JumpAdjuster.start()
	pass # Replace with function body.


func _on_player_detector_body_exited(body: Node2D) -> void:
	
	player_left_spring()
	
	pass # Replace with function body.


func _on_jump_adjuster_timeout() -> void:
	update_jump_boost()
	pass # Replace with function body.
