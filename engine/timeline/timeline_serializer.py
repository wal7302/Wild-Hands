import json


class TimelineSerializer:

    @staticmethod
    def to_json(timeline):
        return json.dumps(
            timeline.to_dict(),
            indent=4
        )

    @staticmethod
    def save(filename, timeline):
        with open(filename, "w", encoding="utf-8") as file:
            file.write(
                TimelineSerializer.to_json(timeline)
            )
