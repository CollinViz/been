extends Spatial


export (NodePath) var camera_node
export (NodePath) var player_node

var ray_origin :=Vector3.ZERO
var ray_target :=Vector3.ZERO
onready var main_camera:Camera = get_node(camera_node)
onready var main_player:KinematicBody = get_node(player_node)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !main_player || main_player==null || main_player.is_queued_for_deletion():
		return
	var mouse_possition = get_viewport().get_mouse_position()
	ray_origin = main_camera.project_ray_origin(mouse_possition)
	
	ray_target = ray_origin + main_camera.project_ray_normal(mouse_possition) * 2000
	
	var space_state = get_world().direct_space_state
	var intersect = space_state.intersect_ray(ray_origin,ray_target)
	
	if not intersect.empty():
#		print("Origin %s target %s %s"%[ray_origin,ray_target,intersect])
		var pos = intersect.position
		var pos_player_hieght = Vector3(pos.x,main_player.translation.y,pos.z)
		main_player.look_at(pos_player_hieght,Vector3.UP)
