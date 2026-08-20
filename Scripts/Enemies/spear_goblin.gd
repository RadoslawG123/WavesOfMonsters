extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spear_spawn_point: Marker2D = $SpearSpawnPoint

@export var WALK_VELOCITY := 20.0
@export var spear: PackedScene

func _ready() -> void:
	animation_player.play("Walk_Spear")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity.x = -WALK_VELOCITY 
	
	if Input.is_action_just_released("DebugEnemy"):
		throw_spear()
	
	# DebugOverlay
	DebugOverlay.add_stat("Goblin", "velocity X: ", velocity.x)
	
	move_and_slide()


func throw_spear():
	if spear == null:
		print("Error! | Spear is not pinned in the editor!")
		return
	
	animation_player.play("Throw")

func create_spear():
	var new_spear = spear.instantiate()
	
	new_spear.global_position = spear_spawn_point.global_position
	get_tree().current_scene.add_child(new_spear)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Throw":
		animation_player.play("Walk")
