extends AnimatedSprite2D

@export var player : CharacterBody2D
@export var player_animation : AnimatedSprite2D

func _ready():
	play("invisible")


func _process(_delta):
	match player.curr_state:
		playercontrol.State.DASH:
			if player.is_on_floor():
				play("still")
			else:
				play("invisible")


func _on_animated_sprite_2d_animation_finished() -> void:
	if player_animation.animation == "dash":
		if player.is_on_floor():
			play("live")


func _on_player_on_ground() -> void:
	play("live")
