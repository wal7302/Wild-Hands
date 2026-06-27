class AnimationRenderer:

    ANIMATIONS = {
        "sip_wine": "🍷 Grace smiles and takes a sip of her wine.",
        "shuffle_cards": "🃏 Grace shuffles the deck.",
        "wave": "👋 Grace waves.",
        "laugh": "😂 Grace laughs.",
        "thinking": "🤔 Grace quietly studies the table.",
        "deal_cards": "🂠 Grace begins dealing the cards.",
        "raise_eyebrow": "🤨 Grace raises an eyebrow.",
        "smile": "😊 Grace smiles.",
    }

    @staticmethod
    def render(animation):
        return AnimationRenderer.ANIMATIONS.get(animation, "")
