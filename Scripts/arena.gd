extends Node2D


signal goal_hit(side: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	$background_sound1.play()
	$background_sound2.play()

func _on_goal_r_body_entered(body:Node2D):
	if body.name == "Turkey":
		goal_hit.emit("right")

func _on_goal_l_body_entered(body:Node2D):
	if body.name == "Turkey":
		goal_hit.emit("left")
