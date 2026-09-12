extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jump_timer: Timer = $JumpTimer

const FALL_GRAVITY := 500.0
const FALL_VELOCITY := 200.0
const JUMP_VELOCITY := -200.0
const JUMP_DECELERATION := 10.0

var X_VELOCITY := 0.0
var X_DECELERATION := 20.0

## States
enum STATE {
	FALL,
	FLOOR,
	JUMP,
}

var active_state := STATE.FLOOR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_timer.wait_time = randf_range(3.0, 5.0)
	jump_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	DebugOverlay.add_stat("Slime", "velocity.x", velocity.x)
	DebugOverlay.add_stat("Slime", "X_VELOCITY", X_VELOCITY)
	match active_state:
		STATE.FALL:
			velocity.y = move_toward(velocity.y, FALL_VELOCITY, FALL_GRAVITY * delta)
			
			move_horizontally(delta)
			
			if is_on_floor():
				animation_player.play("Land")
				switch_state(STATE.FLOOR)
				
		STATE.FLOOR:
			velocity.x = -X_VELOCITY

		STATE.JUMP:
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)
			
			move_horizontally(delta)
			
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
		STATE.FLOOR:
			X_VELOCITY = 0.0
			jump_timer.start()
		STATE.JUMP:
			X_VELOCITY = randf_range(50.0, 100.0)
			X_DECELERATION = randf_range(15.0, 30.0)
			velocity.y = JUMP_VELOCITY

func move_horizontally(delta):
	velocity.x = -X_VELOCITY
	velocity.x = move_toward(velocity.x, 0, X_DECELERATION * delta)


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Jump":
		animation_player.play("Float")
		switch_state(STATE.JUMP)
	elif anim_name == "Land":
		animation_player.play("Idle")


func _on_jump_timer_timeout() -> void:
	animation_player.play("Jump")
	jump_timer.wait_time = randf_range(3.0, 5.0)
