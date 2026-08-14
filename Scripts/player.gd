extends CharacterBody2D

enum STATE {
	FALL,
	FLOOR,
	JUMP,
	FLOAT
}
const FALL_GRAVITY := 600.0
const FALL_VELOCITY := 200.0
const WALK_VELOCITY := 100.0
const JUMP_VELOCITY := -400.0
const JUMP_DECELERATION := 800.0

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation


var active_state := STATE.FALL

func _ready() -> void:
	switch_state(active_state)
	
	player_animation.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()
	
	## Adding infomration to DEBUG OVERLAY
	DebugOverlay.add_stat("Player", "Velocity X", roundf(velocity.x))
	DebugOverlay.add_stat("Player", "Velocity Y", roundf(velocity.y))

func switch_state(to_state: STATE) -> void:
	active_state = to_state

	## State specific things that need to run only once upon entering the next state
	match active_state:
		STATE.FALL:
			player_animation.play("Fall")
			
		STATE.JUMP:
			player_animation.play("Jump")
			velocity.y = JUMP_VELOCITY
			
		STATE.FLOAT:
			player_animation.play("Float")

func process_state(delta: float) -> void:
	match active_state:
		STATE.FALL:
			velocity.y = move_toward(velocity.y, FALL_VELOCITY, FALL_GRAVITY * delta)
			handle_movement()
			
			if is_on_floor():
				switch_state(STATE.FLOOR)
			#elif Input.is_action_just_pressed("Jump"):
				#switch_state(STATE.JUMP)
			
		STATE.FLOOR:
			if Input.get_axis("Left", "Right"):
				player_animation.play("Walk")
			else:
				player_animation.play("Idle")
			handle_movement()
			
			if not is_on_floor():
				switch_state(STATE.FALL)
			elif Input.is_action_just_pressed("Jump"):
				switch_state(STATE.JUMP)
		
		STATE.JUMP:
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)
			handle_movement()
				
			if Input.is_action_just_released("Jump") or velocity.y >= 0:
				velocity.y = move_toward(velocity.y, 0, 15000.0 * delta)
				switch_state(STATE.FALL)
				
func handle_movement() -> void:
	var input_direction := signf(Input.get_axis("Left", "Right"))
	if input_direction:
		player_animation.flip_h = input_direction > 0
	velocity.x = input_direction * WALK_VELOCITY

func _on_animation_finished():
	if player_animation.animation == "Jump":
		player_animation.play("Float")
