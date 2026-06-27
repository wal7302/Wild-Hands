from engine.experience.scene import Scene
from engine.experience.house_builder import HouseBuilder


class GraceHouseIntro:

    @staticmethod
    def build(house_state=None):

        house = house_state or HouseBuilder.default_friday_night()

        scene = Scene(house.time_label)

        scene.add("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        scene.add(f"🏡 {house.name}")
        scene.add("")
        scene.add(house.time_label)
        scene.add("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        scene.add("")

        for detail in house.sensory_details():
            scene.add(detail)
            scene.add("")

        scene.add("Knock...")
        scene.add("Knock...")
        scene.add("")
        scene.add("The door opens.")
        scene.add("")
        scene.add("🍷 Grace smiles.")
        scene.add("")
        scene.add('"Well hey there, honey."')
        scene.add("")
        scene.add("She steps back from the doorway.")
        scene.add("")
        scene.add('"Come on in."')
        scene.add("")
        scene.add("A solid walnut table waits in the middle of the room.")
        scene.add("")
        scene.add("Grace takes a sip of wine.")
        scene.add("")
        scene.add('"Looks like everybody made it."')
        scene.add("")
        scene.add('"Let\'s play some cards."')

        return scene
