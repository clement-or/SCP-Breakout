class_name StateMachine
extends Node


enum ProcessTypes {
	PROCESS,
	PHYSICS,
}


export(ProcessTypes) var process_type = ProcessTypes.PROCESS


var active_state : String setget set_active_state

var _active_state : State
var _states : Dictionary = {}




func _ready():
	_create_states()


# Will be executed either in the physics or normal frame, depending on the chosen ProcessType
func _common_process(delta : float):
	if _active_state: _active_state.update()


# Automatically create states map from child nodes
func _create_states():
	for child in get_children():
		if child is State:
			_states[child.name] = State


func set_active_state(state : String):
	if _states.has(state):
		_active_state = _states[state] as State
		active_state = state
	else:
		push_error("No such state: " + state + " in " + name)




func _process(delta):
	if ProcessTypes.PROCESS:
		_common_process(delta)


func _physics_process(delta):
	if ProcessTypes.PHYSICS:
		_common_process(delta)
