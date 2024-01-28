extends Node2D

signal goal_hit(side: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	# $background_sound1.play()
	# $background_sound2.play()
	$background_sound_loop.play()

func _on_goal_r_body_entered(body:Node2D):
	if body.name == "Turkey" || body.name.contains("Turkey") || "Turkey" in body.name:
		goal_hit.emit("right")
		$goal2.play()
		body.goal()

func _on_goal_l_body_entered(body:Node2D):
	if body.name == "Turkey" || body.name.contains("Turkey") || "Turkey" in body.name:
		goal_hit.emit("left")
		$goal.play()
		body.goal()
		get_tree().call_group("player","goal")
