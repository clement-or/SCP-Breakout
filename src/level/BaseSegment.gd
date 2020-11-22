extends Spatial


export(NodePath) var end setget ,get_end

var speed : float = 2 # units/s


func _physics_process(delta):
	transform.origin.z -= speed * delta

func get_end() -> Spatial:
	return get_node(end) as Spatial \
		   if end else \
		   get_node("End") as Spatial
