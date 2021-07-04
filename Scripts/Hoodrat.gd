extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var textRet = 0;
var tomatoSeed;
var spawnPoint
var newDialogue = true

# Called when the node enters the scene tree for the first time.
func _ready():
	tomatoSeed = load("res://Entities/FlyEnemy.tscn")
	spawnPoint = get_node("TomatoTown")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getImage():
	return 2

func getText():
	var text = "res://StoryText/rockboi"+String(textRet)+".tres"
	if textRet<2:
		textRet+=1;
	else:
		newDialogue = false;
	return text
	
func newDialogue():
	return newDialogue

func _on_interactRange_area_exited(area):
	if textRet == 2:
		scale.x*=-1;
		textRet = 3
		newDialogue = true
	pass # Replace with function body.


func _on_TomatoRange_area_exited(area):
	if textRet == 3:
		frame = 1;
		var tomatoSpawn = tomatoSeed.instance();
		get_parent().add_child(tomatoSpawn)
		tomatoSpawn.set_position(spawnPoint.global_position)
		print("TomatoTown")
	pass # Replace with function body.
