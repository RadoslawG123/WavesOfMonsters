extends Node
class_name Hurtbox


##### Variables #####

## Onready variables
@onready var health_component: HealthComponent = $"../HealthComponent"
@onready var push_timer: Timer = $PushTimer

## Export variables
@export var is_player := false
@export var sprite: Node2D
@export var push_force := 100.0

## push_back() variables
var X_VELOCITY_shelf: float
var knockback_tween: Tween

## Player scene variable
var player: Player

##### Main functions #####

## Ready: Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	X_VELOCITY_shelf = owner.X_VELOCITY

## GET HIT
func get_hit():
	if health_component:
		health_component.received_damage()
		
		if health_component.health_amount <= 0:
			die()
			return
			
		flash_white()
		knockback()
		#print("Życie:", health_component.health_amount)

## DIE
func die():
	if not is_player:
		# Delete object from main scene
		get_parent().queue_free()

## KNOCKBACK
func knockback():
	if not is_player:
		# Reset knocbkack_tween by killing it, reset push_timer by stopping it
		if knockback_tween != null:
			knockback_tween.kill()
			push_timer.stop()
		
		# Craete tween for smooth variable changing
		knockback_tween = create_tween()
		
		# Knockback move formula (including player velocity while hitting)
		owner.X_VELOCITY = push_force * float(player.hitbox_1.scale.x) * (abs(player.velocity.x*0.01)+1)
		
		# Smooth slowing down while knockback
		knockback_tween.tween_property(owner, "X_VELOCITY", 0, push_timer.wait_time)
		push_timer.start()

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

## Signal function: When push_timer reaches the end give back normal velocity to object
func _on_push_timer_timeout() -> void:
	owner.X_VELOCITY = X_VELOCITY_shelf

##### Player hitbox functions #####

## Signal function: Player collides with enemy
func _on_player_enemy_entered(body: Node2D) -> void:
	if is_player and body.is_in_group("Enemy"):
		get_hit()

## Signal function: Player collides with projectile
func _on_player_projectile_entered(area: Area2D) -> void:
	if is_player and area.is_in_group("Enemy"):
		get_hit()
