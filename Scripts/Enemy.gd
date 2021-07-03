extends KinematicBody2D


var aggro = false
var player = null
var animator
var targetable = false
var alive = true
var speed = 20
var attacking = false;

var currentAnimation
var previousAnimation

var staggerTime = 1
var remainingStaggerTime = staggerTime
var staggered = false
var hitsToStagger = 2
var staggerCounter = hitsToStagger

var attackCDM = 60;
var attackCD = 0;

var iFrames = 0;
var iFramesM = 6;

var health = 100
var attack = 20
var soulReturn = 100
var animationTree;
var animationState

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = get_node("Rotation Axis/AnimatedSprite")
	animationTree = get_node("AnimationTree")
	animationState = animationTree.get("parameters/playback")
	#animator.set_animation("idle")
	currentAnimation = "Idle"
	previousAnimation = "none"
	#animator.get_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentAnimation != previousAnimation and not attacking:
		animationState.travel(currentAnimation)
		previousAnimation = currentAnimation
	if alive:
		if health <= 0:
		#	currentAnimation = "die"
			alive = false
		elif staggered:
#			currentAnimation = "staggered"
			if remainingStaggerTime <= 0:
				staggered = false
				remainingStaggerTime = staggerTime
				staggerCounter = hitsToStagger
			else:
				remainingStaggerTime -= delta
		elif aggro:
			if targetable and not attacking and attackCD == 0:
				if(animator.scale.x>0):
					currentAnimation = "Attack"
				else:
					currentAnimation = "AttackR"
				attacking = true;
				animationState.travel(currentAnimation)
				previousAnimation = currentAnimation
				#rely on animation callback for "hitting"
			else:
				currentAnimation = "Aggro"
				if player.get_position().x < get_position().x:
					move_and_slide(Vector2.LEFT * speed)
					animator.scale.x = 0.25
				else:
					move_and_slide(Vector2.RIGHT * speed)
					animator.scale.x = -0.25
		else:
			currentAnimation = "Idle"
	updateCDs();

func updateCDs():
	if(iFrames>0):
		iFrames-=1;
	if(attackCD>0):
		attackCD-=1;

func _on_aggroTrigger_body_entered(body):
	print(body.name)
	if body.name == "Player":
		print("entered aggro")
		player = body
		aggro = true


func _on_aggroLoss_body_exited(body):
	if body.name == "Player" and alive:
		print("left aggro")
		player = null
		aggro = false
		currentAnimation = "Idle"

func attackEnded():
	attackCD = attackCDM;
	attacking = false;

func _on_attackRange_body_entered(body):
	if body.name == "Player":
		print("entered attack")
		targetable = true


func _on_attackRange_body_exited(body):
	if body.name == "Player":
		print("left attack")
		targetable = false


func getSoulReturn():
	return soulReturn
	

func takeDamage(dmg):
	if(iFrames == 0):
		iFrames = iFramesM;
		health -= dmg


func _on_AnimatedSprite_animation_finished():
	if not alive:
		#player.addSoul(getSoulReturn())
		queue_free()

func getAttack():
	return attack;

func _on_bodyArea_area_entered(area):
	print("ouch")
	print(area.name)
	#takeDamage(area.get_parent().getAttack())
	staggerCounter -= 1
	if staggerCounter <= 0:
		staggered = true
