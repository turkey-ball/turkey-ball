extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _on_animation_animation_finished():
	if $animation.animation == "kick":
		$animation.pause()


func _process(_delta):
	
	if $animation.animation == "kick" :
		print($animation.animation)
		return
	if velocity[0] > 0 :
		$animation.flip_h = false 
	if velocity[0] < 0 :
		$animation.flip_h =  true
	
	if abs(velocity[0]) > 0.1 || abs(velocity[1]) > 0.1 :
		$animation.play("walk")
	else :
		$animation.pause()

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
	
