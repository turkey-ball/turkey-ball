extends Node2D


func _ready():
	$Spring.points[0] = $DampedSpringJoint2D.position


func _process(_delta):
	$Spring.points[1] = $Glove.position


func _on_button_pressed():
	$InitialCage.queue_free()
	$Glove.apply_impulse(Vector2(0, -1000))
