from engine.table.arrival import ArrivalSequence, ArrivalEventType


sequence = ArrivalSequence()

sequence.add_player("Tasha")
sequence.add_player("Grace")

greeting = sequence.host_greeting()

assert len(sequence.events) == 9
assert sequence.events[0].event_type == ArrivalEventType.KNOCK
assert greeting.message == "Looks like everyone's here, honey."

print("Arrival sequence test passed.")
