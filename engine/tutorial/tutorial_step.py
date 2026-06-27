from dataclasses import dataclass


@dataclass
class TutorialStep:

    step_id: str
    title: str
    host_line: str
    required_action: str
    success_message: str
