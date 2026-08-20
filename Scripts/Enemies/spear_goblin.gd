extends CharacterBody2D

@export var WALK_VELOCITY := 20.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Walk_Spear")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity.x = -WALK_VELOCITY
	
	if Input.is_action_pressed("Attack"):
		animation_player.play("Throw")
	
	# DebugOverlay
	DebugOverlay.add_stat("Goblin", "velocity X: ", velocity.x)
	
	move_and_slide()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Throw":
		animation_player.play("Walk")
