extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Summary.text = "You Survived for " + str(find_parent("Table").roundNum - 2) + " Rounds"
	pass


func _on_start_pressed():
	hide()
	Global.clear_runes = false
	$"../MainMenu".show()
	$"..".reset_all()
	pass # Replace with function body.
