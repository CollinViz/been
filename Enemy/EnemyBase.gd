extends KinematicBody

export var Attack_Cool_Down = 1.0
export var Resting_Cool_Down = 1.0
export var AI_look_Cool_Down = 0.5
export var base_damage:=1 
export var speed:=5
export var arrive_tolerance = 0.5
 
onready var fsm:EnemyFSM = $State
onready var normal_colour = preload("res://Enemy/normal.tres")
onready var attacking_colour = preload("res://Enemy/attack.tres")
onready var resting_colour = preload("res://Enemy/resting.tres")
onready var hit_colour = preload("res://Enemy/hit.tres")

onready var coolDownTimer:Timer = $onshot_cooldown
onready var AI_find:Timer= $AIFinding
onready var detection_area:Area = $Detection
onready var _body:MeshInstance = $body 
onready var tween_hit:Tween = $Tween
onready var debugQub:PackedScene = preload("res://debug/debugbox.tscn")


var attack_target:Node
var pos_before_attack:Vector3 = Vector3.ZERO
var following_target:Node
var next_target_possition:Vector3 = Vector3.ZERO
var nav_path_list = []
var index_in_path = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	fsm.set_state(fsm.states.idle)
	following_target = GameData.ActivePlayer

 
func _on_Stats_death():
	call_deferred("queue_free")


func _on_Detection_body_entered(body:Node):
	if body.has_node("Stats"):
		_set_attacking_body(body)
		fsm.set_state(fsm.states.attacking)

func _set_attacking_body(body:Node):
	attack_target = body
	

func can_see_traget():
	var alist = detection_area.get_overlapping_bodies()
	if alist.size()>0:
		for b in alist:
			if b.has_node("Stats"):
				_set_attacking_body(b)
				return true
	return false
	
func start_attack():	
	coolDownTimer.start(Attack_Cool_Down)
	pos_before_attack = global_transform.origin
	
func move_to_start():
	next_target_possition = pos_before_attack
	
func start_resting_cooldonw():
	coolDownTimer.start(Resting_Cool_Down)
	
func change_colour(state):
	match state:
		fsm.states.seeking:
			_body.set_surface_material(0,normal_colour)
		fsm.states.attacking:
			_body.set_surface_material(0,attacking_colour)
		fsm.states.returning:
			pass
		fsm.states.resting:
			_body.set_surface_material(0,resting_colour)



func _on_attackcooldown_timeout():
	match fsm.state:
		fsm.states.attacking:			
			if attack_target && !attack_target.is_queued_for_deletion():
				if can_see_traget():
					attack_target.get_node("Stats").take_damage(base_damage)
				else:
					print("player dodge")
			fsm.set_state(fsm.states.returning)
		fsm.states.resting:
			fsm.set_state(fsm.states.seeking)

func _update_nave():
	
	if following_target && !following_target.is_queued_for_deletion():
		nav_path_list = GameData.ActiveNaveMesh.get_simple_path(global_transform.origin,GameData.ActivePlayer.global_transform.origin)
		index_in_path=0
		if nav_path_list.size()==0:
			next_target_possition = Vector3.ZERO
		else:			 
			next_target_possition = nav_path_list[index_in_path]
#		print("Path ",nav_path_list)

func _on_AIFinding_timeout():
	_update_nave()
		
		
func start_AI_find():
	AI_find.start(AI_look_Cool_Down)
	_update_nave()
	

func stop_AI_find():
	AI_find.stop()

#Move and slid to target
func move_to_target(_delta,Hast=false):
	if next_target_possition != Vector3.ZERO:
		var direction = next_target_possition - global_transform.origin
		var vec = direction.normalized() * speed 
		if Hast:
			 vec = direction.normalized() * (speed *1.5)
#		print("dir %s vec %s" %[direction,vec])
		move_and_slide(vec)
		
func hasArrived():
	if next_target_possition != Vector3.ZERO:
		var direction = next_target_possition - global_transform.origin
		if direction.length()<arrive_tolerance:
			return true
	return false

func move_to_next_index():
	index_in_path+=1
	if index_in_path>=nav_path_list.size():
		index_in_path=0
		next_target_possition = Vector3.ZERO
	else:
		next_target_possition = nav_path_list[index_in_path]

func doflash():
	_body.set_surface_material(0,hit_colour)
	yield(get_tree().create_timer(0.15), "timeout")
	change_colour(fsm.state)
	
func _on_Stats_hit(_damage_direction:Vector3): 
#	var forward = damage_direction
#	var t:Transform = global_transform
#	t.basis.z + (damage_direction.inverse().normalized()*10)
#	next_target_possition =t.origin
#	var d:Spatial = debugQub.instance()
#	d.global_transform.origin=next_target_possition
#	get_parent().add_child(d)
#	fsm.set_state(fsm.states.hit)
	call_deferred("doflash")

func _on_Tween_tween_all_completed():
	print("Tween done")


func _on_Tween_tween_step(object, key, elapsed, value):
	pass
#	print("Tween on step %s %s %s"%[object, key, value])
