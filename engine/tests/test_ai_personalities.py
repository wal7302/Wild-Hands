from engine.ai.personality_library import PersonalityLibrary
from engine.ai.ai_player import AIPlayer


trash_talker = PersonalityLibrary.find("trash_talker")

assert trash_talker is not None
assert trash_talker.name == "The Trash Talker"
assert trash_talker.trash_talk_frequency > 0

ai = AIPlayer("Nikki", personality="sneaky_one")

assert ai.personality.name == "The Sneaky One"

print("AI personality tests passed.")
