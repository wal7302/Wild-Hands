from dataclasses import dataclass, field
from datetime import datetime


@dataclass
class TimelineEvent:
    timestamp: float
    event_type: str
    source: str
    message: str = ""
    payload: dict = field(default_factory=dict)
    created_at: datetime = field(default_factory=datetime.now)
