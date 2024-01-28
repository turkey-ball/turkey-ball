extends CharacterBody2D
var direction : Vector2

const SPEED = 800.0

func _ready():
	pass#direction = Vector2(1,0) *rotation
func _physics_process(delta):
	velocity = SPEED * direction

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name != "Bullet" and body.name != "1":
		$splash.play()
		print(body.name)
		velocity = Vector2(0,0)
		


func _on_splash_finished():
	queue_free()
