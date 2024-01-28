extends Node2D


func _ready():
	$Spring.points[0] = $DampedSpringJoint2D.position


func _process(_delta):
	$Spring.points[1] = $Glove.position


func _on_button_pressed():
	pass


func _on_glove_trigger_body_entered(body):
	if !get_node("InitialCage"):
		return
	if !body.name.to_int():
		return

	$InitialCage.queue_free()
	$Glove.apply_impulse(body.position * 60)
	$Timer.start()


func _on_timer_timeout():
	queue_free()
