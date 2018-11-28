extends Node2D

# class member variables go here, for example:
var color = Color(120,0,0)
onready var bulletScene = preload("res://bullet.tscn")
onready var root = get_node("/root")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	_shoot()
	pass

func setColor(c):
	color = c
	$turret/turret_color.set_modulate(color)
	
func _shoot():
	var bullet = bulletScene.instance()
	var start = self.get_position()
	var goal = $"/root/game/Monster".get_position()
	bullet.shoot(start, goal)
	root.add_child(bullet)
	
func _input(event):
	pass