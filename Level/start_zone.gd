extends Spatial

onready var cube_material = preload("res://Enemy/normal.tres")
onready var builderLight:OmniLight = $builderLight
onready var mainMap:GridMap = $Navigation/NavigationMeshInstance/mainMap
onready var Nav:Navigation = $Navigation
onready var NavMesh:NavigationMeshInstance = $Navigation/NavigationMeshInstance
var z_offest = 0
var listOfLevels=["level0","level00"]
# Called when the node enters the scene tree for the first time.
func _ready():
#	builderLight.visible=false
	GameData.ActiveNaveMesh = Nav
	build_new_level()
	
func build_new_level():
	mainMap.clear()
	z_offest =0
	import_level(listOfLevels[0])
	convert_gridmap()
#	import_level(listOfLevels[1])
	
func import_level(levelFile):
	var save_game = File.new()
	if not save_game.file_exists("res://Level/%s.dat"%levelFile): 
		return 
	save_game.open("res://Level/%s.dat"%levelFile, File.READ)
	var gridData = str2var(save_game.get_as_text())
	var max_z = 0
	for cel in gridData:
		mainMap.set_cell_item(cel.x,cel.y,z_offest + cel.z,cel.i,cel.o)
		if max_z> cel.z:
			max_z = cel.z
		
		
func convert_gridmap():
	# Must set gridmap as "use in baked light".
	mainMap.make_baked_meshes()
	var arr = mainMap.get_bake_meshes()
	
	var num_meshes = arr.size() / 2
	for i in range (num_meshes):
		var ref_mesh = arr[i * 2]
		var mesh_xform = arr[(i * 2) + 1]
		var mi = MeshInstance.new()
		mi.mesh = ref_mesh
		mi.transform = mesh_xform
		mi.material_override = cube_material # Add material.
		mi.create_trimesh_collision() # Add collision to mesh.
		
		mainMap.get_parent().add_child(mi)
		
	#gridmap.queue_free()		
		
		
		
		
		
		
