extends Control


var text = []
var currentIndex = 0
var label


# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("TextEdit")
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func startvn(filename):
	var f = File.new()
	f.open(filename, File.READ)
	while not f.eof_reached():
		text.append(f.get_line())
	f.close()
	label.text = text[currentIndex]
	show()


func _on_Button_pressed():
	currentIndex += 1
	if currentIndex == len(text) - 1:
		text.clear()
		hide()
	else:
		label.text = text[currentIndex]
