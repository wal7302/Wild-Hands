from engine.hosts.dialogue import DialogueContext
from engine.hosts.dialogue_service import DialogueService


line = DialogueService.choose_line(
    "grace_lott",
    DialogueContext.OPENING
)

assert line is not None

wild_line = DialogueService.choose_line(
    "grace_lott",
    DialogueContext.WILD_DISCARDED
)

assert wild_line == "...Honey."

print("Host dialogue test passed.")
