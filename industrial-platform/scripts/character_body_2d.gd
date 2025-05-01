extends CharacterBody2D

@export var SPEED = 3
@export_range(0, 1) 
var lerp_factory = 0.5

@export_range(0, 90)
var max_tilt_degrees := 45

func _physics_process(_delta) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_velocity = direction * SPEED * 100.0
	velocity = lerp(velocity, target_velocity, lerp_factory)
	move_and_slide()

	# Corrigido: agora inclina para o lado certo
	var tilt = lerp(rotation_degrees, direction.x * max_tilt_degrees, lerp_factory)
	rotation_degrees = tilt
