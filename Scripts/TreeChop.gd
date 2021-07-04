extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var newDialogue = true;
var textRet = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func getImage():
	return 4

func getText():
	var text = "res://StoryText/veteran"+String(textRet)+".tres"
	if textRet<2:
		textRet+=1;
	else:
		newDialogue = false;
	return text
	
func newDialogue():
	return newDialogue
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
