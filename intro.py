from engine.experience.grace_house_scene_builder import GraceHouseSceneBuilder
from engine.console.scene_renderer import SceneRenderer


scene = GraceHouseSceneBuilder.build_arrival_scene()

SceneRenderer.render(scene)
