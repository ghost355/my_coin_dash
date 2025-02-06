class_name Utils
extends Object


static func async_scale_and_dissolve(target: Area2D) -> void:
	var tw = target.create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(target, "scale", target.scale * 3, 0.2)
	tw.tween_property(target, "modulate:a", 0, 0.3)
	await tw.finished
