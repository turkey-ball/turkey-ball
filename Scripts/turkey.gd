extends RigidBody2D
var status = 0 
var idle_time = 0
var velocity = 1
# 0: idle
# 1: move random
# 2: moves from player
# 3: get's kicked / flyes away

func _ready():
	#$scream1.play()
	#await $scream1.finished
	#$scream2.play()
	pass

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(rotation_degrees)
	if rotation_degrees > 1:
		rotation_degrees -= _delta*5
	elif rotation_degrees < -1:
		rotation_degrees += _delta*5
	if rotation_degrees > -3 and rotation_degrees < 3:
		status = 0
	if status == 0:
		$animation.play("idle")
		idle_time += 1
		if idle_time > 100:
			status = 1
	elif status == 1:
		$animation.play("walk")					
		if (velocity < 0.5):
			status = 0
			idle_time = 0
	elif status == 2:
		$animation.play("walk")
		if (velocity < 0.5):
			status = 0
			idle_time = 0
	elif status == 3:		
		$animation.play("wingflap", 1.5) # je nach härte des kicks anpassbar
		if (velocity < 0.5):
			status = 0
			idle_time = 0		
			
	
	pass

"""
var speed: float = 0.1

func look_follow(state: PhysicsDirectBodyState3D, current_transform: Transform3D, target_position: Vector3) -> void:
	var forward_local_axis: Vector3 = Vector3(1, 0, 0)
	var forward_dir: Vector3 = (current_transform.basis * forward_local_axis).normalized()
	var target_dir: Vector3 = (target_position - current_transform.origin).normalized()
	var local_speed: float = clampf(speed, 0, acos(forward_dir.dot(target_dir)))
	if forward_dir.dot(target_dir) > 1e-4:
		state.angular_velocity = local_speed * forward_dir.cross(target_dir) / state.step

func _integrate_forces(state):
	var target_position = $Turkey.global_transform.origin
	look_follow(state, global_transform, target_position)
"""
func _integrate_forces(_state):
	pass

func _on_area_2d_body_entered(body:Node2D):
	print(body)
	if body.name == "Player":
		linear_velocity = Vector2(0,0)
		var new_direction = position - body.position
		apply_impulse(new_direction * 10)
		$scream1.play()	
		status = 3
		
		pass
