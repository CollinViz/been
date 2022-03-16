tool
extends Node2D

export(bool)  var draw_dungeon  setget draw_dungeon

signal flat_world_done(rooms)

# this scene exists solely to run redraw on Caves.tscn
# without the tilemap selected, so the grid isn't shown in
# the webp animation on the blog post

func draw_dungeon(value = null):

	# only do this if we are working in the editor
	if !Engine.is_editor_hint(): return

	$Dungeon.redraw()


#func _on_Dungeon_done(rooms:Dictionary) -> void:
#	emit_signal("flat_world_done",rooms)
#
#
#


func _on_Main_flat_world_done(rooms) -> void:
	emit_signal("flat_world_done",rooms)
