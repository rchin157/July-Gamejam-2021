extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hitbox;
var animationTree;
var animationState;
var movespeed = 50;
var velocity = Vector2.ZERO
var attack = 0;
var timercount = 0;

var health = 50;
var iFrames = 0;
var iFramesM = 60;

# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree = get_node("AnimationTree")
	animationState = animationTree.get("parameters/playback")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized();
	
	if input_vector != Vector2.ZERO:
		if(attack == 0):
			animationState.travel("Running")
		move_and_slide(input_vector*movespeed)
	else:
		if(attack == 0):
			animationState.travel("Idle")
	if Input.get_action_strength("ui_select"):
		print(String(attack)+" "+String(timercount))
	if Input.get_action_strength("ui_select") and attack == 0:
		print("attacking")
		if(timercount>0):
			animationState.travel("Attack2")
			attack = 2;
		else:
			animationState.travel("Attack1")
			attack = 1;
	if iFrames>0:
		iFrames-=1;
			
	if timercount>0:
		timercount-=1;
	pass

func attackStopped(var attackID):
	print("attack stopped")
	
	if attackID == 1:
		timercount = 20
	attack = 0
	return


func _on_Damage_area_entered(area):
	var damage = area.get_parent().get_parent().get_parent().getAttack()
	
	if iFrames == 0:
		health-=damage
		print(health)
		iFrames = iFramesM
	
	pass # Replace with function body.
