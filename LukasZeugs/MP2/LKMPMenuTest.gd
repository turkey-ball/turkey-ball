extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_host_pressed():
	$"../"._on_host_pressed()


func _on_join_pressed():
	$"../"._on_join_pressed()


# Single Player Spiel starten??
func _on_single_game_pressed():
	load(res://game.tscn)
	# pass # Replace with function body.
