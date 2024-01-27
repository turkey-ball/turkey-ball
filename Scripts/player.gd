extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	#$animation.play("walk")

# Von: Lukas
func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _process(delta):
	if velocity[0] > 0 :
		$animation.flip_h = false 
	if velocity[0] < 0 :
		$animation.flip_h =  true
	
	if abs(velocity[0]) > 0.1 || abs(velocity[1]) > 0.1 :
		$animation.play("walk")
	else :
		$animation.play("laugh")

# Beispiel ist in 3D. Welche Cam in 2D. Dazu noche exit game qenn input 'quit
# und physics process when multiplayer authority ...
# https://www.youtube.com/watch?v=M0LJ9EsS_Ak
#func _ready():
#	cam.current = is_multiplayer_authority()

signal scare_turkey(pos: Vector2)
signal kick_turkey(pos: Vector2)
func _on_surrounding_child_entered_tree(node):
	if node.name == "Turkey":
		$animation.play("kick")
		scare_turkey.emit(position)

func _on_feet_child_entered_tree(node):
	if node.name == "Turkey":
		kick_turkey.emit(position)
