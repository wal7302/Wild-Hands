from engine.tutorial.tutorial_flow import TutorialFlow


flow = TutorialFlow()

assert flow.current_step.step_id == "welcome"

flow.advance()

assert flow.current_step.step_id == "draw_card"

assert flow.current_step.required_action == "draw"

print("Tutorial flow test passed.")
