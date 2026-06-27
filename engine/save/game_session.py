from dataclasses import dataclass, field
from datetime import datetime
import uuid


@dataclass
class GameSession:

    session_id: str = field(default_factory=lambda: str(uuid.uuid4()))

    family_name: str = "Default Family"

    started: datetime = field(default_factory=datetime.utcnow)

    completed: datetime | None = None

    players: list = field(default_factory=list)

    winner: str | None = None

    rounds: list = field(default_factory=list)

    statistics: dict = field(default_factory=dict)

    memories: list = field(default_factory=list)

    achievements: list = field(default_factory=list)

    replay: list = field(default_factory=list)
