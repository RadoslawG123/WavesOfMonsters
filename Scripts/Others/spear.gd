extends Area2D


##### Variables #####

## Onready variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spear: Area2D = $"."

## Normal variables
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

## Ready: Called when the node enters the scene tree for the first time.
func _ready() -> void:
	throw_force = randf_range(190.0, 200.0)
	throw_angle = randf_range(10.0, 45.0)
	V_0x = -throw_force * cos(deg_to_rad(throw_angle))
	V_0y = throw_force * sin(deg_to_rad(throw_angle))


## _Physics_process: Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if freeze:
		return
	t += delta
	
	## Calcualte flight path basend on physical equation (global_position = ...)
	# Parameters:
	# X_0, Y_0 - Starting position
	# V_0x, V_0y - Starting velocity (for X and Y axis)
	# t - actual flight time
	# my_gravity - the force of gravity (to down)
	global_position = Vector2((X_0 + (V_0x * t)), Y_0 - (V_0y * t) + (0.5 * my_gravity * (t**2)))
	
	
	# Calculate actual velocity in this split second
	# Vertically: (gravitation pulls down)- (upward throw force)
	var current_velocity_y = (my_gravity * t) - V_0y
	var current_velocity = Vector2(-V_0x, -current_velocity_y)
	
	# Rotate spear in direction of its flight
	rotation = current_velocity.angle()

## Change Flight Path
func change_flight_path():
	X_0 = global_position.x
	Y_0 = global_position.y
	V_0x = throw_force * cos(deg_to_rad(throw_angle))
	t = 0


##### Signal functions #####

## Signal funciton: Spear hits the ground
func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		freeze = true
		spear.remove_from_group("Enemy")
		animation_player.play("Disappear")

## Signal function: Player hits the spear by his weapon hitbox to reflect it
func _on_player_hitbox_entered(area: Area2D) -> void:
	# If area is hitbox and hitbox have right direction
	if area.is_in_group("Hitbox") and area.scale.x == -1:
		change_flight_path()
		
