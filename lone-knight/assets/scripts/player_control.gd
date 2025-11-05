extends CharacterBody2D
class_name playercontrol

const speed = 300
const jump_velocity = -400
const acceleration = speed / 0.1
const deacceleration = speed / 0.04
var dashrange = 150
var curr_state
var direction = 0
var dash_dir = 1
var jump_count := 0
@export var animator : AnimatedSprite2D

signal on_ground
signal projectile_launch

enum State {
	IDLE,
	ATTACK,
	IN_AIR,
	DASH,
	PROJECTILE,
}

func _ready():
	curr_state = State.IDLE

func _process(_delta):

	if Input.is_action_just_pressed("dash") or curr_state == State.DASH:
		curr_state = State.DASH
	elif Input.is_action_just_pressed("attack") or curr_state == State.ATTACK:
		curr_state = State.ATTACK
	elif Input.is_action_just_pressed("projectile") or curr_state == State.PROJECTILE:
		curr_state = State.PROJECTILE
		
	if is_on_floor():
		jump_count = 0


func _physics_process(delta):
	print(get_gravity())

	match curr_state:
		State.IDLE:
			idle(delta)
		State.ATTACK:
			attack()
		State.PROJECTILE:
			projectile()
		State.IN_AIR:
			in_air(delta)
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
			if abs(velocity.x) > 60:
				velocity.x += deacceleration * delta * sign(velocity.x) * (-1)
			else:
				velocity.x = 0
				animator.rotation = 0
		else:
			if velocity.x/direction < speed:
				velocity.x += acceleration * delta * direction
		
			
	move_and_slide()
	
func idle(delta):
	if not is_on_floor():
		curr_state = State.IN_AIR
	if direction:
		if (animator.rotation_degrees/direction) < 10:
			animator.rotate(0.17*delta*direction / 0.05)
		

func attack():
	animator.rotation = 0
	
func projectile():
	animator.rotation = 0
	if animator.frame == 1:
		projectile_launch.emit()
	
func in_air(_delta):
	if jump_count < 2:
		if Input.is_action_just_pressed("jump"):
			jump_count += 1
			
	animator.rotation = 0
	
	if is_on_floor():
		curr_state = State.IDLE
		on_ground.emit()

func dash(delta):
	animator.rotation = 0
	
	if animator.flip_h:
		dash_dir = -1
	else:
		dash_dir = 1
	global_position.x += dashrange * delta * dash_dir / 0.1
	velocity.y = 0
	
	


func _on_animated_sprite_2d_animation_finished() -> void:
	curr_state = State.IDLE


func _on_animated_sprite_2d_double_jump() -> void:
	velocity.y = jump_velocity
