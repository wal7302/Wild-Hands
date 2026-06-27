from dataclasses import dataclass, field


@dataclass
class AutomationResponse:

    source: str
    action: str
    message: str | None = None
    metadata: dict = field(default_factory=dict)
