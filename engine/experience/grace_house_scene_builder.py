from engine.experience.house_builder import HouseBuilder
from engine.experience.scene_state import (
    AmbientState,
    SceneCharacterState,
    SceneObjectState,
    SceneState,
)


class GraceHouseSceneBuilder:

    @staticmethod
    def build_arrival_scene(house_state=None):

        house = house_state or HouseBuilder.default_friday_night()

        ambient = AmbientState(
            time_label=house.time_label,
            weather=house.weather,
            music=house.music,
            fireplace_on=house.fireplace_on,
            coffee_on=house.coffee_on,
        )

        characters = [
            SceneCharacterState(
                character_id="grace_lott",
                name="Grace Lott",
                animation="sip_wine",
                expression="warm_smile",
                dialogue="Well hey there, honey.",
                held_item="red_wine",
            )
        ]

        objects = [
            SceneObjectState(
                object_id="porch_light",
                name="Porch Light",
                location="front_porch",
                state="on",
            ),
            SceneObjectState(
                object_id="solid_walnut_table",
                name="Solid Walnut Table",
                location="game_room",
                state="waiting",
            ),
            SceneObjectState(
                object_id="cookie_plate",
                name=house.cookie_of_the_day,
                location="kitchen_counter",
                state="cooling",
            ),
            SceneObjectState(
                object_id="fireplace",
                name="Fireplace",
                location="game_room",
                state="lit" if house.fireplace_on else "off",
            ),
            SceneObjectState(
                object_id="coffee_pot",
                name="Coffee Pot",
                location="kitchen",
                state="brewing" if house.coffee_on else "off",
            ),
        ]

        narration = [
            "The porch light is on.",
            "You hear laughter inside.",
            "Knock...",
            "Knock...",
            "The door opens.",
            "Grace steps back from the doorway.",
            "Come on in.",
        ]

        return SceneState(
            scene_id="grace_house_arrival",
            title=house.name,
            ambient=ambient,
            characters=characters,
            objects=objects,
            narration=narration,
        )
