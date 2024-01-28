extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_host_pressed():
	$"../"._on_host_pressed()


func _on_join_pressed():
	var ip = $IpOverrideField.text
	$"../"._on_join_pressed(ip)


func _on_single_game_pressed():
	$"../"._on_single_game_pressed()


func _on_chaos_mode_toggled(toggled_on):
	if toggled_on == true:
		$"../"._on_activate_toggled()
	# $"../"._on_activate_pressed()


func _on_exit_pressed():
	get_tree().quit()

