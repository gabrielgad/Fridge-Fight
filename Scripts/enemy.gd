extends CharacterBody3D

@onready var animation_tree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../Player"

@export var player_path : NodePath

const SPEED = 6.0
const ATTACK_RANGE = 2.5
var state_machine

func _ready():
	player = get_node(player_path)
	state_machine = animation_tree.get("parameters/playback")
	

func _process(_delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Running":
#			navigation to player
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(global_position.x + velocity.x, global_position.y + velocity.y, 
							global_position.z + velocity.z), Vector3.UP)
		"Attacking":
			#looking at player
			look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z), Vector3.UP)

	move_and_slide()
	
#	Conditions
	animation_tree.set("parameters/conditions/attacking", _target_in_range())
	animation_tree.set("parameters/conditions/running", !_target_in_range())
	
	animation_tree.get("parameters/playback")
	

func _target_in_range():
	if animation_tree.get("parameters/conditions/attacking"):
		return global_position.distance_to(player.global_position) < 2.5 * ATTACK_RANGE
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
