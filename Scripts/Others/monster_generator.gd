extends Area2D

######################################### Signals #########################################

signal wave_ended()

######################################### Variables #########################################

## Onready variables
@onready var spawn_colldawn: Timer = $SpawnColldawn
@onready var floor_spawn_position: CollisionShape2D = $FloorSpawnPosition
@onready var sky_spawn_position: CollisionShape2D = $SkySpawnPosition

## Export variables
@export var spear_goblin: PackedScene
@export var bat: PackedScene
@export var slime: PackedScene

## Normal variables
var wave := 1
var enemies_alive := 0
var wave_enemies: Dictionary[PackedScene, int]


######################################### Main functions #########################################

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_enemies = {spear_goblin: 30}
	spawn_colldawn.start()
	count_enemies()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func handle_waves():
	#if wave 

## Spawn Monster
func spawn_monster():
	# if all enemies are spawned return
	if wave_enemies.is_empty():
		return
	
	# pick random monster from enemies attached to current wave
	var random_monster = wave_enemies.keys().pick_random()
	var new_monster
	
	wave_enemies[random_monster] -= 1
	
	# if all entitites of one enemy of current wave are spawned delete this type of enemy from dictionary
	if wave_enemies[random_monster] <= 0:
		wave_enemies.erase(random_monster)
	
	# Create new instantiate of enemy
	new_monster = random_monster.instantiate()
	
	# Conncet enemy_died signal from hurtbox.gd of current instantiated enemy
	new_monster.get_child(2).enemy_died.connect(_on_enemy_died)
	
	if random_monster == spear_goblin:
		new_monster.global_position = floor_spawn_position.global_position
		get_tree().current_scene.add_child(new_monster)
		
	elif random_monster == bat:
		var edge_positions = get_edge_positions()
		var random_position_y = randf_range(edge_positions["top"], edge_positions["bottom"])

		new_monster.global_position = Vector2(sky_spawn_position.global_position.x, random_position_y)
		get_tree().current_scene.add_child(new_monster)
		
	elif random_monster == slime:
		new_monster.global_position = floor_spawn_position.global_position
		get_tree().current_scene.add_child(new_monster)

######################################### Other functions #########################################

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

## Count Enemies: counting all enemies
func count_enemies():
	for num_of_enemy in wave_enemies.values():
		enemies_alive += num_of_enemy

######################################### Signal functions #########################################

## Timer Signal function: Emitted when the timer reaches the end
func _on_spawn_colldawn_timeout() -> void:
	spawn_monster()
	
	# Shuffle spawn time of next enemy
	spawn_colldawn.wait_time = randf_range(1.0, 2.0)

## Emitted when the enemy dies
func _on_enemy_died() -> void:
	enemies_alive -= 1
	
	# if all enemies are killed emit wave_ended signal
	if enemies_alive <= 0:
		wave_ended.emit()

## Emitted when the wave ends
func _on_wave_ended() -> void:
	wave += 1
	UI.change_wave_number(wave)
	wave_enemies = {slime: 10, bat: 10, spear_goblin: 10}
	count_enemies()
