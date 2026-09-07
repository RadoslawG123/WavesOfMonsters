extends CanvasLayer


##### Simple debug overlay generated from gemini #####

# Dictonary for all data
var debug_data: Dictionary = {}

# UI
var panel_container: PanelContainer
var label: Label

func _ready() -> void:
	layer = 128
	
	# 1. Tworzymy kontener
	panel_container = PanelContainer.new()
	panel_container.position = Vector2(2, 2)
	
	# Tworzymy niestandardowy wygląd tła (StyleBox), żeby zmniejszyć marginesy
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.6) # Czarny, półprzezroczysty
	# Ekstremalnie małe marginesy (domyślnie Godot daje tu dużo pustej przestrzeni)
	style.content_margin_left = 4
	style.content_margin_right = 4
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	
	panel_container.add_theme_stylebox_override("panel", style)
	add_child(panel_container)
	
	# 2. Tworzymy tekst
	label = Label.new()
	# Nadpisujemy rozmiar czcionki na bardzo mały (idealny do pixel artu)
	label.add_theme_font_size_override("font_size", 10) 
	# Zmniejszamy odstępy między linijkami
	label.add_theme_constant_override("line_spacing", 0) 
	
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
