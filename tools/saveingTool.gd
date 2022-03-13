tool

extends Spatial

export(NodePath) var gridMapPath 
export(NodePath) var sean_root_path

export(int) var save_grid setget save_set, save_get


func save_set(new_value:int):
	save_grid = new_value
	if new_value==1:
		save_grid_data()
	
func save_get()->int:
	return save_grid



func save_grid_data():
	var grid:GridMap = get_node(gridMapPath)
	var root:Spatial = get_node(sean_root_path)
	
	var FileName = root.name
	var allCells= grid.get_used_cells()
	var cellsList = []
	for cel in allCells:
		var line = {}
		line.x = cel.x
		line.y = cel.y
		line.z = cel.z
		line.o = grid.get_cell_item_orientation(cel.x,cel.y,cel.z)
		cellsList.append(line)
		
	var save_grid_data = File.new()
	save_grid_data.open("res://Level/%s.dat"%FileName, File.WRITE)
	var data = var2str(cellsList)
	save_grid_data.store_line(data)
	save_grid_data.close()









