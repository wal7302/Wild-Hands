import random

from engine.hosts.dialogue import HostDialogueLibrary


class DialogueService:

    @staticmethod
    def choose_line(host_id, context):

        lines = HostDialogueLibrary.lines_for(
            host_id,
            context
        )

        if not lines:
            return None

        return random.choice(lines).text
