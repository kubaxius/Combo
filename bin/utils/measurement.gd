class_name MeasurementUtils extends Node

const pixels_per_meter = 25.


static func kmph_to_mps(kmph:float) -> float:
	return kmph * 5. / 18.


static func mps_to_pps(mps:float) -> float:
	return mps * pixels_per_meter


static func kmph_to_pps(kmph:float) -> float:
	return mps_to_pps(kmph_to_mps(kmph))


static func pps_to_mps(pps:float) -> float:
	return pps/pixels_per_meter


static func mps_to_kmph(mps:float) -> float:
	return mps * 18. / 5.


static func pps_to_kmph(pps:float) -> float:
	return mps_to_kmph(pps_to_mps(pps))
