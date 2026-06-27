from engine.room.game_room import GameRoom, RoomDecoration
from engine.room.table_library import TableLibrary


room = GameRoom(owner_profile_id="player_001")

table = TableLibrary.default_table()

assert table.name == "Solid Wood Family Table"
assert room.table_id == "solid_wood_family_table"

decoration = RoomDecoration(
    decoration_id="cookie_jar_pig",
    name="Pig Cookie Jar",
    category="kitchen",
    placement="shelf",
)

added = room.add_decoration(decoration)

assert added is True
assert room.has_decoration("cookie_jar_pig") is True
assert len(room.decorations_by_placement("shelf")) == 1

print("Game room test passed.")
