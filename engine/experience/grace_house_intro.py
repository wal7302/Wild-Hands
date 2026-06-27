from engine.experience.scene import Scene


class GraceHouseIntro:

    @staticmethod
    def build():

        scene = Scene("Friday Night")

        scene.add("🏡 Grace's House")
        scene.add("")
        scene.add("Friday Night")
        scene.add("")
        scene.add("The porch light is on.")
        scene.add("You hear laughter inside.")
        scene.add("")
        scene.add("*Knock Knock*")
        scene.add("")
        scene.add("The door opens.")
        scene.add("")
        scene.add("Grace smiles.")
        scene.add("")
        scene.add('"Well hey there, honey."')
        scene.add("")
        scene.add('"Come on in."')
        scene.add("")
        scene.add("Fresh cookies are cooling on the counter.")
        scene.add("The fireplace glows softly.")
        scene.add("Country music plays quietly.")
        scene.add("")
        scene.add("A solid walnut table waits in the middle of the room.")
        scene.add("")
        scene.add("🍷 Grace takes a sip of wine.")
        scene.add("")
        scene.add('"Looks like everybody made it."')
        scene.add("")
        scene.add('"Let\'s play some cards."')

        return scene
