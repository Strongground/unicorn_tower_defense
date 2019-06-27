extends Node2D

# class member variables go here, for example:
export(Color) var color = Color(120,0,0)
export(int) var firing_range = 100
var current_targets = {}
onready var bulletScene = preload("res://bullet.tscn")
onready var root = get_node("/root")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_color(self.color)

func _process(delta):
	# Called every tick
	pass

func set_color(color):
	$turret/turret_color.set_modulate(color)

func _shoot(target):
	var bullet = bulletScene.instance()
	var start_coordinates = $turret/turret_color.get_global_transform().get_origin()
	var target_coordinates = target.get_global_transform().get_origin()
	bullet.damage = self.color
	bullet.parent = self
	bullet.shoot(start_coordinates, target_coordinates)
	root.add_child(bullet)

func _input(event):
	pass

func _on_shoot_range_body_entered(body):
	if body.get_parent().is_in_group("enemy"):
		self.current_targets[body.get_name()] = body

func _on_range_body_exited(body):
	if body.get_parent().is_in_group("enemy"):
		self.current_targets.erase(body.get_name())

func is_valid_target(monster):
	if (self.color.r > 0 and monster.health.r > 0) or (self.color.g > 0 and monster.health.g > 0) or (self.color.b > 0 and monster.health.b > 0):
		return true
	return false

func _on_shot_countdown_timeout():
	if current_targets.size() > 0:
		for monster_id in current_targets:
			if is_valid_target(current_targets[monster_id].get_parent()):
				_shoot(current_targets[monster_id].get_parent())
