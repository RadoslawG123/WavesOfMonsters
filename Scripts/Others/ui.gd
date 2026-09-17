extends CanvasLayer

@onready var hearts_container: HBoxContainer = %HeartsContainer

var heart_cursor = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_player_health():
	if not is_node_ready():
		await ready
	
	if heart_cursor >= -4:
		var heart = hearts_container.get_child(heart_cursor)
		heart.visible = false
		heart_cursor -= 1
