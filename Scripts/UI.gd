extends Control

@export var score_l: int
@export var score_r: int
var start_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	start_time += delta
	$Time.text = str(int(start_time))
	$ScoreL.text = str(score_l)
	$ScoreR.text = str(score_r)
