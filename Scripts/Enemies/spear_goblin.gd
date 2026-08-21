extends CharacterBody2D
class_name SpearGoblin

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spear_spawn_point: Marker2D = $SpearSpawnPoint

@export var WALK_VELOCITY := 20.0
@export var GRAVITY := 10.0
@export var spear: PackedScene

var walk_velocity_shelf: float

func _ready() -> void:
	WALK_VELOCITY = randf_range(10.0, 25.0)
	walk_velocity_shelf = WALK_VELOCITY
	
	animation_player.play("Walk_Spear")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY
		
	velocity.x = -WALK_VELOCITY 
	
	if Input.is_action_just_released("DebugEnemy"):
		throw_spear()
	
	move_and_slide()


func throw_spear():
	if spear == null:
		print("Error! | Spear is not pinned in the editor!")
		return
	
	animation_player.play("Throw")

func create_spear():
	var new_spear = spear.instantiate()
	new_spear.X_0 = spear_spawn_point.global_position.x
	new_spear.Y_0 = spear_spawn_point.global_position.y

	new_spear.global_position = spear_spawn_point.global_position
	get_tree().current_scene.add_child(new_spear)

func walk_velocity_back():
	WALK_VELOCITY = walk_velocity_shelf

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Throw":
		animation_player.play("Walk")
