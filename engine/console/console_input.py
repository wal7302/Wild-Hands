class ConsoleInput:

    @staticmethod
    def ask_discard_index():

        while True:
            raw = input("Choose card index to discard: ").strip()

            try:
                return int(raw)
            except ValueError:
                print("Please enter a valid number.")

    @staticmethod
    def ask_continue(prompt="Continue? y/n: "):

        value = input(prompt).lower().strip()

        return value == "y"
