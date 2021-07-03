extends KinematicBody2D


var aggro = false
var player = null
var animator
var targetable = false
var alive = true
var speed = 20

var currentAnimation
var previousAnimation

var staggerTime = 1
var remainingStaggerTime = staggerTime
var staggered = false
var hitsToStagger = 2
var staggerCounter = hitsToStagger

var health = 100
var attack = 20
var soulReturn = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	animator = get_node("AnimatedSprite")
	#animator.set_animation("idle")
	currentAnimation = "idle"
	previousAnimation = "none"
	#animator.get_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentAnimation != previousAnimation:
		animator.set_animation(currentAnimation)
		previousAnimation = currentAnimation
	if alive:
		if health <= 0:
			currentAnimation = "die"
			alive = false
		elif staggered:
			currentAnimation = "staggered"
			if remainingStaggerTime <= 0:
				staggered = false
				remainingStaggerTime = staggerTime
				staggerCounter = hitsToStagger
			else:
				remainingStaggerTime -= delta
		elif aggro:
			if targetable:
				currentAnimation = "attack1"
				#rely on animation callback for "hitting"
			else:
				currentAnimation = "walking"
				if player.get_position().x < get_position().x:
					move_and_slide(Vector2.LEFT * speed)
				else:
					move_and_slide(Vector2.RIGHT * speed)
		else:
			currentAnimation = "idle"


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
		currentAnimation = "idle"


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
	health -= dmg


func _on_AnimatedSprite_animation_finished():
	if not alive:
		#player.addSoul(getSoulReturn())
		queue_free()


func _on_bodyArea_area_entered(area):
	print("ouch")
	print(area.name)
	#takeDamage(area.get_parent().getAttack())
	staggerCounter -= 1
	if staggerCounter <= 0:
		staggered = true
