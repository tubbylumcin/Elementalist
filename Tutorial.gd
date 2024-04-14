extends Control

var page = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match page:
		1:
			$Page1.show()
			$Page2.hide()
			$Page3.hide()
			$"Page3-2".hide()
			$Page4.hide()
			$Page5.hide()
		2:
			$Page1.hide()
			$Page2.show()
			$Page3.hide()
			$"Page3-2".hide()
			$Page4.hide()
			$Page5.hide()
		3:
			$Page1.hide()
			$Page2.hide()
			$Page3.show()
			$"Page3-2".show()
			$Page4.hide()
			$Page5.hide()
		4:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$"Page3-2".hide()
			$Page4.show()
			$Page5.hide()
		5:
			$Page1.hide()
			$Page2.hide()
			$Page3.hide()
			$"Page3-2".hide()
			$Page4.hide()
			$Page5.show()
	pass


func _on_next_page_button_pressed():
	if page == 5:
		hide()
		page = 1
	else:
		page += 1
	pass # Replace with function body.
