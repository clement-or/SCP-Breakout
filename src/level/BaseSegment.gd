extends Spatial

signal end_reached

export(NodePath) var end setget ,get_end
export(int, 1, 10) var lanes_count = 3


var speed : float = 20 # units/s
var lane_width : float
var end_reached_emitted = false



func _ready():
	lane_width = $WidthStart.transform.origin.distance_to($WidthEnd.transform.origin) / lanes_count


func _physics_process(delta):
	transform.origin.z -= speed * delta
	
	# Emit only once
	if !end_reached_emitted && get_end().global_transform.origin.z <= 0:
		emit_signal("end_reached")
		end_reached_emitted = true
		print("End reached")


func get_end() -> Spatial:
	return get_node(end) as Spatial \
		   if end else \
		   get_node("End") as Spatial
