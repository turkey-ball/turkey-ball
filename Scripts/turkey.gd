extends RigidBody2D

const TURKEY_SPEED = 15

var status = 0 
var idle_time = 0
var moving = true
const TURKEY_WEIGHT = 1
var rnd = RandomNumberGenerator.new()
var rnd_nmb1 = rnd.randf_range(-1.0, 1.0)
var rnd_nmb2 = rnd.randf_range(-1.0, 1.0)
var turkeyStartPosition = Vector2(800,500)
# 0: idle
# 1: move random
# 2: moves from player
# 3: get's kicked / flyes away

func _ready():
	var screen_size = get_viewport().size
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	name = "Turkey"
	$gubbelgubbel.play()
	pass

func _process(_delta):
	apply_torque(rotation_degrees*-0.5)
	var slow = 60
	
	if linear_velocity[0] >0 :
		$animation.flip_h = true
	if linear_velocity[0] <0 :
		$animation.flip_h = false
	if abs(linear_velocity[0]) < slow and abs(linear_velocity[1]) < slow:
		moving = false

<<<<<<< Updated upstream
	if $animation.animation == "explosion":
		return
=======
	if (rotation_degrees > -3 and rotation_degrees < 3 and !moving):
		#print ("change status")
		#print ("aktueller status: ", status)
		#rotation = 0
		#linear_velocity = Vector2(0,0)
		#status = 0
		pass

>>>>>>> Stashed changes
	if status == 0:
		$animation.play("idle")
		idle_time += 1
		if idle_time > 200:
			rnd_nmb1 = rnd.randf_range(-1.0, 1.0)*0.3
			rnd_nmb2 = rnd.randf_range(-1.0, 1.0)*0.3
			status = 1
	elif status == 1:
		moving = true
		$animation.play("walk")							
		apply_impulse(Vector2(rnd_nmb1,rnd_nmb2))
	elif status == 2:
		$animation.play("walk")
		apply_impulse(Vector2(rnd_nmb1,rnd_nmb2))
	elif status == 3:		
		moving = true
		$animation.play("wingflap", 1.5) # je nach härte des kicks anpassbar

func explode():
	$animation.play("explosion")
	$scream2.play()

# IT'S A FEATURE
@export var haveChaosMode = false

<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
func _on_area_2d_body_entered(body:Node2D):
	print(body)
	if body.name == "Player" \
	|| body.get_class() == "CharacterBody2D" \
	|| (typeof("CharacterBody2D") && haveChaosMode):
		linear_velocity = Vector2(0,0)
		var new_direction = position - body.position
		linear_velocity = new_direction
		apply_impulse(new_direction * TURKEY_SPEED)
		inertia = TURKEY_WEIGHT		
		$scream1.play()	
		status = 3
		pass


func _on_animation_animation_finished():
	if $animation.animation == "explosion":
<<<<<<< Updated upstream
		position = turkeyStartPosition
		$animation.play("idle")
		status = 0
		linear_velocity = Vector2(0,0)
		angular_velocity = 0.0
		$gubbelgubbel.play()
		

func _on_player_kick_turkey(pos):	
	linear_velocity = Vector2(0,0)
	var new_direction = position - pos
	linear_velocity = new_direction
	apply_impulse(new_direction * 3)
	inertia = TURKEY_WEIGHT		
	$scream1.play()	
	status = 3
		


func _on_player_scare_collision_child_entered_tree(_node):
=======
		queue_free()


func _on_player_scare_collision_child_entered_tree(node):
	print(node)
>>>>>>> Stashed changes
	print("scared")
	status = 2
	rnd_nmb1 = rnd.randf_range(-1.0, 1.0)*0.1
	rnd_nmb2 = rnd.randf_range(-1.0, 1.0)*0.1
<<<<<<< Updated upstream
=======


func _on_player_interaction_collision_child_entered_tree(node):
	if node.name == "Player":
		linear_velocity = Vector2(0,0)
		var new_direction = position - node.position
		linear_velocity = new_direction
		apply_impulse(new_direction * 3)
		inertia = TURKEY_WEIGHT		
		$scream1.play()	
		status = 3
>>>>>>> Stashed changes
