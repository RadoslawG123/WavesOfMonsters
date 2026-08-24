extends CanvasLayer


##### Simple debug overlay generated from gemini #####

# Dictonary for all data
var debug_data: Dictionary = {}

# UI
var panel_container: PanelContainer
var label: Label

func _ready() -> void:
	layer = 128
	
	# Creating black container with opacity
	panel_container = PanelContainer.new()
	panel_container.modulate = Color(0, 0, 0, 0.9)
	panel_container.position = Vector2(10, 10) # Margines od lewego górnego rogu
	add_child(panel_container)
	
	# Creating text
	label = Label.new()
	panel_container.add_child(label)
	
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DebugOverlay"):
		if not visible:
			visible = true
		else:
			visible = false
	
	if not visible:
		debug_data.clear()
		return
	
	# Building text every frame
	var display_text = ""
	
	for category in debug_data:
		display_text += "[ " + category + " ]\n"
		
		for key in debug_data[category]:
			display_text += str(key) + ": " + str(debug_data[category][key]) + "\n"
			
		display_text += "\n"
		
	label.text = display_text
	
	# Optional: Clearing data every frame (example: if monster die, statistics also dissapear)
	#debug_data.clear()

# Function to run other scripts
func add_stat(category: String, key: String, value: Variant) -> void:
	if not visible:
		return
	
	if not debug_data.has(category):
		debug_data[category] = {}
		
	debug_data[category][key] = value
