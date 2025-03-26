class_name ItemConfig

enum Keys {
	Plant,
	Stick,
	Stone
}

const ITEM_RESOURCE_PATHS = {
	Keys.Plant : "res://resources/item_resources/plant_resource.tres",
	Keys.Stick : "res://resources/item_resources/stick_resource.tres",
	Keys.Stone : "res://resources/item_resources/stone_resource.tres"
}

static func get_item_resource(key : Keys) -> ItemResource:
	return load(ITEM_RESOURCE_PATHS.get(key))
