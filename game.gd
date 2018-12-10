extends Node2D

# class member variables go here, for example:
onready var turretScene = preload("res://turret.tscn")
onready var monsterScene = preload("res://monster.tscn")
var waves = Dictionary()
var last_wave = 0
var active_wave = -1
var current_monster = 0

func _ready():
	# Initialization here
	var redTurret = turretScene.instance()
	redTurret.setColor(Color(120,0,120))
	redTurret.set_position(Vector2(300,75))
	add_child(redTurret)
	# Define waves - do this somewhere else and some other way in the future, so it is tied to the level, not the game
	# and to allow set details on the individual monsters, like rgb values
	self.waves[0] = ["horny"]
	self.waves[1] = ["horny","horny","horny"]
	self.waves[2] = ["horny","horny","horny","horny","horny","horny","horny","horny","horny"]
	self.waves[3] = ["horny","horny","horny","horny","horny","horny","horny","horny","horny","horny","horny","horny","horny","horny","horny","horny"]
	# Start waves
	$WaveTimer.set_wait_time(1.5)
	$WaveTimer.start()

func _process(delta):
	pass

func _on_WaveTimer_timeout():
	# Make sure a wave is always active
	if self.active_wave == -1 and self.last_wave +1 <= self.waves.size():
		self.last_wave += 1
		self.active_wave = self.last_wave
	# Spawn monsters
	var new_monster = monsterScene.instance()
	new_monster.set_type(self.waves[active_wave][self.current_monster])
	new_monster.set_position(Vector2($LevelBackdrop/SpawnStart.get_global_transform().get_origin()))
	new_monster.set_speed(100)
	add_child(new_monster)
	new_monster.move_to($LevelBackdrop/PathFinish.get_global_transform().get_origin())
	self.current_monster += 1
	if self.current_monster >= self.waves[active_wave].size():
		self.current_monster = 0
		self.active_wave = -1
