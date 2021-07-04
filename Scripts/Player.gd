extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hitbox;
var animationTree;
var animationState;
var animationPlayer;
var rotate;
var movespeed = 50;
var velocity = Vector2.ZERO
var feet;
var rotateable = true;

var holding = false;
var attackP = 0;
var attack = 0;
var timercount = 0;
var holdTolerance = 30;
var holdCount = -1;

var hBarFill;
var hBarFrame;

var healthM = 50;
var health = 50;
var iFrames = 0;
var iFramesM = 60;

# Called when the node enters the scene tree for the first time.
func _ready():
	hBarFill = get_node("Camera2D/Control/HealthFill")
	hBarFrame = get_node("Camera2D/Control/HealthFrame")
	animationPlayer= get_node("AnimationPlayer")
	animationTree = get_node("AnimationTree")
	rotate = get_node("RotationPivot (Sneed)")
	animationState = animationTree.get("parameters/playback")
	feet = get_node("RotationPivot (Sneed)/AnimatedSprite/Feet")
	updateHealth();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized();
	
	if input_vector != Vector2.ZERO:
		if(rotateable):
			if(input_vector.x>0):
				rotate.scale.x = 1;
			else:
				rotate.scale.x = -1;
		if(Input.get_action_strength("ui_down")):
			feet.play("Sprint")
			move_and_slide(input_vector*2*movespeed)
		else:
			feet.play("Walk")
			move_and_slide(input_vector*movespeed)
	else:
		feet.play("Idle")
	
	checkAttack();
	
	if iFrames>0:
		iFrames-=1;
			
	if timercount>0:
		timercount-=1;
	pass

func checkAttack():
	
	if Input.is_action_just_pressed("ui_select") and attack ==0:
		holdCount = 0;
	
	if holdCount != -1:
		holdCount+=1;
		if holdCount >=holdTolerance and attack == 0:
			attack = 4;
			animationState.travel("HoldAttack")
			rotateable = false;
	
	if Input.is_action_just_released("ui_select"):
		if holdCount <holdTolerance:
			rotateable = false;
			if( Input.get_action_strength("ui_up")):
				animationState.travel("AttackOverhead")
				attack = 4;
			else:
				if(timercount>0):
					if(attackP == 1):
						animationState.travel("AttackDown")
						attack = 2;
					else:
						animationState.travel("AttackStab")
						attack = 3;
				else:
					animationState.travel("AttackUp")
					attack = 1;
		holdCount = -1;
			
func nowRotate():
	rotateable = true;

func die():
	#Game over goes here
	return;

func attackStopped(var attackID):
	attackP = attackID;
	print("attack stopped")
	
	if attackID == 1 or attackID == 2:
		timercount = 20
	attack = 0
	return

func updateHealth():
	hBarFrame.speed_scale = 4*health/healthM
	print(-8-(232*(1-health/healthM)))
	hBarFill.position.x = -240+(232*health/healthM);

func holdingAttack():
	print("Checking if holding")
	if not Input.get_action_strength("ui_select"):
		holding = false
		rotateable = false;
		attackStopped(4)
		animationState.travel("Idle")
	

func _on_Damage_area_entered(area):
	var damage = area.get_parent().get_parent().get_parent().getAttack()
	
	if iFrames == 0:
		health-=damage
		print(health)
		if health <=0:
			die()
		updateHealth();
		iFrames = iFramesM
	
	pass # Replace with function body.
