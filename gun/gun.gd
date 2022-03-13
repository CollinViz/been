extends Spatial

class_name GunBase
export var muzzelSpeed:=30
export var CoolDownValue:=0.25
export(PackedScene) var Bullet
export var base_damage:=1

onready var muzzel = $muzzel
onready var CoolDown:Timer = $Cooldown
var _can_shoot:=true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func shoot():
	if _can_shoot:
		var newBullet:Spatial = Bullet.instance()
		newBullet.global_transform = muzzel.global_transform
		newBullet.speed = muzzelSpeed
		newBullet.base_damage = base_damage
		get_parent().get_parent().get_parent().get_parent().add_child(newBullet)
		_can_shoot = false
		CoolDown.start(CoolDownValue)

func _on_Cooldown_timeout():
	_can_shoot = true
