extends Node

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var activeTurkey: RigidBody2D = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	activeTurkey = $Turkey

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_horizontal = Input.get_axis("ui_left", "ui_right")
	var direction_vertical = Input.get_axis("ui_up", "ui_down")
	if direction_horizontal:
		$Arena/Player.velocity.x = direction_horizontal * SPEED
	else:
		$Arena/Player.velocity.x = 0
	if direction_vertical:
		$Arena/Player.velocity.y = direction_vertical * SPEED
	else:
		$Arena/Player.velocity.y = 0

	$Arena/Player.move_and_slide()


func _on_arena_goal_hit(side):
	if side == 'left':
		$Ui.score_l += 1
	elif side == 'right':
		$Ui.score_r += 1
	$Arena/Turkey.explode()


func _on_turkey_tree_exited():
	var scene = load("res://Scenes/turkey.tscn")
	var instance = scene.instantiate()
	add_child(instance)
	activeTurkey = instance
