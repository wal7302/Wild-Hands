from engine.experience.grace_house_scene_builder import GraceHouseSceneBuilder


scene = GraceHouseSceneBuilder.build_arrival_scene()

data = scene.to_dict()

assert data["scene_id"] == "grace_house_arrival"
assert data["title"] == "Grace's House"
assert data["ambient"]["music"] == "Soft country music"
assert data["characters"][0]["character_id"] == "grace_lott"
assert data["objects"][0]["object_id"] == "porch_light"

print("Scene state test passed.")
