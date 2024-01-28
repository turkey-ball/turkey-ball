extends Node2D


func _ready():
	$Spring.points[0] = $DampedSpringJoint2D.position
	$Glove.apply_impulse(Vector2(0, -1000))


func _process(_delta):
	$Spring.points[1] = $Glove.position
