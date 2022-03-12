extends Spatial


export(PackedScene) var current_left_gun

onready var left_hand:Position3D = $leftHand
var _current_left_gun:GunBase
# Called when the node enters the scene tree for the first time.
func _ready():
	_current_left_gun = current_left_gun.instance()
	left_hand.add_child(_current_left_gun)


func shoot():
	if _current_left_gun:
		_current_left_gun.shoot()
