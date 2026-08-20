extends Node
class_name Hurtbox

@onready var health_component: HealthComponent = $"../HealthComponent"

@export var is_player := false

func get_hit():
	if health_component:
		health_component.received_damage()
		print("Życie:", health_component.health_amount)
