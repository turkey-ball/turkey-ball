extends Control

func _on_host_pressed():
	$"../"._on_host_pressed()

func _on_join_pressed():
	var ip = $IpOverrideField.text
	$"../"._on_join_pressed(ip)

func _on_single_game_pressed():
	$"../"._on_single_game_pressed()

func _on_chaos_mode_toggled(toggled_on):
	$"../"._on_activate_toggled(toggled_on)

func _on_exit_pressed():
	get_tree().quit()
