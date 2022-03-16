extends Spatial

onready var mainMap = get_node("baseMap")
onready var mapgen:Node2D = $MainDungen

var rooms_gen=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 
	create_rooms()

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.pressed and event.scancode==KEY_TAB:
		mapgen.visible=!mapgen.visible


func create_rooms():
#	mapgen.visible=false
	print(rooms_gen)
	for room in rooms_gen:
		import_level("level00",room.x,room.y)
		for d in room.doors:
			mainMap.set_cell_item(d.x*2,0,d.y*2,0,0)


func import_level(levelFile,x_offset,z_offest):
	var save_game = File.new()
	if not save_game.file_exists("res://Level/%s.dat"%levelFile): 
		return 
	save_game.open("res://Level/%s.dat"%levelFile, File.READ)
	var gridData = str2var(save_game.get_as_text())
	var max_z = 0
	for cel in gridData:
		mainMap.set_cell_item(cel.x+x_offset,cel.y,z_offest + cel.z,cel.i,cel.o)


func _on_Dungeon_done(rooms) -> void:
	rooms_gen = rooms
#	
