extends Node
class_name HealthComponent

@export var health_amount := 1

func add_health(health: int) -> void:
	health_amount = health

func received_damage() -> void:
	health_amount -= 1
	
