extends CharacterBody2D
class_name playercontrol

const speed = 200
const jump_velocity = -400
const acceleration = speed / 0.1
const deacceleration = speed / 0.04
var dashrange = 150
var curr_state
var direction = 0
var dash_dir = 1
var jump_count := 0
@export var animator : AnimatedSprite2D

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
	if is_on_floor():
		jump_count = 0


func _physics_process(delta):

	match curr_state:
		State.IDLE:
			idle()
		State.ATTACK:
			attack()
		State.IN_AIR:
			in_air()
		State.DASH:
			dash(delta)
			
	if curr_state != State.DASH:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			curr_state = State.IN_AIR
			jump_count += 1
		direction = Input.get_axis("left","right")
			
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if direction == 0:
			if abs(velocity.x) > 40:
				velocity.x += deacceleration * delta * sign(velocity.x) * (-1)
			else:
				velocity.x = 0
		else:
			if abs(velocity.x) < speed:
				velocity.x += acceleration * delta * direction
			
	move_and_slide()
	
func idle():
	pass

func attack():
	pass
	
func in_air():
	if jump_count < 2:
		if Input.is_action_just_pressed("jump"):
			jump_count += 1

func dash(delta):
	if animator.flip_h:
		dash_dir = -1
	else:
		dash_dir = 1
	global_position.x += dashrange * delta * dash_dir / 0.1
	velocity.y = 0
	
	


func _on_animated_sprite_2d_animation_finished() -> void:
	curr_state = State.IDLE
	#if animator.animation == "dash":
		#global_position.x += 82 * dash_dir


func _on_animated_sprite_2d_double_jump() -> void:
	velocity.y = jump_velocity
