from engine.console.animation_renderer import AnimationRenderer


class SceneRenderer:

    @staticmethod
    def render(scene_state):

        print()
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print(f"🏡 {scene_state.title}")
        print(scene_state.ambient.time_label)
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()

        for line in scene_state.narration:
            print(line)

        print()

        for character in scene_state.characters:

            animation = AnimationRenderer.render(
                character.animation
            )

            if animation:
                print(animation)

            if character.dialogue:
                print()
                print(f'"{character.dialogue}"')
                print()

        print("Objects:")
        for obj in scene_state.objects:
            print(f"- {obj.name}: {obj.state}")
