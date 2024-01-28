extends CharacterBody2D

# 0: idle
# 1: move random
# 2: moves from player
# 3: get's kicked / flyes away

func _ready():
	var screen_size = get_viewport().size
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	name = "Turkey"
	pass
	
func goal():
	pass
