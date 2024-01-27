extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

# Von: Lukas
func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Beispiel ist in 3D. Welche Cam in 2D. Dazu noche exit game qenn input 'quit
# und physics process when multiplayer authority ...
# https://www.youtube.com/watch?v=M0LJ9EsS_Ak
#func _ready():
#	cam.current = is_multiplayer_authority()
