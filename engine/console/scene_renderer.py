class SceneRenderer:

    @staticmethod
    def render(scene_state):

        print()
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print(f"🏡 {scene_state.title}")
        print(scene_state.ambient.time_label)
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()

        print("Ambient:")
        print(f"- Weather: {scene_state.ambient.weather}")
        print(f"- Music: {scene_state.ambient.music}")
        print(f"- Fireplace: {'on' if scene_state.ambient.fireplace_on else 'off'}")
        print(f"- Coffee: {'brewing' if scene_state.ambient.coffee_on else 'off'}")
        print()

        for line in scene_state.narration:
            print(line)

        print()

        for character in scene_state.characters:
            print(f"{character.name}:")
            if character.expression:
                print(f"  Expression: {character.expression}")
            if character.animation:
                print(f"  Animation: {character.animation}")
            if character.held_item:
                print(f"  Holding: {character.held_item}")
            if character.dialogue:
                print(f'  "{character.dialogue}"')

        print()

        print("Objects:")
        for obj in scene_state.objects:
            print(f"- {obj.name} @ {obj.location}: {obj.state}")
