from engine.timeline.event_timeline import EventTimeline


class ReplayRecorder:

    def __init__(self):
        self.timeline = EventTimeline()

    def record_director_events(self, events):
        for event in events:
            delay = event.payload.get("delay", 0.0)
            self.timeline.add_director_event(event, delay=delay)

        return self.timeline

    def export(self):
        return self.timeline.to_dict()
