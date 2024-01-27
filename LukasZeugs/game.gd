extends Node

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var PlayerID
var Player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	if(multiplayer.is_server()):
		print_once_per_client.rpc()
	pass # Replace with function body.

@rpc
func print_once_per_client():
	print("Printed once per connected client")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




#
#    NETZWERK !!!!!!111Elf
#

var num = 0

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _on_host_pressed():
	num += 1
	peer.create_server(1337)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$CanvasLayer.hide()
	
func _on_join_pressed():
	peer.create_client("127.0.0.1", 1337)
	multiplayer.multiplayer_peer = peer
	$CanvasLayer.hide()
	
func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	print("Player added: " + str(id))
	call_deferred("add_child", player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player", id)

@rpc("any_peer", "call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
