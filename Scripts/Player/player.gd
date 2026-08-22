extends CharacterBody2D
class_name Player


##### Variables #####

## OnReady variables
@onready var player_animation: AnimatedSprite2D = %PlayerAnimation
@onready var first_attack_colldawn: Timer = $FirstAttackColldawn
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox_1: Area2D = $Hitbox1
@onready var hitbox_2: Area2D = $Hitbox2

## States
enum STATE {
	FALL,
	FLOOR,
	JUMP,
}

## Constrants
const FALL_GRAVITY := 500.0
const FALL_VELOCITY := 200.0
const WALK_VELOCITY := 100.0
const JUMP_VELOCITY := -300.0
const JUMP_DECELERATION := 700.0

## Normal variables
var can_attack := true
var is_attacking := false
var attack_combo := false
var active_state := STATE.FALL


##### Main functions #####

## Ready: Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_state(active_state)

## Physics Process: Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()

## Swich State: Swiching states
func switch_state(to_state: STATE) -> void:
	active_state = to_state

	# State specific things that need to run only once upon entering the next state
	match active_state:
		STATE.FALL:
			if animation_player.current_animation != "Jump_Attack" and animation_player.current_animation != "Jump_Double_Attack":
				animation_player.play("Fall")
			
		STATE.JUMP:
			animation_player.play("Jump")
			velocity.y = JUMP_VELOCITY
			
## Process State: Main functionalities of the states
func process_state(delta: float) -> void:
	match active_state:
		STATE.FALL:
			# Smooth fall
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
			# Smooth jump
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)
			
			handle_attack()
			handle_movement()

			# Smooth shorter jump by releasing 'Jump' key on keyboard
			if Input.is_action_just_released("Jump") or velocity.y >= 0:
				if velocity.y >= -100:
					velocity.y *= 0.5
				else:
					velocity.y *= 0.3
				switch_state(STATE.FALL)


##### Other functions #####

## Handle Movement
func handle_movement() -> void:
	var input_direction := signf(Input.get_axis("Left", "Right"))
	
	if input_direction:
		player_animation.flip_h = input_direction > 0
		
		# Turn hitboxes to player direction
		hitbox_1.scale.x = -input_direction
		hitbox_2.scale.x = -input_direction
	
	velocity.x = input_direction * WALK_VELOCITY

## Handle Attack
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

## Deal Damage
func deal_damage():
	var overlapping_areas: Array[Area2D]
	
	# Get all areas that touch the hitbox1
	if animation_player.current_animation == "Attack" or animation_player.current_animation == "Jump_Attack":
		overlapping_areas = hitbox_1.get_overlapping_areas()
	# Get all areas that touch the hitbox2
	elif animation_player.current_animation == "Double_Attack" or animation_player.current_animation == "Jump_Double_Attack":
		overlapping_areas = hitbox_2.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("Hurtbox"):
			area.get_hit()

## Reset Attacks
func reset_attacks():
	is_attacking = false
	attack_combo = false
	can_attack = true

## When animations finishes do something
func _on_animation_finished(anim_name: String):
	# Merging 'Jump' animation with 'Float' animation by follow
	if anim_name == "Jump":
		animation_player.play("Float")
	
	# 'Attack' animation finishes
	elif anim_name == "Attack":
		if attack_combo:
			animation_player.play("Double_Attack")
		else:
			reset_attacks()
	
	# 'Double_Attack' animation finishes
	elif anim_name == "Double_Attack":
		reset_attacks()
	
	# 'Jump_Attack' animation finishes
	elif anim_name == "Jump_Attack":
		if attack_combo:
			animation_player.play("Jump_Double_Attack")
		else:
			reset_attacks()
			if active_state == STATE.FALL:
				animation_player.play("Fall")
	
	# 'Jump_Double_Attack' animation finishes
	elif anim_name == "Jump_Double_Attack":
		reset_attacks()
		if active_state == STATE.FALL:
				animation_player.play("Fall")

## When colldawn timer reaches the end do something
func _on_first_attack_colldawn_timeout() -> void:
	can_attack = true
