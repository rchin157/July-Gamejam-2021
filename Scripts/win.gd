extends Node2D


var animator
var button
var asp


# Called when the node enters the scene tree for the first time.
func _ready():
	animator = get_node("AnimatedSprite")
	animator.set_frame(0)
	button = get_node("Button")
	button.hide()
	asp = get_node("AudioStreamPlayer2D")
	asp.play(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if animator.get_frame() == 7:
		button.show()
		


func _on_Button_pressed():
	get_tree().change_scene("res://Levels/MainMenu.tscn")
