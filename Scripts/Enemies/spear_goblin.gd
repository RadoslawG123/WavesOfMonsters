extends CharacterBody2D

@export var WALK_VELOCITY := 20.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x = -WALK_VELOCITY * delta
	move_and_slide()
