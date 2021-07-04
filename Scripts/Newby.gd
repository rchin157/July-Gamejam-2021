extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var newDialogue = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func getText():
	newDialogue = false;
	return "res://StoryText/tutorial2.tres"
func getImage():
	return 3

func newDialogue():
	return newDialogue;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
