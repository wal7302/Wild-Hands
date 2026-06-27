from dataclasses import dataclass, field


@dataclass
class AIPersonality:

    personality_id: str
    name: str
    difficulty: str
    description: str
    discard_risk: float = 0.0
    trash_talk_frequency: float = 0.0
    gift_frequency: float = 0.0
    phrases: list[str] = field(default_factory=list)
