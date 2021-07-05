extends "StaticEnemy.gd"


var heightChange = 0
var tracker = 0
var bobspeedModifier = 1
var bobAmplitudeModifier = 10

var swoopDepth = 100
var swooptracker = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	mhealth = 10
	health = mhealth
	attack = 10
	soulReturn = 50
	hitsToStagger = 1
	staggerCounter = hitsToStagger


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not attacking:
		heightChange = cos(tracker)
		move_and_slide(Vector2(0, heightChange * bobAmplitudeModifier))
		tracker += delta / bobspeedModifier

func attack(delta):
	if swooptracker > PI:
		attackEnded()
		swooptracker = 0
	else:
		var newVect = Vector2((swooptracker * attdirection) * speed * 7, cos(swooptracker) * swoopDepth)
		#print(swooptracker)
		#(swooptracker * direction) * speed
		#cos(swooptracker) * swoopDepth
		move_and_slide(newVect)
		swooptracker += delta * 3
