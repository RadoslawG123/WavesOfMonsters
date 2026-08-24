extends CharacterBody2D
class_name SpearGoblin


##### Variables #####

## Onready variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spear_spawn_point: Marker2D = $SpearSpawnPoint
@onready var throw_timer: Timer = $ThrowTimer

## Export variables
@export var WALK_VELOCITY := 20.0
@export var GRAVITY := 10.0
@export var spear: PackedScene

## Normal variables
var walk_velocity_shelf: float


##### Main functions #####

## Ready: Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WALK_VELOCITY = randf_range(10.0, 25.0)
	throw_timer.wait_time = randf_range(5.0, 10.0)
	walk_velocity_shelf = WALK_VELOCITY
	
	throw_timer.start()
	animation_player.play("Walk_Spear")

## _Physics_process: Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY
		
	velocity.x = -WALK_VELOCITY 
	move_and_slide()


##### Other functions #####

## Throw Spear: play animation
func throw_spear():
	if spear == null:
		print("Error! | Spear is not pinned in the editor!")
		return
	
	animation_player.play("Throw")

## Create Spear
func create_spear():
	var new_spear = spear.instantiate()
	new_spear.X_0 = spear_spawn_point.global_position.x
	new_spear.Y_0 = spear_spawn_point.global_position.y

	new_spear.global_position = spear_spawn_point.global_position
	get_tree().current_scene.add_child(new_spear)

## Walk Velocity Back: Save goblins velocity to restore it further after spear throw
func walk_velocity_back():
	WALK_VELOCITY = walk_velocity_shelf


##### Signal functions #####

## Signal Function: If animation (anim_name) finish do something
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Throw":
		animation_player.play("Walk")

## Timer Signal Function
func _on_throw_timer_timeout() -> void:
	throw_spear()
