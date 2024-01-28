extends CharacterBody2D
var direction : Vector2
const SPEED = 800.0
var player_name 

func _ready():
	direction = (Vector2(1,0).rotated(rotation_degrees/180* PI))#.normalized()
	print("player name:",player_name)
	print("name:",name)
	
func _physics_process(delta):		
	velocity = SPEED * direction
	move_and_slide()

func _on_area_2d_body_entered(body):
	if !body.get("player_name") and body.name != player_name:
		$splash.play()
		print(body.name)
		velocity = Vector2(0,0)
		


func _on_splash_finished():
	queue_free()
