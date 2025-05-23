class_name Player
extends CharacterBody2D

@export var speed: float = 3
@export var suword_damage: int = 2
@export var health: int = 100

@export var max_health: int = 100

@export var death_prefab: PackedScene

@onready var sprite: Sprite2D = $sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
 
var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false 
var was_running: bool = false 
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0


func _process(delta: float)-> void:
	GameManager.player_position = position
	
	# ler input 
	read_input()
	
	#processar atack
	udpdate_attack_cooldown(delta)
	if Input.is_action_just_pressed("ataque"):
		attack()
			
	#processar animação e rotação do sprite
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()	
		
	# processa dano
	update_hitbox_detection(delta)	
		
func _physics_process(delta: float) -> void:

	#var target_velocity = input_vector * speed * 100.0
	#if is_attacking:
		#target_velocity *= 0.25
	#velocity = lerp(velocity, target_velocity, 0.05)
	#move_and_slide()
	
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25

	if input_vector.is_zero_approx():
		velocity = Vector2.ZERO
	else:
		velocity = lerp(velocity, target_velocity, 0.05)

	move_and_slide()

func udpdate_attack_cooldown(delta: float) -> void:
	#Atualizar temporizador de ataque 
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
	
func read_input() -> void:
	#obter o input vector 
	input_vector = Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo" )
		#close deadzone
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
		
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0	
		
		
	# Atualiza o estado de is_running
	was_running = is_running 
	is_running = not input_vector.is_zero_approx()	
		
func play_run_idle_animation() -> void:
	# Rodar a animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")		
			
func rotate_sprite() -> void:
		# Girar o sprite 	
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:		
		sprite.flip_h = true			
	
func attack() -> void:
	if is_attacking:
		return
	#Tocar animação
	animation_player.play( "ataque_cima-baixo")
	
	#confirmar temporizazador 		
	attack_cooldown = 0.6
	
	#marcar ataque
	is_attacking = true	



func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemyes"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT 
			var dot_product  = direction_to_enemy.dot(attack_direction)		
			if dot_product >= 0.3:	
				enemy.damage(suword_damage)
				
func update_hitbox_detection(delta: float) -> void:
	#Tempo para não receber dados 
	hitbox_cooldown -= delta 
	if hitbox_cooldown > 0: return
	
	#Frequência
	hitbox_cooldown = 0.5

	#detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemyes"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)
							
func damage(amount: int) -> void:
	if health <=0: return
	
	health -= amount
	print("Player atingido", amount, ". Avida total é", health )
	
	#Receber dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# transição de inimigo morto
	if health <= 0:
		die()
		
func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		print("Player morreu")	
		queue_free()			
		
func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	return health
		
				 			
		
