from engine.models.player import Player
from engine.ai.basic_ai import BasicAI


class AIPlayer(Player):

    def __init__(self, name, personality="Basic"):
        super().__init__(name)

        self.personality = personality
        self.brain = BasicAI()

    def choose_discard_index(self):
        return self.brain.choose_discard_index(self)
