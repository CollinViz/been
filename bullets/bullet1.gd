extends Spatial

export var base_damage:=1
export var speed:=30


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var forward = global_transform.basis.z.normalized()
	global_translate(forward * speed*delta)

func _on_killTimer_timeout():
	queue_free()


func _on_bullet1_body_entered(body:Node):
	if body.has_node("Stats"):
		body.get_node("Stats").take_damage(base_damage)
	print("Hit something")
	queue_free()
	


