extends AnimatedSprite2D

@export var player : CharacterBody2D

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
	print("in_air")
	if player.direction == 1:
		flip_h = false
	elif player.direction == -1:
		flip_h = true
	if player.velocity.y < 0:
		play("jump")
	else:
		play("fall")
	
func dash():
	play("dash")
		
