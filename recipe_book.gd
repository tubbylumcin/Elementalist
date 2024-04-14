extends Control

var pgNum = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pgNum > 1:
		$PreviousPage.show()
	else:
		$PreviousPage.hide()
	if pgNum < 5:
		$NextPage.show()
	else:
		$NextPage.hide()
	pass
	
	$Page1/IceTotal.text = "Permanent Runes: " + str(find_parent("Table").permIce)
	$Page2/WaterTotal.text = "Permanent Runes: " + str(find_parent("Table").permWater)
	$Page2/FireTotal.text = "Permanent Runes: " + str(find_parent("Table").permFire)
	$Page3/MagicTotal.text = "Permanent Runes: " + str(find_parent("Table").permMagic)
	$Page3/DarknessTotal.text = "Permanent Runes: " + str(find_parent("Table").permDark)
	$Page4/DamageTotal.text = "Permanent Runes: " + str(find_parent("Table").permDmg)
	$Page4/RecoveryTotal.text = "Permanent Runes: " + str(find_parent("Table").permArt)
	$Page5/SpeedTotal.text = "Permanent Runes: " + str(find_parent("Table").permAsk)
	
	match pgNum:
		1:
			$Page1.show()
			$Page2.hide()
			$Page3.hide()
			$Page4.hide()
			$Page5.hide()
		2:
			$Page1.hide()
			$Page2.show()
			$Page3.hide()
			$Page4.hide()
			$Page5.hide()
		3:
			$Page1.hide()
			$Page2.hide()
			$Page3.show()
			$Page4.hide()
			$Page5.hide()
		4:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$Page4.show()
			$Page5.hide()
		5:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$Page4.hide()
			$Page5.show()

func _on_close_book_pressed():
	find_parent("Table").close_book()
	self.queue_free()
	pass # Replace with function body.


func _on_previous_page_pressed():
	pgNum -= 1
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(1, 5)
	$LeftPage.stream = load("res://Audio/pageflip" + str(random) + ".mp3")
	$LeftPage.play()


func _on_next_page_pressed():
	pgNum += 1
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(1, 5)
	$RightPage.stream = load("res://Audio/pageflip" + str(random) + ".mp3")
	$RightPage.play()
	
	
