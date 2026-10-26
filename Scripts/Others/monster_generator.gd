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
var wave_id := 1
var enemies_alive := 0
var wave_schedule: Dictionary
var wave_enemies: Dictionary


######################################### Main functions #########################################

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_schedule = load_data_from_json("res://Assets/Waves/waves_schedule.json")
	transform_data_from_json()
	wave_enemies = wave_schedule[str(wave_id)]
	spawn_colldawn.start()
	count_enemies(wave_id)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Spawn Monster
func spawn_monster():
	# if all enemies are spawned return
	if wave_enemies.is_empty():
		return
	
	# pick random monster from enemies attached to current wave
	var random_monster = wave_enemies.keys().pick_random()
	var new_monster
	
	#while wave_enemies[random_monster] <= 0:
		#random_monster = wave_enemies.keys().pick_random()
		#if wave_enemies[random_monster] <= 0:
			#wave_enemies.erase(random_monster)
	
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
func count_enemies(wave_id):
	for num_of_enemy in wave_schedule[str(wave_id)].values():
		enemies_alive += num_of_enemy

## Load Data From JSON: loading JSON file
func load_data_from_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		print("File does not exist:", path)
		return {}
		
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Error! with open a file:", FileAccess.get_open_error())
		return {}
	
	var json_string = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(json_string)

	if data is Dictionary:
		return data
	else:
		print("Error! Bad file formatting as JSON.")
		return {}

## Transform Data From JSON: Transofrming some of strings in dictionary to packed scene monsters
func transform_data_from_json():
	# Dictionary to map name to scene in wave_schedule
	var name_to_scene = {
		"slime": slime,
		"bat": bat,
		"spear_goblin": spear_goblin
	}
	
	for wave in wave_schedule:
		var old_dict = wave_schedule[wave]
		var new_dict = {}
		
		for key in old_dict.keys():
			if key in name_to_scene.keys():
				var packed_scene = name_to_scene[key]
				var amount = old_dict[key]
				if amount == 0:
					continue
				new_dict[packed_scene] = amount
		
		wave_schedule[wave] = new_dict

# Przykład użycia:
# var loaded_data = load_data_from_file("user://savegame.json")

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
	wave_id += 1
	UI.change_wave_number(wave_id)
	wave_enemies = wave_schedule[str(wave_id)]
	count_enemies(wave_id)
