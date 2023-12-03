extends CharacterBody3D

@onready var camera = $Camera
@onready var rogue_hooded = $Rogue_Hooded
@onready var animation_tree = $AnimationTree
@onready var cursor = $Cursor


@export var MAX_SPEED = 100
@export var ACCELERATION = 50 
@export var GRAVITY = 80
@export var rotation_speed = 12.0
@export var mouse_sensitivity = 0.0015

var stateMachine


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	animation_tree.active = true
	stateMachine = animation_tree.get("parameters/playback")

func _unhandled_input(event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

func _physics_process(delta):
	look_at_cursor()
	move(delta)
	move_and_slide()
	

func _process(_delta):
	states()

func move(delta):
	var input = Input.get_vector("Left","Right","Forward","Back")
	var dir = Vector3(input.x, 0 , input.y)
	velocity = lerp(velocity, dir * MAX_SPEED, ACCELERATION * delta)
	velocity.normalized()
	

func look_at_cursor():
#	Create a horizontal plane, and find a point where the ray intersects it
	var player_pos = global_transform.origin
	var dropPlane = Plane(Vector3(0, 0.1, 0), player_pos.y)
#	Project a ray from the camera, from where the mouse cursor is on a 2D view
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from, to)
#	Set the position of cursor visual
	cursor.global_transform.origin = cursor_pos + Vector3(0, 0.1, 0)
#	Player look at cursor
	rogue_hooded.look_at(cursor_pos, Vector3.UP)
	

func states():
	match stateMachine.get_current_node():
		"Motion":
			var vy = velocity.y
			var vl = velocity * rogue_hooded.transform.basis
			animation_tree.set("parameters/Motion/blend_position", Vector2(-vl.x, -vl.z) / -MAX_SPEED)
			velocity.y = vy

func auto_aim():
	pass
