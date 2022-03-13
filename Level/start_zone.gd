extends Spatial


onready var builderLight:OmniLight = $builderLight
onready var mainMap:GridMap = $Navigation/mainMap

# Called when the node enters the scene tree for the first time.
func _ready():
#	builderLight.visible=false
	build_new_level()
	
func build_new_level():
	mainMap.clear()
	var simpleRoom = create_level_1()
	var z=-5
	var y=0
	var x=-7
	
	for row in simpleRoom:
		for cel in row:
			mainMap.set_cell_item(x,y,z,cell_type(cel),cell_origan(cel))
			x+=2
		z+=2
		x=-7

func cell_type(charType)->int:
	match charType:
		'x':
			return 5
		'D':
			return 8
		'|':
			return 5
		'z':
			return 5
		' ':
			return 6
	return 6 

func cell_origan(charType)->int:
	match charType:
		'x':
			return 13
		'D':
			return 0
		'|':
			return 3
		'z':
			return 13
		' ':
			return 0
	return 0
			
func create_level_1():
	var areturn = [['x','x','x','D','x','x','x'],
				   ['|',' ',' ',' ',' ',' ','|'],
				   ['|',' ',' ',' ',' ',' ','|'],
				   ['|',' ',' ',' ',' ',' ','|'],
				   ['|',' ',' ',' ',' ',' ','|'],
				   ['z','z','z','z','z','z','z']]
	return areturn
