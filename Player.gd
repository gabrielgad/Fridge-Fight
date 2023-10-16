extends CharacterBody3D

const SPEED = 8
const JUMP_VELOCITY = 6

var _velocity := Vector3.ZERO


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("Left") - Input.get_action_strength("Right")
	move_direction.z = Input.get_action_strength("Forward") - Input.get_action_strength("Back")
	
	_velocity.x = move_direction.x * SPEED
	_velocity.z = move_direction.z * SPEED
