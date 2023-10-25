extends CharacterBody3D


@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm_3d = $SpringArmPivot/SpringArm3D
@onready var rogue_hooded = $Rogue_Hooded
@onready var animation_tree = $AnimationTree


@export var MAX_SPEED = 20
@export var ACCELERATION = 100
@export var FRICTION = 80
@onready var axis = Vector3.ZERO

const LERP_VAL = .05
#var currentinput :  Vector2
#var currentvelocity : Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm_3d.rotate_x(-event.relative.y * .005)
		spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x, -PI/4, PI/4)

func _process(delta):
	move(delta)
	animation_tree.set("parameters/Move_Blend/blend_position", axis)

func get_input_axis():
	axis.x = Input.get_axis("Left", "Right")
	axis.z = Input.get_axis("Forward", "Back")
	axis = axis.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	return axis.normalized()
	

func move(delta):
	axis = get_input_axis()
	
	if axis == Vector3.ZERO:
		apply_fricition(FRICTION * delta)
		
	else:
		apply_movement(axis * ACCELERATION * delta)

	move_and_slide()


func apply_fricition(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	
	else:
		velocity = Vector3.ZERO

func apply_movement(accel):
	velocity += accel
	velocity = lerp(velocity, velocity.limit_length(MAX_SPEED), LERP_VAL)
	rogue_hooded.rotation.y = lerp_angle(rogue_hooded.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
