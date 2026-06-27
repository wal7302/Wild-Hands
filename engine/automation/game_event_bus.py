class GameEventBus:

    def __init__(self):
        self.listeners = {}

    def subscribe(self, event_type, listener):
        if event_type not in self.listeners:
            self.listeners[event_type] = []

        self.listeners[event_type].append(listener)

    def publish(self, event):
        listeners = self.listeners.get(event.event_type, [])

        responses = []

        for listener in listeners:
            response = listener.handle(event)

            if response:
                responses.append(response)

        return responses
