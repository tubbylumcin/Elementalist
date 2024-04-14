extends PathFollow2D

var health = 100
var speed = 1
var damage = 1
#1 is normal, 2 is heavy, 3 is scout
var type = 1
#1 is ice, 2 is water, 3 is fire, 4 is magic, 5 is darkness
var element = 1
var slowness = 1

var t = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func build(newType, newElement):
	type = newType
	element = newElement
	var elementWord
	var typeWord
	match type:
		1:
			typeWord = "Normal"
		2:
			typeWord = "Heavy"
			speed = 0.75
			health = 150
			damage = 1.5
		3: 
			typeWord = "Scout"
			health = 50
			speed = 1.5
			damage = 0.75
	match element:
		1:
			elementWord = "Ice"
		2:
			elementWord = "Water"
			speed += 0.25
		3:
			elementWord = "Fire"
			damage += 0.5
		4:
			elementWord = "Magic"
			health += 25
		5:
			elementWord = "Darkness"
			health += 25
			damage += 0.5
	$TextureRect.texture = load("res://Textures/Enemies/" + elementWord + typeWord + ".png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta * slowness
	progress_ratio = (t / 20) * speed 
	if progress_ratio == 1:
		Global.health -= damage
		find_parent("Table").find_child("TakeDamage").play()
		self.queue_free()
	pass
	
	if health <= 0:
		match type:
			1:
				Global.energy += 50
			2:
				Global.energy += 75
			3:
				Global.energy += 40
		self.queue_free()

func takeDamage(damageAmount, damageType):
	var rng = RandomNumberGenerator.new()
	var hitSound = rng.randi_range(1, 2)
	$AudioStreamPlayer2D.stream = load("res://Audio/hit enemy " + str(hitSound) + ".mp3")
	$AudioStreamPlayer2D.play()
	match damageType:
		1:
			match type:
				1:
					health -= damageAmount
				2:
					health -= damageAmount * 1.25
					slowness = 0.8
				3:
					health -= damageAmount * 0.75
					slowness = 0.8
				4:
					health -= damageAmount * 0.75
					slowness = 0.8
				5:
					health -= damageAmount * 1.25
					slowness = 0.8
		2:
			match type:
				1:
					health -= damageAmount * 0.75
				2:
					health -= damageAmount
					slowness = 0.8
				3:
					health -= damageAmount * 1.25
					slowness = 0.8
				4:
					health -= damageAmount * 1.25
					slowness = 0.8
				5:
					health -= damageAmount * 0.75
					slowness = 0.8
		3:
			match type:
				1:
					health -= damageAmount * 1.25
				2:
					health -= damageAmount * 0.75
				3:
					health -= damageAmount
				4:
					health -= damageAmount * 1.25
				5:
					health -= damageAmount * 0.75
		4:	
			match type:
				1:
					health -= damageAmount * 1.25
				2:
					health -= damageAmount * 0.75
				3:
					health -= damageAmount * 0.75
				4:
					health -= damageAmount
				5:
					health -= damageAmount * 1.25
		5:
			match type:
				1:
					health -= damageAmount * 0.75
					slowness = 0.8
				2:
					health -= damageAmount * 1.25
					slowness = 0.8
				3:
					health -= damageAmount * 1.25
					slowness = 0.8
				4:
					health -= damageAmount * 0.75
					slowness = 0.8
				5:
					health -= damageAmount
					slowness = 0.8
