extends CharacterBody2D

const speed = 200
const jump_velocity = -400
const acceleration = speed / 0.1
const deacceleration = speed / 0.04
var dashvel = 4000
var curr_state
var direction = 0
var animator : AnimatedSprite2D

enum State {
	IDLE,
	ATTACK,
	IN_AIR,
	DASH,
}

func _ready():
	curr_state = State.IDLE

func _process(_delta):
	if Input.is_action_just_pressed("dash") or curr_state == State.DASH:
		curr_state = State.DASH
	elif Input.is_action_just_pressed("attack"):
		curr_state = State.ATTACK
	elif not is_on_floor():
		curr_state = State.IN_AIR
	else:
		curr_state = State.IDLE


func _physics_process(delta):
	
	if curr_state != State.DASH:
		if Input.is_action_pressed("right"):
			direction = -1
		elif Input.is_action_pressed("left"):
			direction = 1
		else:
			direction = 0
			
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if direction == 0:
			if abs(velocity.x) != 0:
				velocity.x += deacceleration * delta * sign(velocity.x)
		else:
			if abs(velocity.x) < speed:
				velocity.x += acceleration * delta * direction
				
	match curr_state:
		State.IDLE:
			idle()
		State.ATTACK:
			attack()
		State.IN_AIR:
			in_air()
		State.DASH:
			dash()
	
func idle():
	pass

func attack():
	pass
	
func in_air():
	pass

func dash():
	velocity.x = dashvel * direction


func _on_animated_sprite_2d_animation_finished() -> void:
	curr_state = State.IDLE
