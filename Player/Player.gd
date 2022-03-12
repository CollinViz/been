extends KinematicBody

class_name PlayerObject

export var speed:=10
export(NodePath) var leftHandNodePath
onready var leftHand = get_node(leftHandNodePath)
onready var gunController=$GunController

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_input()-> Vector3:
	var vReturn = Vector3.ZERO
	if Input.is_action_pressed("up"):
		vReturn.z-=1
	if Input.is_action_pressed("down"):
		vReturn.z+=1	
	if Input.is_action_pressed("left"):
		vReturn.x-=1	
	if Input.is_action_pressed("right"):
		vReturn.x+=1	
	return vReturn

func _physics_process(delta):
	var vec = get_input()
	move_and_slide(vec  * speed,Vector3.UP)
	
	if Input.is_action_pressed("primary_action"):
		gunController.shoot()
