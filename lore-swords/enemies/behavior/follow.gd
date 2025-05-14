extends CharacterBody2D

@export var speed = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var player_position = GameManager.player_position
	var diference = player_position - position
	var input_vector = diference.normalized()
										   
#input vector = vector =vector2 entre -1 e 1 em ambos os eixos
	velocity = input_vector * speed * 100.0
	move_and_slide()
	

		# Girar o sprite 	
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:		
		sprite.flip_h = true		
