extends Spatial

export var distance=3
export var max_distance=4.0
export var heigth=2.0
export(NodePath) var follow_target_path

var target:Spatial
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(follow_target_path)


func get_camera_shake()->Vector2:
	return Vector2.ZERO

func _process(delta):
	var camera_shake = get_camera_shake()
	var camera_pos = Vector3.ZERO
	camera_pos.x = target.translation.x + camera_shake.x
	camera_pos.z = target.translation.z + camera_shake.y
	camera_pos.y = get_translation().y
	var toPlayer = (get_translation()-camera_pos).length()
	if toPlayer>1:
		var newpos = get_translation() - ((get_translation()-camera_pos).normalized()* distance *delta)
		set_translation(newpos)

#func _physics_process(delta):
#	if !target || target==null :
#		return
#
#	var t = target.get_global_transform().origin
#	var pos = get_global_transform().origin
##	var up = Vector3.UP
#
#
#
#	var offset = (pos-t).normalized()*distance
#	offset.y=heigth
#
#	#pos = t + offset
#	if ((pos+offset)-t).length()>1:
#		transform.origin= pos+offset
#		#get_global_transform().origin = pos
#	#look_at_from_position(pos,t,Vector3.UP)
#		#global_translate(offset)
#
#
	
	
