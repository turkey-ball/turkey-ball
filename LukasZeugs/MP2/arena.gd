extends Node2D


signal goal_hit(side: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	$background_sound1.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_goal_r_body_entered(body:Node2D):
	if body.name == "Turkey":
		goal_hit.emit("right")

func _on_goal_l_body_entered(body:Node2D):
	if body.name == "Turkey":
		goal_hit.emit("left")
