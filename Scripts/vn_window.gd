extends Control


var text = []
var currentIndex = 0
var label

var canFlip = true;

var listener

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("TextEdit")
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setListener(var l):
	listener = l;
	

func startvn(filename):
	if text.size()>0:
		currentIndex = 0;
		text = []
	var f = File.new()
	f.open(filename, File.READ)
	while not f.eof_reached():
		text.append(f.get_line())
	f.close()
	label.text = text[currentIndex]
	show()
	
func advancePage():
	listener.pageFlipped(currentIndex)
	currentIndex += 1
	if currentIndex == len(text) - 1:
		text.clear()
		currentIndex = 0
		hide()
		listener.vnEnded();
	else:
		label.text = text[currentIndex]

func _on_Button_pressed():
	if canFlip:
		advancePage()
