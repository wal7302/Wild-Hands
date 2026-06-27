from engine.timeline.timeline_event import TimelineEvent


class EventTimeline:

    def __init__(self):
        self.events = []
        self.current_time = 0.0

    def add(self, event_type, source, message="", payload=None, delay=0.0):
        self.current_time += delay

        event = TimelineEvent(
            timestamp=round(self.current_time, 2),
            event_type=event_type,
            source=source,
            message=message,
            payload=payload or {},
        )

        self.events.append(event)

        return event

    def add_director_event(self, director_event, delay=0.0):
        return self.add(
            event_type=director_event.event_type,
            source=director_event.source,
            message=director_event.message,
            payload=director_event.payload,
            delay=delay,
        )

    def by_type(self, event_type):
        return [
            event
            for event in self.events
            if event.event_type == event_type
        ]

    def to_dict(self):
        return [
            {
                "timestamp": event.timestamp,
                "event_type": event.event_type,
                "source": event.source,
                "message": event.message,
                "payload": event.payload,
            }
            for event in self.events
        ]
