extends Control

@export var score_l: int
@export var score_r: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$ScoreL.text = str(score_l)
	$ScoreR.text = str(score_r)
