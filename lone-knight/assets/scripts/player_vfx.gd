extends AnimatedSprite2D
class_name player_vfx

@export var player : CharacterBody2D
var curr_state
var direction
var velocity : Vector2 = Vector2(0,0)
enum State {
	INVISIBLE,
	VISIBLE
}

func _ready():
	play("invisible")
	curr_state = State.INVISIBLE

func _process(_delta):
	match curr_state:
		State.INVISIBLE:
			invisible()
		State.VISIBLE:
			visible()
			
func _physics_process(delta):
	if curr_state == State.VISIBLE:
		velocity += Vector2(0,980) * delta
		velocity.x = 300 * direction
		rotation = atan2(velocity.y, velocity.x)
		
		global_position += velocity * Vector2(delta, delta)

func invisible():
	play("invisible")
	
func visible():
	play("eye_ball")
	
func _on_player_projectile_launch() -> void:
	curr_state = State.VISIBLE
	if player.animator.flip_h == true:
		direction = -1
	else:
		direction = 1
	global_position = player.global_position + Vector2(0,-40)
	velocity.y = -600


func _on_character_body_2d_collision() -> void:
	curr_state = State.INVISIBLE
