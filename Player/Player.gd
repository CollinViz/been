extends KinematicBody

class_name PlayerObject

export var speed:=10
export(NodePath) var leftHandNodePath
onready var leftHand = get_node(leftHandNodePath)
onready var gunController=$GunController

onready var normal_colour = preload("res://Player/Normal.tres")
onready var hit_colour = preload("res://Player/Hit.tres")

onready var _body = $body

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.ActivePlayer = self


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


func _on_Stats_death():
	GameData.player_death()	
	call_deferred("queue_free")


func _on_Stats_hit():
	_body.set_surface_material(0,hit_colour)
	yield(get_tree().create_timer(0.15), "timeout")
	_body.set_surface_material(0,normal_colour)
