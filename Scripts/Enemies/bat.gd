extends CharacterBody2D
class_name Bat

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var FLY_VELOCITY := 25.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FLY_VELOCITY = randf_range(20.0, 40.0)
	animation_player.play("Fly")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity.x = -FLY_VELOCITY
	
	move_and_slide()
