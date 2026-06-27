from engine.ai.ai_player import AIPlayer


ai = AIPlayer("Rico", personality="trash_talker")

phrase = ai.choose_phrase()

assert phrase in ai.personality.phrases

print("AI table talk test passed.")
