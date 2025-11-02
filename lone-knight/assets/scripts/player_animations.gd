extends AnimatedSprite2D

@export var player : CharacterBody2D
signal double_jump
var down_slash := false

func _process(_delta):
	match player.curr_state:
		playercontrol.State.IDLE:
			idle()
		playercontrol.State.ATTACK:
			attack()
		playercontrol.State.IN_AIR:
			in_air()
		playercontrol.State.DASH:
			dash()
	
func idle():
	if player.direction == 0:
		play("idle")
	else:
		play("run")
		if player.direction == 1:
			flip_h = false
		else:
			flip_h = true
		
func attack():
	play("attack")
	
func in_air():
	
	if player.direction == 1:
		flip_h = false
	elif player.direction == -1:
		flip_h = true
	if down_slash:
		play("down_slash")
		if frame == 1:
			double_jump.emit()
	else:
		if player.velocity.y < 0:
			if player.jump_count == 1:
				play("jump")
		else:
			play("fall")
				
		if player.jump_count == 2 and Input.is_action_just_pressed("jump"):
			down_slash = true
			player.jump_count += 1
		
	
	
func dash():
	play("dash")
		


func _on_animation_finished() -> void:
	if animation == "down_slash":
		down_slash = false
