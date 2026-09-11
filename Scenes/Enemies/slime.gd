extends CharacterBody2D

#@export var h: float
#@export var d: float
#@export var g := 50.0
#
#var V_0y = -sqrt(2*g*h)
#var V_x_max = -d/(2*t_max)
#var t_max = sqrt((2*h)/g)
var t: float
var y: float
var jump_end: float
var test: float

var X_VELOCITY := 0.0
var JUMP_VELOCITY := 0.0
var jumping := -1.0
var jump_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	t = self.global_position.x
	test = t
	y = self.global_position.y
	jump_end = t - 50.0
	#h = 60.0
	#d = 120.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	DebugOverlay.add_stat("Slime", "test:", test)
	DebugOverlay.add_stat("Slime", "t:", t)
	DebugOverlay.add_stat("Slime", "global_position.y :", global_position.y)
	DebugOverlay.add_stat("Slime", "global_position.x:", global_position.x)
	if Input.is_action_just_pressed("DebugEnemy"):
		jumping *= -1.0
	if jumping == 1.0:
		if t > jump_end:
			t -= delta*60.0
			global_position.y = y + 50.0*sin(t*0.05+50.0)
			global_position.x = t
		
	#if Input.is_action_just_pressed("DebugEnemy"):
		#
		#jump_tween = create_tween()
		#jump_tween.set_parallel(true)
		#
		#X_VELOCITY = 100.0
		#JUMP_VELOCITY = 100.0
		#
		#jump_tween.tween_property(self, "JUMP_VELOCITY", 0.0, 0.5)
		#jump_tween.tween_property(self, "X_VELOCITY", 0.0, 0.5)
		#
		#jump_tween.finished.connect(_on_jump_ended)
		#
	#velocity.x = -X_VELOCITY
	#velocity.y = -JUMP_VELOCITY
	#if not jumping:
		#velocity.x = -X_VELOCITY
	
	
	move_and_slide()

func jump():
	pass
	#jumping = true
	#velocity.y = V_0y
	#t = sqrt((2*h)/g)
	#velocity.y = -sqrt(2*g*h)
	#velocity.x = d/(2*t)

func _on_jump_ended():
	X_VELOCITY = 100.0
	JUMP_VELOCITY = -100.0
	
	jump_tween.tween_property(self, "X_VELOCITY", 0.0, 0.5)
	jump_tween.tween_property(self, "JUMP_VELOCITY", 0.0, 0.5)
	
	X_VELOCITY = 0.0
