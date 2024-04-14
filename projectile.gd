extends TextureRect

var speed = 1
var type = 1
var damage = 20
var target
var t = 0
var originPoint = Vector2(930, 300)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func build(newDamage, newSpeed, newType):
	damage = newDamage
	speed = newSpeed
	type = newType
	match type:
		1:
			texture = load("res://Textures/Projectiles/IceProj.png")
		2:
			texture = load("res://Textures/Projectiles/WaterProj.png")
		3:
			texture = load("res://Textures/Projectiles/FireProj.png")
			damage *= 1.25
		4:
			texture = load("res://Textures/Projectiles/MagicProj.png")
			damage *= 1.25
		5:
			texture = load("res://Textures/Projectiles/DarknessProj.png")
			damage *= 1.25
			
	var rng = RandomNumberGenerator.new()
	var randX = rng.randi_range(-20, 20)
	var randY = rng.randi_range(-20, 20)
	var newStart = Vector2(originPoint.x + randX, originPoint.y + randY)
	originPoint = newStart
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.round_in_progress && find_parent("Table").enemiesAlive:
		t += delta * speed / 5
		target = find_parent("Table").find_child("Path2D").get_child(0).global_position
		global_position = originPoint.lerp(target, t)
	else:
		self.queue_free()
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().takeDamage(damage, type)
		self.queue_free()
	pass # Replace with function body.
