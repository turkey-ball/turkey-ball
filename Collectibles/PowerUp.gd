extends Node2D

@export var counter = 0
@export var collider_reason : String
func _ready():
	#$Timer.Start()
	_set_position()

var ist_active = false
var collider_object
func _process(_delta):
	var rayR = $Area2D/CastR
	var rayL = $Area2D/CastL
	var rayU = $Area2D/CastU
	var rayO = $Area2D/CastO
	if rayR.is_colliding() || rayL.is_colliding() || rayU.is_colliding() || rayO.is_colliding():
		if ist_active:
			print("POWERUP '"+str(name)+"' still active")
			return
			
		if rayR.get_collider():
			print("collider r = " + rayR.get_collider().name)
			collider_object = rayR.get_collider()
		if rayL.get_collider():
			print("collider l = " + rayL.get_collider().name)
			collider_object = rayL.get_collider()
		if rayO.get_collider():
			print("collider o = " + rayO.get_collider().name)
			collider_object = rayO.get_collider()
		if rayU.get_collider():
			print("collider u = " + rayU.get_collider().name)
			collider_object = rayU.get_collider()
			
		visible = false
		if collider_object != null:
			#collider_object = rayR.get_collider()
			print("POWERUP Colliding with: " + collider_object.name)
			collider_reason = collider_object.name
			if str(collider_object.name).is_valid_int():
				print("POWERUP Player collision with playerID: " + collider_object.name + ", check: " + str(int(str(collider_object.name))))
				visible = false
				ist_active = true
				$Timer.start()
				
				collider_object.scale.x = randi_range(1,2)
				collider_object.scale.y = randi_range(1,2)
		# Damit die Bullet nicht das PowerUp "aufsammelt"
		if (collider_object.name != null &&
				!collider_object.name.contains("Bullet") &&
				!collider_object.name.contains("CharacterBody2D")):
			_set_position()
	else:
		# Kein herumspringen im Spiel, wenn das PowerUp NICHT aktiv ist
		if !ist_active:
			visible = true

func _set_position():
	counter += 1
	var screen_size = get_viewport().size
	var randX = randi_range(0, screen_size.x)
	var randY = randi_range(0, screen_size.y)
	position.x = randX
	position.y = randY

func _on_timer_timeout():
	collider_object.scale.x = 1
	collider_object.scale.y = 1
	queue_free()
