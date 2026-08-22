extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var X_0: float
var Y_0: float
var V_0x: float
var V_0y: float
var throw_force: float
var throw_angle: float
var t := 0.0
var my_gravity := 150.0
var freeze := false
var is_deflected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	throw_force = randf_range(190.0, 200.0)
	throw_angle = randf_range(10.0, 45.0)
	V_0x = -throw_force * cos(deg_to_rad(throw_angle))
	V_0y = throw_force * sin(deg_to_rad(throw_angle))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if freeze:
		return
	t += delta

	DebugOverlay.add_stat("Spear", "Position X:", X_0 + (V_0x * t))
	global_position = Vector2((X_0 + (V_0x * t)), Y_0 - (V_0y * t) + (0.5 * my_gravity * (t**2)))
	
	
	# 2. NOWOŚĆ: Obliczamy faktyczną prędkość w tej ułamku sekundy
	# W pionie: (grawitacja ciągnąca w dół) - (siła wyrzutu w górę)
	var current_velocity_y = (my_gravity * t) - V_0y
	var current_velocity = Vector2(-V_0x, -current_velocity_y)
	
	# 3. MAGIA: Obracamy dzidę dokładnie tam, gdzie aktualnie leci!
	rotation = current_velocity.angle()

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		freeze = true
		animation_player.play("Disappear")

func _on_player_hitbox_entered(area: Area2D) -> void:
	print("Kinda works?", area.name)
	
	# If area is hitbox and hitbox have right direction
	if area.is_in_group("Hitbox") and area.scale.x == -1:
		change_flight_path()
		

func change_flight_path():
	X_0 = global_position.x
	Y_0 = global_position.y
	V_0x = throw_force * cos(deg_to_rad(throw_angle))
	t = 0
