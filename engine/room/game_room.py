from dataclasses import dataclass, field


@dataclass
class RoomDecoration:

    decoration_id: str
    name: str
    category: str
    placement: str


@dataclass
class GameRoom:

    owner_profile_id: str
    room_name: str = "My Game Room"
    table_id: str = "solid_wood_family_table"
    wall_color: str = "coffee_cream"
    accent_color: str = "grace_cranberry"
    decorations: list[RoomDecoration] = field(default_factory=list)

    def add_decoration(self, decoration):

        if self.has_decoration(decoration.decoration_id):
            return False

        self.decorations.append(decoration)

        return True

    def has_decoration(self, decoration_id):

        return any(
            decoration.decoration_id == decoration_id
            for decoration in self.decorations
        )

    def decorations_by_placement(self, placement):

        return [
            decoration
            for decoration in self.decorations
            if decoration.placement == placement
        ]
