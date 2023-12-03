extends Node

@onready var enemy_scene = preload("res://Scenes/Enemy.tscn")
@onready var spawned_enemies = $EnemySpawner

func _ready():
	pass # Replace with function body.



func _physics_process(_delta):
	pass
	

func spawn_enemy(_delta):
	
	var enemy = enemy_scene.instantiate()
	spawned_enemies.add_child(enemy)
	


func _on_timer_timeout():
	pass # Replace with function body.
