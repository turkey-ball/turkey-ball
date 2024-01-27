extends Node

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Arena.hide()
	$Ui.hide()
	pass # Replace with function body.

'''
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
'''

func _on_arena_goal_hit(side):
	if side == 'left':
		$Ui.score_l += 1
	elif side == 'right':
		$Ui.score_r += 1

### Multiplayer Logik ###
var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _on_host_pressed():
	peer.create_server(1337)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$LkmpMenuTest.hide()
	$Arena.show()
	$Ui.show()
	
func _on_join_pressed():
	peer.create_client("127.0.0.1", 1337)
	multiplayer.multiplayer_peer = peer
	$LkmpMenuTest.hide()
	$Arena.show()
	$Ui.show()

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.myplayerid = id
			
	print("Player added: " + str(id))
	print("=> Player position: " + str(player.position) + ", VP-Size: " + str(get_viewport().size))
	call_deferred("add_child", player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player", id)

@rpc("any_peer", "call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
