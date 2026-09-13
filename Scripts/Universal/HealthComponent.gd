extends Node
class_name HealthComponent


######################################### Variables #########################################

@export var health_amount := 1


######################################### Main functions #########################################

func add_health(health: int) -> void:
	health_amount = health

func received_damage() -> void:
	health_amount -= 1
