from engine.tutorial.tutorial_step import TutorialStep


class TutorialFlow:

    def __init__(self):

        self.steps = [
            TutorialStep(
                "welcome",
                "Welcome to Wild Hands",
                "Pull up a chair, honey. I’ll show you how this works.",
                "continue",
                "Great. Let’s deal you in.",
            ),
            TutorialStep(
                "draw_card",
                "Draw a Card",
                "Every turn starts by drawing one card from the deck.",
                "draw",
                "Nice. Now you have one extra card.",
            ),
            TutorialStep(
                "discard_card",
                "Discard a Card",
                "Now choose one card to discard.",
                "discard",
                "Good choice. Every turn ends with a discard.",
            ),
            TutorialStep(
                "wild_card",
                "Wild Cards",
                "The number of cards dealt decides what’s wild.",
                "observe",
                "Wild cards can stand in for whatever card you need.",
            ),
            TutorialStep(
                "melds",
                "Melds",
                "You’re trying to make sets or suited runs.",
                "observe",
                "That’s how you lower your score.",
            ),
            TutorialStep(
                "go_out",
                "Going Out",
                "When every card fits into a meld, you can go out.",
                "go_out",
                "That ends the round.",
            ),
        ]

        self.current_index = 0

    @property
    def current_step(self):
        return self.steps[self.current_index]

    def advance(self):
        if self.current_index < len(self.steps) - 1:
            self.current_index += 1
            return True

        return False

    def is_complete(self):
        return self.current_index >= len(self.steps) - 1
