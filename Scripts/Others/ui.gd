extends CanvasLayer

######################################### Variables #########################################

## Onready variables
@onready var player_hearts_container: HBoxContainer = %PlayerHeartsContainer
@onready var village_hearts_container: HBoxContainer = %VillageHeartsContainer
@onready var wave_counter_label: RichTextLabel = %WaveCounterLabel

## Normal variables
var player_heart_cursor = -1
var village_heart_cursor = -1
var wave: int 


######################################### Main functions #########################################

## READY: Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave = get_tree().get_first_node_in_group("MonsterGenerator").wave


## PROCESS: Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


######################################### Other functions #########################################

## Changes player's health
func change_player_health():
	if not is_node_ready():
		await ready
	
	if player_heart_cursor >= -4:
		var heart = player_hearts_container.get_child(player_heart_cursor)
		heart.visible = false
		player_heart_cursor -= 1

## Changes village's health
func change_village_health():
	if not is_node_ready():
		await ready
		
	if village_heart_cursor >= -4:
		var heart = village_hearts_container.get_child(village_heart_cursor)
		heart.visible = false
		village_heart_cursor -= 1

## Changes wave number
func change_wave_number(wave):
	if not is_node_ready():
		await ready
	
	wave_counter_label.text = "[center][b]WAVE " + str(wave)
	
