extends Node

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Arena.hide()
	$Ui.hide()
	$LkmpMenuTest.show()


func _on_arena_goal_hit(side):
	if side == 'left':
		$Ui.score_l += 1
	elif side == 'right':
		$Ui.score_r += 1
	

### Multiplayer Logik ###
var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
@export var turkey_scene : PackedScene
@export var turkey_scene2 : PackedScene
 
func _on_host_pressed():
	peer.create_server(1337)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$LkmpMenuTest.hide()
	$Arena.show()
	$Ui.show()
	$Ui/RunType.text = "H"
	$Arena/Turkey.queue_free()
	var turkey = turkey_scene.instantiate()
	turkey.name = "Turkey"
	$Arena.call_deferred("add_child", turkey)
	
func _on_join_pressed(ip = "127.0.0.1"):
	peer.create_client(ip, 1337)
	multiplayer.multiplayer_peer = peer
	$LkmpMenuTest.hide()
	$Arena.show()
	$Ui.show()
	$Ui/RunType.text = "C"
	$Arena/Turkey.queue_free()
	var turkey = turkey_scene2.instantiate()
	turkey.name = "Turkey"
	$Arena.call_deferred("add_child", turkey)

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

func _on_activate_toggled(toggled_on):
	print("toggle:" + str(toggled_on))
	
	var tk = $Arena/Turkey
	tk.haveChaosMode = toggled_on
	pass # Replace with function body.


### Singleplayer ###
func _on_single_game_pressed():
	$LkmpMenuTest.hide()
	$Arena.show()
	$Ui.show()
	$Ui/RunType.text = "S"
	$Ui/ScoreL.hide()
	add_player()
