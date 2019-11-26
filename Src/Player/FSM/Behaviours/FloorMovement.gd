class_name FloorMovementBehavior
extends NestedFSMBehavior

# warning-ignore:unused_argument
func physics_process(delta):
	owner.global_transform.origin += owner.get_floor_velocity()
