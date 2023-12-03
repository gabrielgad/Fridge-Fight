extends Node3D


@onready var spawned_enemies = $SpawnedEnemies
@onready var enemy = $"../Enemy"
@onready var spawn_location = $Player/FOV/SpawnPath/SpawnLocation

func _ready():
	pass


func _process(delta):
	pass

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	enemy.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var spawn_location
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
