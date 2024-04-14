extends Node2D

var rune = preload("res://rune.tscn")
var recipeBook = preload("res://recipe_book.tscn")
var enemy = preload("res://enemy.tscn")
var projectile = preload("res://projectile.tscn")
var podNW
var podNE
var podSW
var podSE
var podPerm

var dmgTemp = 0
var askTemp = 0
var replenish = 0

var tempIce = 0
var tempWater = 0
var tempFire = 0
var tempMagic = 0
var tempDark = 0

var permDmg = 0
var permAsk = 0
var permArt = 0
var permIce = 0
var permWater = 0
var permFire = 0
var permMagic = 0
var permDark = 0

var enemiesAlive = false
var roundNum = 1

var nextElement
var nextType

var energy = 0
var waitTimer = false
var attackTimerLength = 1

var summoningEnemies = false
var summonTime = false

var amount = 0

var healthbarFull = 270

var ritualStart = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tutorial.hide()
	$LossScreen.hide()
	$MainMenu.show()
	prepareNextRound()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Global.game_in_progress):
		for i in 9:
				var runeLocation = get_node("GridContainer/Platform" + str(i + 1))
				if !runeLocation.occupied:
					runeLocation.occupied = true
					makeNewRune(i + 1, runeLocation)
		if amount == 0 && summoningEnemies:
			summoningEnemies = false
			ritualStart = false
			prepareNextRound()
		showNextRound()
		if $Path2D.get_child_count() < 1 && !summoningEnemies && enemiesAlive:
			enemiesAlive = false
			Global.round_in_progress = false
			roundNum += 1
			$SummonedCreature.hide()
			$EndRound.play()
			roundEnd()
			if Global.health <= 0:
				Global.game_in_progress = false
				Global.clear_runes = true
				$LossScreen.show()
		$Healthbar.set_size(Vector2(132, healthbarFull / 10 * Global.health))
		$ElementalEnergy/Label.text = str(Global.energy)
		checkPodiums()
		$StartRitual/ElementalEnergy/Label.text = str(getCost())
		$CurrentRound.text = "Current Round: " + str(roundNum)
		
func _on_start_ritual_pressed():
	if (!Global.round_in_progress):
		checkPodiums()
		var cost = getCost()
		if Global.energy >= cost:
			Global.energy -= cost
			buildSummon()
			ritualStart = true
			summoningEnemies = true
			enemiesAlive = true
			Global.round_in_progress = true
			amount = roundNum * 2
			$SummonedCreature.show()
			$StartRound.play()
		else:
			$PopupTimer.start()
			$"Not Enough Energy".show()
	
func checkPodiums():
	podNW = $PNW.currentRune
	podNE = $PNE.currentRune
	podSW = $PSW.currentRune
	podSE = $PSE.currentRune
	podPerm = $PPerm.currentRune
	pass

func getCost():
	var cost = 0
	if (int(podNW) % 2 == 0 && int(podNW) > 0):
		cost += 75
	elif (int(podNW) == 9):
		cost += 150
	elif (int(podNW) > 0):
		cost += 50
	if (int(podNE) % 2 == 0 && int(podNE) > 0):
		cost += 75
	elif (int(podNE) == 9):
		cost += 150
	elif (int(podNE) > 0):
		cost += 50
	if (int(podSW) % 2 == 0 && int(podSW) > 0):
		cost += 75
	elif (int(podSW) == 9):
		cost += 150
	elif (int(podSW) > 0):
		cost += 50
	if (int(podSE) % 2 == 0 && int(podSE) > 0):
		cost += 75
	elif (int(podSE) == 9):
		cost += 150
	elif (int(podSE) > 0):
		cost += 50
	if (int(podPerm) % 2 == 0 && int(podPerm) > 0):
		cost += 75 * 3
	elif (int(podPerm) == 9):
		cost += 150 * 3
	elif (int(podPerm) > 0):
		cost += 50 * 3
	return cost

func buildSummon():
	match podNW:
		"1":
			tempIce += 1
		"3":
			tempWater += 1
		"5":
			tempFire += 1
		"7":
			tempMagic += 1
		"9":
			tempDark += 1
		"2":
			dmgTemp += 1
		"4":
			askTemp += 1
		"8":
			replenish += 1
	match podNE:
		"1":
			tempIce += 1
		"3":
			tempWater += 1
		"5":
			tempFire += 1
		"7":
			tempMagic += 1
		"9":
			tempDark += 1
		"2":
			dmgTemp += 1
		"4":
			askTemp += 1
		"8":
			replenish += 1
	match podSW:
		"1":
			tempIce += 1
		"3":
			tempWater += 1
		"5":
			tempFire += 1
		"7":
			tempMagic += 1
		"9":
			tempDark += 1
		"2":
			dmgTemp += 1
		"4":
			askTemp += 1
		"8":
			replenish += 1
	match podSE:
		"1":
			tempIce += 1
		"3":
			tempWater += 1
		"5":
			tempFire += 1
		"7":
			tempMagic += 1
		"9":
			tempDark += 1
		"2":
			dmgTemp += 1
		"4":
			askTemp += 1
		"8":
			replenish += 1
	match podPerm:
		"1":
			permIce += 1
		"3":
			permWater += 1
		"5":
			permFire += 1
		"7":
			permMagic += 1
		"9":
			permDark += 1
		"2":
			permDmg += 1
		"4":
			permAsk += 1
		"6":
			permArt += 1
		"8":
			replenish += 1
			
	while permArt > 0:
		attackTimerLength *= 0.9
		permArt -= 1
	$Shoot.wait_time = attackTimerLength
	while replenish > 0:
		Global.health += 1
		replenish -= 1
	
func makeNewRune(runeType, runeLocation):
	var newRune = rune.instantiate()
	newRune.runeType = str(runeType)
	newRune.global_position = runeLocation.global_position
	newRune.current_body = runeLocation
	add_child(newRune)

func _on_open_book_pressed():
	$OpenBookSound.play()
	$RecipeBook.hide()
	$Healthbar.hide()
	$BookBack.hide()
	$OpenBook.hide()
	var book = recipeBook.instantiate()
	add_child(book)
	pass # Replace with function body.

func close_book():
	$RecipeBook.show()
	$Healthbar.show()
	$BookBack.show()
	$OpenBook.show()
	$CloseBookSound.play()
	
func summonEnemy(element, type):
	var newEnemy = enemy.instantiate()
	newEnemy.build(type, element)
	$Path2D.add_child(newEnemy)
	enemiesAlive = true
	pass
	
func roundEnd():
	dmgTemp = 0
	askTemp = 0
	tempIce = 0
	tempWater = 0
	tempFire = 0
	tempMagic = 0
	tempDark = 0
	
func prepareNextRound():
	var random = RandomNumberGenerator.new()
	nextElement = random.randi_range(1, 5)
	var nextEnemyType = random.randi_range(1, 10)
	if (nextEnemyType < 5):
		nextType = 1
		$Label/TextureRect.texture = null
	elif (nextEnemyType >= 5 && nextEnemyType <= 7):
		nextType = 2
		$Label/TextureRect.texture = load("res://Textures/TankEmblem.png")
	else:
		nextType = 3
		$Label/TextureRect.texture = load("res://Textures/ScoutEmblem.png")

func showNextRound():
	match nextElement:
		1:
			$Label/TextureRect2.texture = load("res://Textures/IceEmblem.png")
		2:
			$Label/TextureRect2.texture = load("res://Textures/WaterEmblem.png")
		3:
			$Label/TextureRect2.texture = load("res://Textures/FireEmblem.png")
		4:
			$Label/TextureRect2.texture = load("res://Textures/MagicEmblem.png")
		5:
			$Label/TextureRect2.texture = load("res://Textures/DarkEmblem.png")
	
	pass
	
func _on_enemy_respawn_timeout():
	if (summoningEnemies && amount > 0):
		summonEnemy(nextElement, nextType)
		amount -= 1
	pass # Replace with function body.
	
func _on_shoot_timeout():
	if ($Path2D.get_child_count() > 0):
		var numIce = tempIce + permIce
		var numWater = tempWater + permWater
		var numFire = tempFire + permFire
		var numMagic = tempMagic + permMagic
		var numDark = tempDark + permDark
		#print(str(numIce) + ", " + str(numWater) + ", " + str(numFire) + ", " + str(numMagic) + ", " + str(numDark))
		var dmgBonus = dmgTemp * 2.0 + permDmg * 2.0
		var speedBonus = askTemp / 5.0 + permAsk / 5.0
		while (numIce > 0):
			var iceProj = projectile.instantiate()
			iceProj.build(20 + dmgBonus, 1 + speedBonus ,1)
			add_child(iceProj)
			numIce -= 1
			makeShootSound()
		while (numWater > 0):
			var waterProj = projectile.instantiate()
			waterProj.build(20 + dmgBonus, 1 + speedBonus ,2)
			add_child(waterProj)
			numWater -= 1
			makeShootSound()
		while (numFire > 0):
			var fireProj = projectile.instantiate()
			fireProj.build(25 + dmgBonus, 1 + speedBonus ,3)
			add_child(fireProj)
			numFire -= 1
			makeShootSound()
		while (numMagic > 0):
			var magicProj = projectile.instantiate()
			magicProj.build(25 + dmgBonus, 1 + speedBonus ,4)
			add_child(magicProj)
			numMagic -= 1
			makeShootSound()
		while (numDark > 0):
			var darkProj = projectile.instantiate()
			darkProj.build(25 + dmgBonus, 1 + speedBonus ,5)
			add_child(darkProj)
			numDark -= 1
			makeShootSound()
		pass
	pass # Replace with function body.

func makeShootSound():
	var rng = RandomNumberGenerator.new()
	var shootSound = rng.randi_range(1, 3)
	$ShootProjectile.stream = load("res://Audio/shoot projectile " + str(shootSound) + ".mp3")
	$ShootProjectile.play()

func _on_popup_timer_timeout():
	$"Not Enough Energy".hide()
	pass # Replace with function body.

func reset_all():
	dmgTemp = 0
	askTemp = 0
	replenish = 0
	tempIce = 0
	tempWater = 0
	tempFire = 0
	tempMagic = 0
	tempDark = 0
	permDmg = 0
	permAsk = 0
	permArt = 0
	permIce = 0
	permWater = 0
	permFire = 0
	permMagic = 0
	permDark = 0
	enemiesAlive = false
	roundNum = 1
	energy = 0
	waitTimer = false
	attackTimerLength = 1
	summoningEnemies = false
	summonTime = false
	amount = 0
	healthbarFull = 270
	ritualStart = false
