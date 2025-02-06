class_name Utils
extends Object


static func async_scale_and_dissolve(target: Area2D, time: float = 0.3) -> void:
	var tw = target.create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(target, "scale", target.scale * 3, time)
	tw.tween_property(target, "modulate:a", 0, time)
	await tw.finished
