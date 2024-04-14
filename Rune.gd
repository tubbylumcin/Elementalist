extends Node2D

var draggable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos: Vector2

var runeType = "0"
var current_body

func _ready():
	$GPUParticles2D.hide()
	getTexture()
	
func _process(delta):
	if current_body.is_in_group("platform"):
		if find_parent("Table").ritualStart:
			current_body.currentRune = "-1"
			current_body.occupied = false
			self.queue_free()
	if draggable && !Global.round_in_progress:
		if Input.is_action_just_pressed("click"):
			$Pickup.play()
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable && !body_ref.occupied:
				tween.tween_property(self,"position",body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
				if current_body != null:
					current_body.currentRune = "-1"
					current_body.occupied = false
				body_ref.currentRune = runeType
				body_ref.occupied = true
				current_body = body_ref
				$"Put down".play()
			else:
				if current_body != null:
					current_body.currentRune = "-1"
					current_body.occupied = false
				self.queue_free()
		if Input.is_action_just_pressed("rclick"):
			if current_body != null:
				current_body.currentRune = "-1"
				current_body.occupied = false
			$Sprite2D.hide()
			$GPUParticles2D.show()
			$Timer.start()
	if Global.clear_runes:
		current_body.currentRune = "-1"
		current_body.occupied = false
		self.queue_free()

func getTexture():
	match runeType:
		"0":
			$Sprite2D.texture = load("res://Textures/Blank Rune.png")
		"1":
			$Sprite2D.texture = load("res://Textures/1th Rune.png")
		"2":
			$Sprite2D.texture = load("res://Textures/2th Rune.png")
		"3":
			$Sprite2D.texture = load("res://Textures/8th Rune.png")
		"4":
			$Sprite2D.texture = load("res://Textures/7th Rune.png")
		"5":
			$Sprite2D.texture = load("res://Textures/5th Rune.png")
		"6":
			$Sprite2D.texture = load("res://Textures/3th Rune.png")
		"7":
			$Sprite2D.texture = load("res://Textures/6th Rune.png")
		"8":
			$Sprite2D.texture = load("res://Textures/4th Rune.png")
		"9":
			$Sprite2D.texture = load("res://Textures/9th Rune.png")
			
func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.WHITE, 0.5)
		body_ref = body

func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		if $Area2D.get_overlapping_bodies().size() == 0:
			is_inside_dropable = false
		else:
			var areas = $Area2D.get_overlapping_bodies()
			body_ref = areas[0]
		body.modulate = Color(Color.WHITE, 0.2)

func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.1, 1.1)

func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
		
func _on_timer_timeout():
	self.queue_free()

func find_platform():
	getTexture()
	for i in 16:
		var platformPath = "../GridContainer/Platform" + str(i + 1)
		var platform = get_node(platformPath)
		if !platform.occupied:
			var tween = get_tree().create_tween()
			tween.tween_property(self,"position",platform.global_position,1).set_ease(Tween.EASE_OUT)
			platform.occupied = true
			current_body = platform
			return
	pass
