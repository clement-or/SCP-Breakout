extends Node


export(String) var starting_segment
export(String) var segments_folder_path = "res://src/level/segments"
export(int, 1, 10) var segments_ahead_count = 1     # How many segments we want to generate ahead of the player in advance
export(NodePath) var player_path

onready var game = $"/root/Game"


var segments = []
var cur_segments = []     # We want the two first indexes to be defined
var cur_segment setget ,_get_cur_segment


func _ready():
	# Get all segments in the /src/level/segments folder
	var files = FileManager.get_filelist(segments_folder_path)
	files += ["res://src/level/BaseSegment.tscn"]
	for file in files:
		if file.get_extension() == "tscn":
			segments += [load(file)]
	
	# Create first segment and advance segments
	cur_segments += [1]     # This is to initialize the 0 index which is not used yet
	cur_segments += [_spawn_segment(Vector3.ZERO)]     # Create the first segment
	
	# Create all the following segments
	for i in range(0, segments_ahead_count):
		cur_segments += [_spawn_segment(cur_segments[i-1].end.transform.origin)]
		


# Called when the player has reached the end of a segment
func _next_segment():
	# Remove previous segment
	if cur_segments[0] && segments[0] is Node:
		cur_segments[0].queue_free()
	
	# Remove the first element of the array
	cur_segments.pop_front()
	
	# Add a new segment at the end
	cur_segments += [_spawn_segment(cur_segments[cur_segments.size() - 1].end.global_transform.origin)]


# Helper to instantiate a new segment
func _spawn_segment(pos : Vector3, starting : bool = false):
	var rnd = round(rand_range(0, segments.size() - 1))
	var instance = segments[rnd].instance()
		
	instance.transform.origin = pos
	print(pos)
	instance.connect("end_reached", self, "_next_segment")
	game.call_deferred("add_child", instance)
	return instance


func _get_cur_segment():
	return cur_segments[1] if cur_segments && cur_segments.size() > 1 else null
