from dataclasses import dataclass, field


@dataclass
class SceneEvent:

    order: int
    text: str
    pause: float = 0.0


class Scene:

    def __init__(self, name):

        self.name = name
        self.events = []

    def add(self, text, pause=0.0):

        self.events.append(
            SceneEvent(
                len(self.events),
                text,
                pause
            )
        )
