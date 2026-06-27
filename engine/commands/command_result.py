from dataclasses import dataclass, field


@dataclass
class CommandResult:

    success: bool
    message: str
    payload: dict = field(default_factory=dict)
