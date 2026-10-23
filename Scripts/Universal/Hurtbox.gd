extends Area2D
class_name Hurtbox

######################################### Signals #########################################

signal enemy_died()

######################################### Variables #########################################

## Onready variables
@onready var health_component: HealthComponent = $"../HealthComponent"
@onready var hit_stop_timer: Timer = $HitStopTimer
@onready var hurtbox_collider: CollisionShape2D = $HurtboxCollider

## Export variables
@export var is_player := false
@export var sprite: Node2D
@export var enemy_body: CharacterBody2D
@export var push_force := 130.0
@export var insensitivity_colldawn: Timer

## push_back() variables
var X_VELOCITY_shelf: float
var knockback_tween: Tween

## Main scene variables
var player: Player
var camera: Camera2D

######################################### Main functions #########################################

## Ready: Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_tree().get_first_node_in_group("Camera")
	player = get_tree().get_first_node_in_group("Player")
	X_VELOCITY_shelf = owner.X_VELOCITY

## GET HIT
func get_hit():
	if health_component:
		Engine.time_scale = 0.1
		camera.offset = Vector2(0.9, 0.9)
		hit_stop_timer.start()
		health_component.received_damage()
		
		if health_component.health_amount <= 0:
			die()
			return
			
		if is_player:
			insensitivity()
			UI.change_player_health()
			
		flash_white()
		if not is_player:
			knockback()
		#print("Życie:", health_component.health_amount)


######################################### Other functions #########################################

## DIE
func die():
	if not is_player:
		# When enemy dies emit signal to monster_generator script
		enemy_died.emit()
		
		# Delete object from main scene
		get_parent().queue_free()
		if Engine.time_scale == 0.1:
			Engine.time_scale = 1.0
	else:
		get_parent().queue_free()

## KNOCKBACK
func knockback():
	# Reset knocbkack_tween by killing it, reset push_timer by stopping it
	if knockback_tween != null:
		knockback_tween.kill()
	
	enemy_body.set_collision_layer_value(2, false)
	
	# Craete tween for smooth variable changing
	knockback_tween = create_tween()
	
	# Knockback move formula (including player velocity while hitting)
	owner.X_VELOCITY = push_force * float(player.sword_cut_line_1.scale.x) * (abs(player.velocity.x*0.01)+1)
	
	knockback_tween.set_trans(Tween.TRANS_QUAD)
	knockback_tween.set_ease(Tween.EASE_OUT)
	
	# Smooth slowing down while knockback
	knockback_tween.tween_property(owner, "X_VELOCITY", 0.0, 0.5)
	knockback_tween.finished.connect(_on_knockback_ended)

func insensitivity():
	hurtbox_collider.set_deferred("disabled", true)
	sprite.material.set_shader_parameter("custom_modulate", Color(1, 1, 1, 0.5))
	insensitivity_colldawn.start()

## Test function from gemini
func flash_white():
	# Zabezpieczenie: czy przypisaliśmy sprite i czy ma on nasz shader?
	if sprite != null and sprite.material != null:
		
		# Tworzymy Twena (narzędzie do płynnej animacji w kodzie)
		var tween = create_tween()
		
		# 1. Natychmiast ustawiamy suwak shadera na 1.0 (Goblin jest w 100% biały)
		sprite.material.set_shader_parameter("flash_modifier", 1.0)
		
		# 2. Płynnie zmniejszamy ten suwak do 0.0 (normy) przez 0.5 sekundy
		# tween_property (obiekt, "co zmieniamy", wartość_docelowa, czas_w_sekundach)
		tween.tween_property(sprite.material, "shader_parameter/flash_modifier", 0.0, 0.5)

######################################### Signal functions #########################################

## When knockabck ends give back normal velocity to object
func _on_knockback_ended():
	owner.X_VELOCITY = X_VELOCITY_shelf
	enemy_body.set_collision_layer_value(2, true)

## When enemy go past the village (somewhere about right border of the main screen)
func _on_village_enemy_entered(area: Area2D) -> void:
	if area.is_in_group("Village"):
		UI.change_village_health()
		die()

## When HitStopTimer ends turn on normal time_scale and reset camera offset
func _on_hit_stop_timer_timeout() -> void:
	Engine.time_scale = 1.0
	camera.offset = Vector2(0.0,0.0)

func _on_insensitivity_colldawn_timeout() -> void:
	hurtbox_collider.set_deferred("disabled", false)
	sprite.material.set_shader_parameter("custom_modulate", Color(1, 1, 1, 1.0))

######################################### Player hitbox functions #########################################

## Signal function: Player collides with enemy
func _on_player_enemy_entered(body: Node2D) -> void:
	if is_player and body.is_in_group("Enemy"):
		get_hit()

## Signal function: Player collides with projectile
func _on_player_projectile_entered(area: Area2D) -> void:
	if is_player and area.is_in_group("Spear"):
		get_hit()
		area.set_collision_mask_value(4, false)
