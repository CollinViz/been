extends Node

class_name Stats

export var Max_HP:=10
export var Current_HP:=10

signal death
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	Current_HP = Max_HP 


func heal(Value):
	Current_HP+=Value
	if Current_HP>Max_HP:
		Current_HP = Max_HP

func get_hp():
	return Current_HP
	
func take_damage(damage):
	Current_HP-=damage
	if Current_HP<0:
		emit_signal("death")
	else:
		emit_signal("hit")
	print("Heath %d max %d"%[Current_HP,Max_HP])
