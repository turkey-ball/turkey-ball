extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_node("AnimatedSprite2D").play("default")

func _init():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

# Von: Lukas
func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Beispiel ist in 3D. Welche Cam in 2D. Dazu noche exit game wenn input 'quit
# und physics process when multiplayer authority ...
# https://www.youtube.com/watch?v=M0LJ9EsS_Ak
#func _ready():
#	cam.current = is_multiplayer_authority()
#func _ready():
#	print("trying to hide player " + name + ": " + str(!is_multiplayer_authority()))
#	visible = is_multiplayer_authority()

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
