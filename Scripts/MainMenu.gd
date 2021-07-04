extends Node2D


var asp


# Called when the node enters the scene tree for the first time.
func _ready():
	asp = get_node("AudioStreamPlayer2D")
	asp.play(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://Levels/Tutorial.tscn")
