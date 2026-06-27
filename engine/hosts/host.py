from dataclasses import dataclass, field


@dataclass
class Host:

    host_id: str
    name: str
    age: int
    accent: str
    signature_action: str
    home_role: str
    personality_traits: list[str] = field(default_factory=list)
    catchphrases: list[str] = field(default_factory=list)

    def greeting(self):
        if self.catchphrases:
            return self.catchphrases[0]

        return f"Welcome, honey."
