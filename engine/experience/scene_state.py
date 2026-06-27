from dataclasses import dataclass, field


@dataclass
class SceneCharacterState:
    character_id: str
    name: str
    animation: str | None = None
    expression: str | None = None
    dialogue: str | None = None
    held_item: str | None = None


@dataclass
class SceneObjectState:
    object_id: str
    name: str
    location: str
    state: str | None = None


@dataclass
class AmbientState:
    time_label: str
    weather: str
    music: str
    fireplace_on: bool = True
    coffee_on: bool = True


@dataclass
class SceneState:
    scene_id: str
    title: str
    ambient: AmbientState
    characters: list[SceneCharacterState] = field(default_factory=list)
    objects: list[SceneObjectState] = field(default_factory=list)
    narration: list[str] = field(default_factory=list)

    def to_dict(self):
        return {
            "scene_id": self.scene_id,
            "title": self.title,
            "ambient": self.ambient.__dict__,
            "characters": [
                character.__dict__
                for character in self.characters
            ],
            "objects": [
                obj.__dict__
                for obj in self.objects
            ],
            "narration": self.narration,
        }
