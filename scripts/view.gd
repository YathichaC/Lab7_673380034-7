extends Node3D  # View node

@export var target: Node3D  # Player
@export var camera_offset := Vector3(0.005, 3.993, -4.693)  # สูงขึ้น + ด้านหลัง

@onready var camera = $Camera

func _process(delta):
	if target:
		# หมุน offset ตามตัวละคร
		var rotated_offset = camera_offset.rotated(Vector3.UP, target.rotation.y)
		
		# คำนวณตำแหน่งกล้อง
		var desired_position = target.global_position + rotated_offset
		
		# ให้กล้องตามแบบ smooth
		camera.global_position = camera.global_position.lerp(desired_position, 8 * delta)
		
		# ให้กล้องมองไปที่ตัวละคร
		camera.look_at(target.global_position, Vector3.UP)
