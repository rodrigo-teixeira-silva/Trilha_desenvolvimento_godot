extends CharacterBody2D

#const speed = 400.0
@export var SPEED = 3
@export_range(0,1) 
var lerp_factory = 0.5


func  _physics_process(_delta) -> void:	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down" )
	var target_velocity = direction * SPEED * 100.0
	velocity = lerp(velocity, target_velocity, lerp_factory)	
	move_and_slide()	
