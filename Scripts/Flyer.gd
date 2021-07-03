extends "Enemy.gd"


var heightChange = 0
var tracker = 0
var bobspeedModifier = 1
var bobAmplitudeModifier = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 50
	attack = 10
	soulReturn = 50
	hitsToStagger = 1
	staggerCounter = hitsToStagger


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	heightChange = cos(tracker)
	move_and_slide(Vector2(0, heightChange * bobAmplitudeModifier))
	tracker += delta / bobspeedModifier
