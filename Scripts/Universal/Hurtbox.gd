extends Node
class_name Hurtbox

@onready var health_component: HealthComponent = $"../HealthComponent"
@export var is_player := false
@export var object_animation: AnimatedSprite2D

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and not is_player:
		object_animation.modulate = Color(18.892, 18.892, 18.892)
		health_component.received_damage()
