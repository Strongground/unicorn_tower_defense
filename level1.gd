extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var turretScene = preload("res://turret.tscn")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var redTurret = turretScene.instance()
	redTurret.setColor(Color(120,0,120))
	redTurret.set_position(Vector2(300,100))
	add_child(redTurret)
	# Monster initial movement
	for monster in get_tree().get_nodes_in_group("enemy"):
		monster.move_to($LevelBackdrop/PathFinish.get_global_transform().get_origin())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
