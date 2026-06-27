from dataclasses import dataclass, field


@dataclass
class DirectorEvent:
    event_type: str
    source: str
    message: str = ""
    payload: dict = field(default_factory=dict)
