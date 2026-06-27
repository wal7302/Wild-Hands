from engine.models.player import Player
from engine.ai.basic_ai import BasicAI
from engine.ai.personality_library import PersonalityLibrary


class AIPlayer(Player):

    def __init__(self, name, personality="competitive_one"):
        super().__init__(name)

        self.personality_id = personality
        self.personality = PersonalityLibrary.find(personality)
        self.brain = BasicAI()

    def choose_discard_index(self):
        return self.brain.choose_discard_index(self)
