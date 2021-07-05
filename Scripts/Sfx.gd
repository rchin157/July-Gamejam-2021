extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var musicArray
var syncMusic = [2,6,11]
var sfxArray
var enemyCount= 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	musicArray = [
		get_node("Boss in Demonland"),
		get_node("ChainsawMotor"),
		get_node("Demon Fight")
	]
	
	sfxArray = [
		get_node("ComboA"),
		get_node("ComboB"),
		get_node("ComboC"),
		get_node("HoldAttack"),
		get_node("Upswing")
	]
	
	pass # Replace with function body.

func playSFX(index:int):
	sfxArray[index].play(0)
	
func stopSFX(index):
	sfxArray[index].stop()

func enableSong(index: int):
	musicArray[index].play(musicArray[1].get_playback_position())
	
func stopSong(index: int):
	musicArray[index].stop();
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
