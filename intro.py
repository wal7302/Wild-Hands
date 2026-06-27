import time

from engine.experience.grace_house_intro import GraceHouseIntro


scene = GraceHouseIntro.build()

print()

for event in scene.events:

    print(event.text)

    time.sleep(0.6)
