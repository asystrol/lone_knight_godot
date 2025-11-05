extends CharacterBody2D

@export var vfx : AnimatedSprite2D
signal collision

func _process(_delta):
	
	if vfx.curr_state == player_vfx.State.VISIBLE:
		if is_on_floor():
			collision.emit()
