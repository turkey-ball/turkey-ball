extends Node

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Arena.hide()
	$Ui.hide()
	$Menu.show()
	$Timer.start()

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
	$Menu.hide()
	$Arena.show()
	$Ui.show()
	$Ui/RunType.text = "H"
	$Ui/ScoreL.show()
	$Ui/ScoreR.show()
	if $Arena/Turkey != null:
		$Arena/Turkey.queue_free()
	var turkey = turkey_scene.instantiate()
	turkey.name = "Turkey"
	$Arena.call_deferred("add_child", turkey)
	
func _on_join_pressed(ip = "127.0.0.1"):
	peer.create_client(ip, 1337)
	multiplayer.multiplayer_peer = peer
	multiplayer.server_disconnected.connect(_back_to_menu)
	$Menu.hide()
	$Arena.show()
	$Ui.show()
	$Ui/RunType.text = "C"
	$Ui/ScoreL.show()
	$Ui/ScoreR.show()
	if $Arena/Turkey != null:
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
	print("GAME chaos toggle:" + str(toggled_on))
	if $Arena/Turkey != null:
		print("GAME turkey toggled")
		var tk = $Arena/Turkey
		tk.haveChaosMode = toggled_on

### Singleplayer ###
func _on_single_game_pressed():
	is_singleplayer_active = true
	$Menu.hide()
	$Arena.show()
	$Ui.show()
	$Ui/RunType.text = "S"
	$Ui/ScoreL.hide()
	# $Ui/ColorRect.hide()
	if $Arena/Turkey != null:
		$Arena/Turkey.queue_free()
	var turkey = turkey_scene.instantiate()
	turkey.name = "Turkey"
	$Arena.call_deferred("add_child", turkey)
	add_player()

func _back_to_menu():
	# Player aus dem Spiel entfernen
	for child in get_children():
		if child.get_class() == "CharacterBody2D":
			exit_game(int(str(child.name)))
			child.queue_free()
	
	# Turkey aus der Arena entfernen
	for child in $Arena.get_children():
		if child.get_class() == "RigidBody2D" || child.get_class() == "CharacterBody2D":
			child.queue_free()
	
	$Menu.show()
	$Arena.hide()
	$Ui.hide()

var is_singleplayer_active = false
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		is_singleplayer_active = false
		if $Arena.visible:
			peer.close()
			_back_to_menu()
		# Beim Menü das Spiel beenden!
		elif $Menu.visible:
			get_tree().quit(0)

### Collectible logic ###
@export var spawn_collectibles : bool
@export var collectibles : Array[PackedScene]
@export var max_items : int = 10
@export_range(0, 2) var random_timer_min : int = 0
@export_range(8, 30) var random_timer_max : int = 10
@export var player_spawn_connect_timeout : int = 20
func _on_timer_timeout():
	print("peer size: " + str(multiplayer.get_peers().size()))
	if(multiplayer.get_peers().size() <= 0 && !is_singleplayer_active):
		print("GAME waiting for game to start ("+str(player_spawn_connect_timeout)+") ...")
		$Timer.wait_time = player_spawn_connect_timeout
		$Timer.start()
		return
	
	if collectibles.size() == 0 || !spawn_collectibles:
		# Fehler ausgeben und Timer neu setzen
		print("GAME collectibles empty or can not spawn collectibles")
		$Timer.start()
		return
	
	if max_items != null && $Arena/Collectibles.get_child_count() >= max_items:
		print("GAME max items ("+str(max_items)+") spawned. Collect or destroy existing items.")
		return
	
	# Random platzieren von items...
	if collectibles.size() > 0 && spawn_collectibles:
		# Geändert wegen RPC??
		create_powerup(randi_range(0, collectibles.size() - 1))
		#var _sel_item = collectibles[randi_range(0, collectibles.size() - 1)]
		#if _sel_item != null:
		#	var item = _sel_item.instantiate()
		#	item.name = "Collectible"
		#	$Arena/Collectibles.call_deferred("add_child", item)
		#	print("GAME collectible '"+str(item.name)+"' spawned")
		#	#create_powerup(item)
		#else:
		#	print("GAME collectible was empty and could not be spawned")
		$Timer.wait_time = randi_range(random_timer_min, random_timer_max)
		print("GAME timer reset with: " + str($Timer.wait_time))
		$Timer.start() # reset?

func create_powerup(rng):
	rpc("_create_powerup", rng)

@rpc("any_peer", "call_local")
func _create_powerup(rng):
	var _sel_item = collectibles[rng]
	if _sel_item != null:
		var item = _sel_item.instantiate()
		item.name = "Collectible"
		$Arena/Collectibles.call_deferred("add_child", item)
		print("GAME collectible '"+str(item.name)+"' spawned")
		#create_powerup(item)
	else:
		print("GAME collectible was empty and could not be spawned")
	

'''
func create_powerup(item):
	rpc("_create_powerup", item)

@rpc("any_peer", "call_local")
func _create_powerup(_sel_item):
	var item = _sel_item.instantiate()
	item.name = "Collectible"
	$Arena/Collectibles.call_deferred("add_child", item)
	print("GAME collectible '"+str(item.name)+"' spawned")
	pass
'''
