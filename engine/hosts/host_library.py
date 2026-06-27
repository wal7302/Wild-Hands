from engine.hosts.host import Host


class HostLibrary:

    GRACE_LOTT = Host(
        host_id="grace_lott",
        name="Grace Lott",
        age=44,
        accent="Southern",
        signature_action="Sips red wine",
        home_role="This is Grace's house.",
        personality_traits=[
            "always smiling",
            "welcoming",
            "playfully competitive",
            "bakes cookies",
            "plays cards",
        ],
        catchphrases=[
            "Looks like everyone's here, honey.",
            "Grab a seat. I just put the coffee on.",
            "Somebody better not throw away the wild tonight.",
            "...Honey.",
        ],
    )

    @staticmethod
    def default_host():
        return HostLibrary.GRACE_LOTT

    @staticmethod
    def all_hosts():
        return [
            HostLibrary.GRACE_LOTT
        ]

    @staticmethod
    def find(host_id):
        for host in HostLibrary.all_hosts():
            if host.host_id == host_id:
                return host

        return None
