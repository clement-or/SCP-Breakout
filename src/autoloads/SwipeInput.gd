extends Control

signal swipe(dir)

enum SwipeDirection {
	RIGHT, LEFT
}


var minimum_drag = 50 # pixels

var _swipe_start = null


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		_swipe_start = get_global_mouse_position()
	if event.is_action_released("click"):
		_calculate_swipe(get_global_mouse_position())


func _calculate_swipe(swipe_end):
	if _swipe_start == null: 
		return
	var swipe = swipe_end - _swipe_start
	
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			emit_signal("swipe", SwipeDirection.RIGHT)
		else:
			emit_signal("swipe", SwipeDirection.LEFT)
