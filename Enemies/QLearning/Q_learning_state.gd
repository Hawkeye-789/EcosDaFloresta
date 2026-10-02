extends Resource
class_name QLearnState

enum DistanceLevel { VERY_FAR, FAR, CLOSE, VERY_CLOSE }
enum ThreatLevel { NO_THREAT, THREAT }
enum PlayerDirection { RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT }
enum ThreatDirection { RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT, NONE }

@export var distance : DistanceLevel
@export var threat : ThreatLevel
@export var player_dir : PlayerDirection
@export var threat_dir : ThreatDirection

func get_index() -> int:
	return distance \
	+ DistanceLevel.size() * threat \
	+ DistanceLevel.size() * ThreatLevel.size() * player_dir \
	+ DistanceLevel.size() * ThreatLevel.size() * PlayerDirection.size() * threat_dir

static func get_size() -> int:
	return DistanceLevel.size() * ThreatLevel.size() * PlayerDirection.size() * ThreatDirection.size()
