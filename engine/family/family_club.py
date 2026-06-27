from dataclasses import dataclass, field


class FamilyNamingStyle:

    DISPLAY_NAME = "display_name"
    REAL_FIRST_NAME = "real_first_name"
    NICKNAME = "nickname"


class FamilyRole:

    HOST = "host"
    CO_HOST = "co_host"
    REGULAR_GUEST = "regular_guest"
    HONORARY_GUEST = "honorary_guest"


@dataclass
class FamilyMember:

    player_id: str
    role: str = FamilyRole.REGULAR_GUEST


@dataclass
class FamilyClub:

    club_id: str
    name: str
    motto: str = "One more hand."
    naming_style: str = FamilyNamingStyle.DISPLAY_NAME
    welcome_sign: str = "Pull Up a Chair"
    table_theme: str = "Grandma's Kitchen"
    members: list[FamilyMember] = field(default_factory=list)

    def add_member(self, player_id, role=FamilyRole.REGULAR_GUEST):

        if self.has_member(player_id):
            return False

        self.members.append(
            FamilyMember(
                player_id=player_id,
                role=role
            )
        )

        return True

    def has_member(self, player_id):

        return any(
            member.player_id == player_id
            for member in self.members
        )

    def get_member_role(self, player_id):

        for member in self.members:
            if member.player_id == player_id:
                return member.role

        return None
