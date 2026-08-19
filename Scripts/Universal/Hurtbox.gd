extends Node
class_name Hurtbox

@onready var health_component: HealthComponent = $"../HealthComponent"
@export var is_player := false
@export var object_animation: AnimatedSprite2D

func get_hit():
	if health_component:
		health_component.received_damage()
		print("Życie:", health_component.health_amount)
