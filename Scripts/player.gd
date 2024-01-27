extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
func _ready():
	$animation.play("laugh")
# Von: Lukas
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

# Beispiel ist in 3D. Welche Cam in 2D. Dazu noche exit game qenn input 'quit
# und physics process when multiplayer authority ...
# https://www.youtube.com/watch?v=M0LJ9EsS_Ak
#func _ready():
#	cam.current = is_multiplayer_authority()

'''
signal scare_turkey(pos: Vector2)
signal kick_turkey(pos: Vector2)
func _on_surrounding_child_entered_tree(node):
	if node.name == "Turkey":

		scare_turkey.emit(position)

func _on_feet_child_entered_tree(node):
	if node.name == "Turkey":
		kick_turkey.emit(position)
'''

### Multiplayer ###
@export var myplayerid:int
func _ready():
	#get_node("AnimatedSprite2D").play("default")
	
	# Problem "gelöst". So kann er die Spawnpunkte abfangen und setzen.
	var sp1 = $"../"/Arena/SpawnPoints/SP1
	var sp2 = $"../"/Arena/SpawnPoints/SP2
	
	if myplayerid == 1:
		position = sp1.position
	else: # id = 0??
		position = sp2.position

### Controller ###
# INFO: Spieler werden durch mein Script mit IDs hinzugefügt, daher kann die
# Steuerung nicht in game.gd liegen.

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

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
	if body.name == "Turkey":
		$animation.play("kick")
	pass # Replace with function body.


func _on_animation_animation_looped():
	if $animation.animation == "kick":
		$animation.play("laugh")
	pass # Replace with function body.

