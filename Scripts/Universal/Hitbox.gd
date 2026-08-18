extends Area2D
class_name Hitbox

@onready var hitbox_1: Area2D = %Hitbox1
@onready var hitbox_2: Area2D = %Hitbox2

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation

var input_direction := 1.0

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	input_direction = signf(Input.get_axis("Left", "Right"))
	hitbox_on()
	
	DebugOverlay.add_stat("Hitbox", "input_direction: ", input_direction)
	DebugOverlay.add_stat("Hitbox", "player_animation.animation: ", player_animation.animation)
	DebugOverlay.add_stat("Hitbox", "player_animation.frame: ", player_animation.frame)
	DebugOverlay.add_stat("Hitbox", "hitbox_1.monitorable: ", hitbox_1.monitorable)
	DebugOverlay.add_stat("Hitbox", "hitbox_2.monitorable: ", hitbox_2.monitorable)
	

func hitbox_on() -> void:
	if player_animation.animation in ["Attack", "Jump_Attack"] and player_animation.frame == 2:
		hitbox_1.monitorable = true
	elif player_animation.animation in ["Double_Attack", "Jump_Double_Attack"] and player_animation.frame == 0:
		hitbox_2.monitorable = true

func _on_animation_finished() -> void:
	if player_animation.animation in ["Attack", "Jump_Attack"]:
		hitbox_1.monitorable = false
	elif player_animation.animation in ["Double_Attack", "Jump_Double_Attack"]:
		hitbox_2.monitorable = false


#func _on_player_animation_changed() -> void:
	#if player_animation.animation in ["Attack", "Jump_Attack"]:
		#hitbox_1.monitorable = false
	#elif player_animation.animation in ["Double_Attack", "Jump_Double_Attack"]:
		#hitbox_2.monitorable = false
