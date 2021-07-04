extends Sprite


var xChange = 0
var tracker = 0
export(float) var slidespeed
export(float) var slideAmplitudeModifier

var originx


# Called when the node enters the scene tree for the first time.
func _ready():
	originx = position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	xChange = cos(tracker)
	position.x = originx + xChange * slideAmplitudeModifier
	tracker += slidespeed / 1000
