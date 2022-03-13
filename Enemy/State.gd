extends "res://StateMachine/StateMachine.gd"

class_name EnemyFSM


func _ready():
	add_state("idle")
	add_state("seeking")
	add_state("attacking")
	add_state("returning")
	add_state("resting") 
	add_state("hit") 
	#call_deferred("set_state",states.idle)


func _state_logic(delta):
	
	match state:		
		states.idle:
			pass
		states.seeking:
			parent.move_to_target(delta)
			if parent.hasArrived():
				parent.move_to_next_index()
		states.attacking:  
			parent.move_to_target(delta,true)
		states.returning:  
			parent.move_to_target(delta,true)
		states.hit:  
			parent.move_to_target(delta,true)
	

func _get_transition(_delta): 
	if state == states.idle :
		return states.seeking
	if state == states.seeking && parent.can_see_traget():
		return states.attacking
#	if state == states.attacking && parent.hasArrived():
#		return states.returning
	if state == states.returning && parent.hasArrived():
		return states.resting
#	if state == states.hit && parent.hasArrived() && parent.can_see_traget():
#		return states.attacking
#	if state == states.hit && parent.hasArrived() && !parent.can_see_traget():
#		return states.seeking
#	if state == states.walking && parent.hasArrived():
#		return states.idle
#	if state==states.idle && !parent.Is_Home():
#		return states.walking_home
#	if state==states.attacking && !parent.stillActiveTarget():
#		return states.walking_home
#
	return null 

func _enter_state(new_state,old_state):
	print("Enemy _enter_state new ",_stateName(new_state)," old ",_stateName(old_state))
#	parent.set_facingDirection()
	match new_state:
		states.seeking:
			parent.start_AI_find()
			parent.change_colour(new_state)
		states.attacking:
			parent.change_colour(new_state)
			parent.start_attack()
		states.returning:
			parent.change_colour(new_state)
			parent.move_to_start()
		states.resting:
			parent.change_colour(new_state)
			parent.start_resting_cooldonw()
	 

func _exit_state(old_state,new_state):
	print("Enemy _exit_state old ",_stateName(old_state)," new ",_stateName(new_state))
#
	match old_state:
		states.seeking:
			parent.stop_AI_find()
