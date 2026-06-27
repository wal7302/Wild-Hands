class DealerRotation:

    def __init__(self, dealers):

        self.dealers = dealers
        self.current_index = 0

    @property
    def current_dealer(self):

        return self.dealers[self.current_index]

    def rotate(self):

        self.current_index += 1

        if self.current_index >= len(self.dealers):
            self.current_index = 0

        return self.current_dealer
