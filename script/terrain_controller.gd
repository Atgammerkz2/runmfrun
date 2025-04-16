extends Node3D
class_name TerrainController

## Holds the catalog of loaded terrian block scenes
var TerrainBlocks: Array = []
## The set of terrian blocks which are currently rendered to viewport
var terrain_belt: Array[MeshInstance3D] = []
@export var terrain_velocity: float = 10.0
## The number of blocks to keep rendered to the viewport
@export var num_terrain_blocks = 4

# Substitua o @export_dir por um array de cenas pré-carregadas
@export var terrain_block_scenes: Array[PackedScene] = []

func _ready() -> void:
	# Verifica se há cenas carregadas via export
	if terrain_block_scenes.size() == 0:
		push_error("Nenhuma cena de terreno foi atribuída ao array terrain_block_scenes!")
		return
	
	TerrainBlocks = terrain_block_scenes
	_init_blocks(num_terrain_blocks)

# O resto do código permanece o mesmo...
func _physics_process(delta: float) -> void:
	_progress_terrain(delta)

func _init_blocks(number_of_blocks: int) -> void:
	for block_index in number_of_blocks:
		var block = TerrainBlocks.pick_random().instantiate()
		if block_index == 0:
			block.position.z = block.mesh.size.y/2
		else:
			_append_to_far_edge(terrain_belt[block_index-1], block)
		add_child(block)
		terrain_belt.append(block)

func _progress_terrain(delta: float) -> void:
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta

	if terrain_belt[0].position.z >= terrain_belt[0].mesh.size.y/2:
		var last_terrain = terrain_belt[-1]
		var first_terrain = terrain_belt.pop_front()

		var block = TerrainBlocks.pick_random().instantiate()
		_append_to_far_edge(last_terrain, block)
		add_child(block)
		terrain_belt.append(block)
		first_terrain.queue_free()

func _append_to_far_edge(target_block: MeshInstance3D, appending_block: MeshInstance3D) -> void:
	appending_block.position.z = target_block.position.z - target_block.mesh.size.y/2 - appending_block.mesh.size.y/2
