extends Node
class_name Hurtbox

@onready var health_component: HealthComponent = $"../HealthComponent"

@export var is_player := false
@export var sprite: Node2D

func get_hit():
	if health_component:
		health_component.received_damage()
		flash_white()
		print("Życie:", health_component.health_amount)

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
