from engine.hosts.host_library import HostLibrary


grace = HostLibrary.find("grace_lott")

assert grace is not None
assert grace.name == "Grace Lott"
assert grace.age == 44
assert grace.greeting() == "Looks like everyone's here, honey."
assert grace.signature_action == "Sips red wine"

print("Host test passed.")
