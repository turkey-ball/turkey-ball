extends CharacterBody2D

const SPEED = 300.0

@export var bullet : PackedScene


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _on_animation_animation_finished():
	if $animation.animation == "kick":
		$animation.play("idle")
	


func _process(_delta):
	
	if $animation.animation == "kick" :
		return
	if velocity[0] > 0 :
		$animation.flip_h = false 
	if velocity[0] < 0 :
		$animation.flip_h =  true
	
	if abs(velocity[0]) > 0.1 || abs(velocity[1]) > 0.1 :
		$animation.play("walk")
	else:
		$animation.play("idle")

### Multiplayer ###
@export var myplayerid:int
func _ready():
	$animation.play("laugh")
	$animation.play("laugh")
	$hohoho.play()
	
	# Problem "gelöst". So kann er die Spawnpunkte abfangen und setzen.
	var sp1 = $"../"/Arena/SpawnPoints/SP1
	var sp2 = $"../"/Arena/SpawnPoints/SP2
	
	if myplayerid == 1:
		position = sp1.position
	else: # id = 0??
		position = sp2.position

func _physics_process(_delta):
	if !is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed("click"):
		shoot()
		#rpc("shoot_rpc")
	$watergun.look_at(get_viewport().get_mouse_position())
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_horizontal = Input.get_axis("ui_left", "ui_right")
	var direction_vertical = Input.get_axis("ui_up", "ui_down")
	if direction_horizontal:
		velocity.x = direction_horizontal * SPEED
	else:
		velocity.x = 0
	if direction_vertical:
		velocity.y = direction_vertical * SPEED
	else:
		velocity.y = 0
		
	move_and_slide()
  
func _on_feet_area_body_entered(body):
	if body.name == "Turkey2":
		$animation.play("kick")

func goal():
	print("Player-Goal")
	$animation.play("laugh")
	$hohoho.play()

'''
func shoot():
	if !is_multiplayer_authority():
		return
	var b = preload("res://Scenes/bullet.tscn").instantiate()	
	b.global_position = $watergun.global_position
	b.rotation_degrees = $watergun.rotation_degrees
	b.player_name = self.name
	get_tree().root.add_child(b)
	if velocity == Vector2(0,0) and $animation.flip_h:
		b.global_position[0] = b.global_position[0] - 40
	#elif velocity == Vector2(0,0) and !$animation.flip_h:
		#b.direction = Vector2(1,0)
'''

func _on_watergun_animation_finished():
	$watergun.pause("default")

func shoot():
	rpc("_shoot")

# RPC TEST???
@rpc("any_peer", "call_local")
func _shoot():
	print("RPC CALLED!?")

	var b = preload("res://Scenes/bullet.tscn").instantiate()	
	b.global_position = $watergun.global_position
	b.rotation_degrees = $watergun.rotation_degrees
	b.player_name = self.name
	get_tree().root.add_child(b)
	if velocity == Vector2(0,0) and $animation.flip_h:		
		#b.direction = Vector2(-1,0)
		b.global_position[0] = b.global_position[0] - 40
		
	var peer_id = multiplayer.get_remote_sender_id()
	if peer_id == get_multiplayer_authority():
		# The authority is not allowed to call this function.
		return
	print("RPC called by: ", peer_id)
