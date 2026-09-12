extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var X_VELOCITY := -100.0
var X_DECELERATION := 20.0
const FALL_GRAVITY := 500.0
const FALL_VELOCITY := 200.0
const JUMP_VELOCITY := -200.0
const JUMP_DECELERATION := 10.0

## States
enum STATE {
	FALL,
	FLOOR,
	JUMP,
}

var active_state := STATE.FLOOR


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	DebugOverlay.add_stat("Slime", "velocity.x", velocity.x)
	DebugOverlay.add_stat("Slime", "X_VELOCITY", X_VELOCITY)
	match active_state:
		STATE.FALL:
			velocity.y = move_toward(velocity.y, FALL_VELOCITY, FALL_GRAVITY * delta)
			
			moving_horizontally(delta)
			
			if is_on_floor():
				velocity.x = 0.0
				#animation_player.play("Jump")
				switch_state(STATE.FLOOR)
				
		STATE.FLOOR:
			if Input.is_action_just_pressed("DebugEnemy"):
				switch_state(STATE.JUMP)
		STATE.JUMP:
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)
			
			moving_horizontally(delta)
			
			if velocity.y >= 0:
				if velocity.y >= -100:
					velocity.y *= 0.5
				else:
					velocity.y *= 0.3
			switch_state(STATE.FALL)
			
	move_and_slide()

func switch_state(to_state: STATE) -> void:
	active_state = to_state
	
	match active_state:
		STATE.JUMP:
			velocity.y = JUMP_VELOCITY

func moving_horizontally(delta):
	velocity.x = X_VELOCITY
	velocity.x = move_toward(velocity.x, 0, X_DECELERATION * delta)
