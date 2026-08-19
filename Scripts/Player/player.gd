extends CharacterBody2D
class_name Player

enum STATE {
	FALL,
	FLOOR,
	JUMP,
}
const FALL_GRAVITY := 500.0
const FALL_VELOCITY := 200.0
const WALK_VELOCITY := 100.0
const JUMP_VELOCITY := -300.0
const JUMP_DECELERATION := 700.0

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation
@onready var first_attack_colldawn: Timer = $FirstAttackColldawn
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var idle_speed := 1.0
@export var walk_speed := 1.0
@export var jump_speed := 1.0

var can_attack := true
var is_attacking := false
var attack_combo := false
var active_state := STATE.FALL

func _ready() -> void:
	switch_state(active_state)

func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()
	
	## Adding infomration to DEBUG OVERLAY
	#DebugOverlay.add_stat("Player", "State:", active_state)
	#DebugOverlay.add_stat("Player", "Animation", animation_player.animation)
	#DebugOverlay.add_stat("Player", "attack_combo", attack_combo)
	#DebugOverlay.add_stat("Player", "is_attacking", is_attacking)
	#DebugOverlay.add_stat("Player", "can_attack", can_attack)
	#DebugOverlay.add_stat("Player", "AttackColldawn", first_attack_colldawn.time_left)
	#DebugOverlay.add_stat("Player", "Velocity X:", roundf(velocity.x))
	#DebugOverlay.add_stat("Player", "Velocity Y:", roundf(velocity.y))

func switch_state(to_state: STATE) -> void:
	active_state = to_state

	## State specific things that need to run only once upon entering the next state
	match active_state:
		STATE.FALL:
			if animation_player.current_animation != "Jump_Attack" and animation_player.current_animation != "Jump_Double_Attack":
				animation_player.play("Fall")
			
		STATE.JUMP:
			animation_player.play("Jump")
			velocity.y = JUMP_VELOCITY
			
func process_state(delta: float) -> void:
	match active_state:
		STATE.FALL:
			velocity.y = move_toward(velocity.y, FALL_VELOCITY, FALL_GRAVITY * delta)
			
			handle_attack()
			handle_movement()
			
			if is_on_floor():
				reset_attacks()
				switch_state(STATE.FLOOR)
			#elif Input.is_action_just_pressed("Jump"):
				#switch_state(STATE.JUMP)
			
		STATE.FLOOR:
			if not is_attacking:
				if Input.get_axis("Left", "Right"):
					animation_player.play("Walk")
				else:
					animation_player.play("Idle")
			elif not attack_combo:
				animation_player.play("Attack")
			
			handle_attack()
			handle_movement()
			
			if not is_on_floor():
				reset_attacks()
				switch_state(STATE.FALL)
			elif Input.is_action_just_pressed("Jump"):
				reset_attacks()
				switch_state(STATE.JUMP)
		
		STATE.JUMP:
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)
			
			handle_attack()
			handle_movement()

			if Input.is_action_just_released("Jump") or velocity.y >= 0:
				if velocity.y >= -100:
					velocity.y *= 0.5
				else:
					velocity.y *= 0.3
				switch_state(STATE.FALL)
				
func handle_movement() -> void:
	var input_direction := signf(Input.get_axis("Left", "Right"))
	if input_direction:
		player_animation.flip_h = input_direction > 0
	velocity.x = input_direction * WALK_VELOCITY

func handle_attack() -> void:
	if Input.is_action_just_pressed("Attack"):
		if can_attack and not attack_combo:
			if active_state == STATE.JUMP or active_state == STATE.FALL:
				animation_player.play("Jump_Attack")
				
			first_attack_colldawn.start()
			is_attacking = true
		elif is_attacking:
			attack_combo = true
			
		if not attack_combo:
			can_attack = false

func reset_attacks():
	is_attacking = false
	attack_combo = false
	can_attack = true

func _on_animation_finished(anim_name: String):
	if anim_name == "Jump":
		animation_player.play("Float")
		
	elif anim_name == "Attack":
		if attack_combo:
			animation_player.play("Double_Attack")
		else:
			reset_attacks()
			
	elif anim_name == "Double_Attack":
		reset_attacks()
		
	elif anim_name == "Jump_Attack":
		if attack_combo:
			animation_player.play("Jump_Double_Attack")
		else:
			reset_attacks()
			if active_state == STATE.FALL:
				animation_player.play("Fall")
			
	elif anim_name == "Jump_Double_Attack":
		reset_attacks()
		if active_state == STATE.FALL:
				animation_player.play("Fall")


func _on_first_attack_colldawn_timeout() -> void:
	can_attack = true
