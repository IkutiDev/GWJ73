extends Node2D


func connect_camera_to_player(player : CharacterBody2D):
	$PhantomCamera2D.set_follow_target(player)
	print("test")
	pass
