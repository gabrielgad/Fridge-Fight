extends AnimationTree

@onready var rogue_hooded = $"../Rogue_Hooded"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Input.is_action_pressed("Forward"):
		AnimationTree.set("parameter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
