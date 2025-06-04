extends Node2D

var carne = 1

@export var regeneration_amount: int = 10

func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
		Globals.carne += carne
		queue_free()
