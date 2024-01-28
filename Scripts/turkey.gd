extends RigidBody2D

const TURKEY_SPEED = 4

var status = 0
var idle_time = 0
const TURKEY_WEIGHT = 1
var rnd = RandomNumberGenerator.new()
var rnd_nmb1
var rnd_nmb2
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
	status = 0
	idle_time = 0
	linear_velocity = Vector2(0,0)
	$animation.play("idle")


func _process(_delta):
	if $animation.animation != "explosion":
		apply_torque(rotation_degrees*-0.8)

		if linear_velocity[0] >0 :
			$animation.flip_h = true
		if linear_velocity[0] <0 :
			$animation.flip_h = false

		if status == 0: # idle
			$animation.play("idle")
			idle_time += 1
			if idle_time > 300:
				rnd_nmb1 = rnd.randf_range(-1.0, 1.0)*0.3
				rnd_nmb2 = rnd.randf_range(-1.0, 1.0)*0.3
				status = 1
		elif status == 1: # idle 2
			$animation.play("walk")
			apply_impulse(Vector2(rnd_nmb1,rnd_nmb2))
		elif status == 2: # scared walking
			$animation.play("walk")
			apply_impulse(Vector2(rnd_nmb1,rnd_nmb2))
		elif status == 3: # kicked
			$animation.play("wingflap", 1.5) # je nach härte des kicks anpassbar
		elif status == 4: # goal explosion
			$animation.play("explosion")

func goal():
	$explosion2.play()
	$explosion1.play()
	status = 4

# IT'S A FEATURE
@export var haveChaosMode = false


func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player" \
	|| body.get_class() == "CharacterBody2D" \
	|| (typeof("CharacterBody2D") && haveChaosMode):		
		var new_direction = (position - body.position)/3
		linear_velocity = body.velocity / 1.2
		inertia = TURKEY_WEIGHT
		apply_impulse(new_direction * TURKEY_SPEED)
		$scream1.play()
		status = 3

func _on_animation_animation_finished():
	if $animation.animation == "explosion":
		_ready()

