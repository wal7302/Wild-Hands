class ProfileRegistry:

    def __init__(self):

        self.profiles_by_name = {}

    def add(self, profile):

        self.profiles_by_name[profile.display_name] = profile

    def get_by_display_name(self, display_name):

        return self.profiles_by_name.get(display_name)
