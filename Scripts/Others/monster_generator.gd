extends Area2D

@onready var spawn_colldawn: Timer = $SpawnColldawn
@onready var floor_spawn_position: CollisionShape2D = $FloorSpawnPosition
@onready var sky_spawn_position: CollisionShape2D = $SkySpawnPosition

@export var spear_goblin: PackedScene
@export var bat: PackedScene

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func spawn_monster():
	var random_monster = [spear_goblin, bat].pick_random()
	var new_monster
	
	if random_monster == spear_goblin:
		new_monster = spear_goblin.instantiate()

		new_monster.global_position = floor_spawn_position.global_position
		get_tree().current_scene.add_child(new_monster)
	elif random_monster == bat:
		new_monster = bat.instantiate()
		
		new_monster.global_position = sky_spawn_position.global_position
		get_tree().current_scene.add_child(new_monster)

func _on_spawn_colldawn_timeout() -> void:
	spawn_monster()
