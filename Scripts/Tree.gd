extends RigidBody2D


export var mhealth = 100
var health = mhealth
var healthbar
var hidden = true


# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar = get_node("TextureProgress")
	healthbar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if hidden:
		hidden = false
		healthbar.show()
	print("chop me daddy")
	health -= area.get_parent().get_parent().getAttack()
	healthbar.value = int((float(health) / float(mhealth)) * 100)
	if health <= 0:
		die()
		

func die():
	queue_free()
