extends Node2D
var damage = Color(0,0,0)
var vel = 150.0
var parent = null
signal hit(body, damage)

func _ready():
	set_color(damage)
	$bullet_life_time.set_wait_time(self.parent.get("firing_range")/25)
	self.set_contact_monitor(true)
	self.set_max_contacts_reported(1)

func _fixed_process(delta):
	pass

func shoot(start, target):
	var x = (target - start).normalized()
	var y = Vector2(x.y, -x.x)
	set_transform(Transform2D(x,y,start))
	set_linear_velocity(x*vel)
    
func destroy():
	#play explosion animation and sound
	queue_free()
	
func set_color(color):
	$bullet_color.set_modulate(color)
    
func _on_Timer_timeout():
	#Destroy after short time in case it never hits anything
	destroy()

# If a monster is hit by this bullet
func _on_bullet_body_entered(body):
	if body.get_parent().is_in_group("enemy"):
		# Since neither emitting nor receiving signals seems to work, fall back
		# to manually calling the monsters _got_hit function.
		# self.emit_signal("hit", body.get_parent(), self.damage)
		body.get_parent()._got_hit(self.damage)
		destroy()
