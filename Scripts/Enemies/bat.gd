extends CharacterBody2D
class_name Bat


##### Variables #####

## Onready variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Export variables
@export var X_VELOCITY := 25.0


##### Main functions #####

## _ready: Called when the node enters the scene tree for the first time.
func _ready() -> void:
	X_VELOCITY = randf_range(20.0, 40.0)
	animation_player.play("Fly")


## _physics_process: Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity.x = -X_VELOCITY
	
	move_and_slide()
