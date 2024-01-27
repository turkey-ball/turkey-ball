extends Node

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	if(multiplayer.is_server()):
		print_once_per_client.rpc()

@rpc
func print_once_per_client():
	print("Printed once per connected client")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




#
#    Netzwerk Logik. Aktuell: Test
#

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
@export var spawn_point_left : Node2D
@export var spawn_point_right : Node2D

func _on_host_pressed():
	peer.create_server(1337)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$CanvasLayer.hide()
	
func _on_join_pressed():
	peer.create_client("127.0.0.1", 1337)
	multiplayer.multiplayer_peer = peer
	rpc_id(1, "set_player_position", spawn_point_right.position)
	$CanvasLayer.hide()

func add_player(id = 1):
	# Packe das hier hin, falls ich das später noch einmal anschauen möchte.
	#var screen_size = get_viewport().size
	#player.position.x = screen_size.x / 2
	#player.position.y = screen_size.y / 2
	
	var player = player_scene.instantiate()
	player.name = str(id)
	player.myplayerid = id
	
	# Wollte den Shape deaktivieren, hab das im Objekt gemacht, weils schneller geht.
	for shape_index in range(player.get_child_count()):
		if player.get_child(shape_index) is CollisionShape2D:
			print("deactivated:" + player.get_child(shape_index).name)
			#player.get_child(shape_index).disabled = true
			#player.get_child(shape_index).visible = false
			player.get_child(shape_index).queue_free()
			
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
