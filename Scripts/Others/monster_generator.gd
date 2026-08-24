extends Area2D


##### Variables #####

## Onready variables
@onready var spawn_colldawn: Timer = $SpawnColldawn
@onready var floor_spawn_position: CollisionShape2D = $FloorSpawnPosition
@onready var sky_spawn_position: CollisionShape2D = $SkySpawnPosition

## Export variables
@export var spear_goblin: PackedScene
@export var bat: PackedScene


##### Main functions #####

## Spawn Monster
func spawn_monster():
	var random_monster = [spear_goblin, bat].pick_random()
	var new_monster
	
	if random_monster == spear_goblin:
		new_monster = spear_goblin.instantiate()

		new_monster.global_position = floor_spawn_position.global_position
		get_tree().current_scene.add_child(new_monster)
	elif random_monster == bat:
		new_monster = bat.instantiate()
		
		var edge_positions = get_edge_positions()
		var random_position_y = randf_range(edge_positions["top"], edge_positions["bottom"])

		new_monster.global_position = Vector2(sky_spawn_position.global_position.x, random_position_y)
		get_tree().current_scene.add_child(new_monster)

## Get Edge Positions: sky spawn global edges positions
func get_edge_positions():
	var edge_positions = {}
	var rect_shape = sky_spawn_position.shape as RectangleShape2D
	
	if rect_shape:
		edge_positions["left"] = sky_spawn_position.global_position.x - rect_shape.extents.x
		edge_positions["right"] = sky_spawn_position.global_position.x + rect_shape.extents.x
		edge_positions["top"] = sky_spawn_position.global_position.y - rect_shape.extents.y
		edge_positions["bottom"] = sky_spawn_position.global_position.y + rect_shape.extents.y
		
	return edge_positions

## Timer Signal function: Emitted when the timer reaches the end
func _on_spawn_colldawn_timeout() -> void:
	spawn_monster()
