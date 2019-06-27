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
	pass
#	for monster in get_tree().get_nodes_in_group("enemy"):
#		print("checking "+str(monster.get_node("body")))
#		if $shoot_range.overlaps_body(monster.get_node("body")):
#			print("Monster "+str(monster)+" is in range!")
	#_shoot()

func setColor(c):
	color = c
	$turret/turret_color.set_modulate(color)

#func _shoot():
#	var bullet = bulletScene.instance()
#	var start = self.get_position()
#	var goal = $"/root/game/Monster".get_position()
#	bullet.shoot(start, goal)
#	root.add_child(bullet)

func _input(event):
	pass

func _on_shoot_range_area_entered(area):
	print("area entered")


func _on_shoot_range_area_shape_entered(area_id, area, area_shape, self_shape):
	print("area_shape_entered")


func _on_shoot_range_body_entered(body):
	print("body entered")


func _on_shoot_range_body_shape_entered(body_id, body, body_shape, area_shape):
	print("body shape entered")
