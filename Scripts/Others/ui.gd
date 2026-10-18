extends CanvasLayer

@onready var player_hearts_container: HBoxContainer = %PlayerHeartsContainer
@onready var village_hearts_container: HBoxContainer = %VillageHeartsContainer
@onready var wave_counter_label: RichTextLabel = %WaveCounterLabel

var heart_cursor = -1
var wave: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave = get_tree().get_first_node_in_group("MonsterGenerator").wave


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_player_health():
	if not is_node_ready():
		await ready
	
	if heart_cursor >= -4:
		var heart = player_hearts_container.get_child(heart_cursor)
		heart.visible = false
		heart_cursor -= 1

func change_wave_number(wave):
	if not is_node_ready():
		await ready
	
	wave_counter_label.text = "[center][b]WAVE " + str(wave)
	
