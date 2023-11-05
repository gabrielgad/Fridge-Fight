extends CharacterBody3D

@onready var camera = $SpringArmPivot/SpringArm3D/Camera
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm_3d = $SpringArmPivot/SpringArm3D
@onready var rogue_hooded = $Rogue_Hooded
@onready var animation_tree = $Rogue_Hooded/AnimationTree

var target_distance: float = 70
@export var MAX_SPEED = 20
<<<<<<< HEAD
@export var ACCELERATION = 150
@export var FRICTION = 80
=======
@export var ACCELERATION = 120
@export var FRICTION = 115
>>>>>>> 0ccc804db4a4883a8ef446c0424bb2828b96455a
@onready var axis = Vector3.ZERO
var rayOrigion = Vector3()
var rayEnd = Vector3()


const LERP_VAL = 0.8



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	

func _unhandled_input(event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()


func _process(delta):
	move(delta)
#	animation_tree.set("parameters/Movement/blend_position", axis)
	looker()



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

func looker():
	var player_pos = global_transform.origin
	var dropPlane = Plane(Vector3(0, 1, 0), player_pos.y)
	
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from, to)
	
	look_at(cursor_pos, Vector3.UP)

