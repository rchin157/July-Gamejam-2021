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

var vn

var canTalk = true;
var talkable = null;
var previousTalkable = null;
var talkIcon;

var attackD = 10
var uAttackD = 10
var dAttackD = 15
var sAttackD = 20
var hAttackD = 5
var oAttackD = 10

var holding = false;
var attackP = 0;
var attack = 0;
var timercount = 0;
var holdTolerance = 30;
var holdCount = -1;
export var tutorial = -1;
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
	talkIcon = get_node("interact")
	rotate = get_node("RotationPivot (Sneed)")
	animationState = animationTree.get("parameters/playback")
	feet = get_node("RotationPivot (Sneed)/AnimatedSprite/Feet")
	vn = get_node("VN")
	vn.setListener(self)
	updateHealth();
	tutorial(0);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized();
	
	#VN COMPONENT LMAO
	if Input.is_action_just_pressed("ui_down") and talkable != null and talkable != previousTalkable:
		vn.startvn(talkable.getText())
		previousTalkable = talkable
	
	
	if input_vector != Vector2.ZERO:
		if(rotateable):
			if(input_vector.x>0):
				rotate.scale.x = 1;
			else:
				rotate.scale.x = -1;
		if(Input.get_action_strength("ui_focus_next")):
			feet.play("Sprint")
			tutorial(3)
			move_and_slide(input_vector*2*movespeed)
		else:
			tutorial(2)
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
			tutorial(7)
			attackD = hAttackD
			rotateable = false;
	
	if Input.is_action_just_released("ui_select"):
		if holdCount <holdTolerance:
			rotateable = false;
			if( Input.get_action_strength("ui_up")):
				animationState.travel("AttackOverhead")
				attack = 4;
				attackD = oAttackD
				tutorial(8)
			else:
				if(timercount>0):
					if(attackP == 1):
						animationState.travel("AttackDown")
						attackD = dAttackD
						attack = 2;
					else:
						animationState.travel("AttackStab")
						attackD = sAttackD
						attack = 3;
						tutorial(6)
				else:
					tutorial(5)
					animationState.travel("AttackUp")
					attackD = sAttackD
					attack = 1;
		holdCount = -1;
			
func nowRotate():
	rotateable = true;

func getAttack():
	return attackD

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
	
func vnEnded():
	if previousTalkable != null:
		tutorial(4)
		tutorial(9)
	return

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

func pageFlipped(var page):
	if page == 3:
		tutorial(1)

func tutorial(var point):
	if point-tutorial == 1:
		print(point)
		match point:
			0: #start
				canTalk = false
				vn.canFlip = true;
				vn.startvn("res://StoryText/tutorial1.tres")
			1: #walk
				vn.canFlip = false;
			2: # do run
				vn.advancePage()
			3: #do talk
				vn.advancePage()
				canTalk = true
				vn.canFlip = true;
			4: #attack
				vn.startvn("res://StoryText/tutorial3.tres")
				canTalk = false
				vn.canFlip = false;
#
			5: #combo
				vn.advancePage()
#
			6: #hold
				vn.advancePage()
			7: #overhead
				vn.advancePage()
			8: #finale
				vn.advancePage()
				vn.canFlip = true;
			9: #canLeave
				canTalk = true;
		tutorial+=1
			


func _on_Talk_area_entered(area):
	talkable = area.get_parent()
	talkIcon.visible = true;
	pass # Replace with function body.


func _on_Talk_area_exited(area):
	talkIcon.visible = false
	talkable = null;
	pass # Replace with function body.
