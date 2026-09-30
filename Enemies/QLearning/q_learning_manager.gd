extends Node
class_name QLearnManager

const QTABLE_PATH := "res://q_table.json"

enum Actions { RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT }

var q_table : Array[Array] = []
var state_num : int
var action_num : int

func init_table() -> void:
	state_num = QLearnState.get_size()
	action_num = Actions.size()
	q_table.resize(state_num)
	for state in range(state_num):
		q_table[state] = []
		q_table[state].resize(action_num)
		for action in range(action_num):
			q_table[state][action] = 0.0
	
	var timer : Timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = 30.0
	timer.timeout.connect(save_q_table)
	call_deferred("add_child", timer)

func _ready() -> void:
	load_q_table()

func init_enemy(enemy : Enemy) -> void:
	if enemy is EnemyQLearning:
		for group in enemy.get_groups():
			if is_in_group(group):
				enemy.qlearn_manager = self

func get_action(state_index : int, epsilon : float) -> Actions:
	if randf() < epsilon:
		return Actions.values().pick_random()
	else:
		return get_best_action(state_index)

func get_best_action(state_index: int) -> Actions:
	var best_action : Actions = Actions.RIGHT
	var best_value : float = q_table[state_index][Actions.RIGHT]
	for action in range(action_num):
		if q_table[state_index][action] > best_value:
			best_value = q_table[state_index][action]
			best_action = action as Actions
		elif q_table[state_index][action] == best_action:
			if randf() < 0.5:
				best_value = q_table[state_index][action]
				best_action = action as Actions
	return best_action

func update_q_table(state_index: int, action: Actions, reward: float, next_state_index: int, learning_rate : float, discount_factor : float) -> void:
	var old_q : float = q_table[state_index][action]

	var next_best_q : float = q_table[next_state_index][0]

	for next_action in range(action_num):
		next_best_q = max(
			next_best_q,
			q_table[next_state_index][next_action]
		)

	var target : float = reward + discount_factor * next_best_q

	q_table[state_index][action] = old_q + \
		learning_rate * (target - old_q)

func update_q_table_final(state_index: int, action: Actions, reward: float, alpha: float) -> void:
	var old_value : float = q_table[state_index][action]
	q_table[state_index][action] = old_value + alpha * (reward - old_value)

func save_q_table() -> void:
	var file := FileAccess.open(QTABLE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Não foi possível salvar a Q-table.")
		return
	var data := {
		"state_num": state_num,
		"action_num": action_num,
		"q_table": q_table
	}
	file.store_string(JSON.stringify(data))
	file.close()

func load_q_table() -> void:
	if not FileAccess.file_exists(QTABLE_PATH):
		print("Nenhuma Q-table salva. Criando uma nova.")
		init_table()
		return
	var file := FileAccess.open(QTABLE_PATH, FileAccess.READ)
	if file == null:
		push_error("Não foi possível abrir a Q-table.")
		init_table()
		return
	var data : Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if data == null:
		push_error("Q-table inválida.")
		init_table()
		return
	state_num = data["state_num"]
	action_num = data["action_num"]
	q_table.clear()
	q_table.resize(state_num)
	for state in range(state_num):
		q_table[state] = []
		q_table[state].resize(action_num)
		for action in range(action_num):
			q_table[state][action] = float(data["q_table"][state][action])
