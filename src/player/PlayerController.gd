class_name Player
extends RigidBody

export(float) var lane_switch_time = .3

onready var game = $"/root/Game"
onready var tween : Tween = $Tween

var _cur_lane = 1 setget change_lane


func _ready():
	SwipeInput.connect("swipe", self, "_on_swipe")


func _on_swipe(dir : int):
	if dir == SwipeInput.SwipeDirection.RIGHT:
		_cur_lane += 1
	else:
		_cur_lane -= 1


func change_lane(target : int):
	if tween.is_active: return print("Failed to assign property cur_lane on node " + name + " because a lane change is already in progress")
	
	var cur_seg = game.segment_manager.cur_segment
	if target < 0 or target >= cur_seg.lanes_count:
		return
	
	var new_x = transform.origin.x + cur_seg.lane_width * sign(target - _cur_lane)
	tween.interpolate_property(self, "transform.origin.x", transform.origin.x, new_x, lane_switch_time, Tween.TRANS_LINEAR)
	tween.start()
	
	# Wait for the tween to be completed
	yield(tween, "tween_completed")
	_cur_lane = target
