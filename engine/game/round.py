from engine.models.deck import Deck
from engine.game.turn import Turn


class Round:

    def __init__(self, players, cards_dealt):

        self.players = players
        self.cards_dealt = cards_dealt
        self.wild_rank = cards_dealt
        self.deck = Deck()
        self.deck.set_wild_rank(cards_dealt)
        self.discard_pile = []
        self.current_player_index = 0
        self.turn_count = 0
        self.finished = False

    def deal(self):

        for player in self.players:
            player.hand.clear()

        for _ in range(self.cards_dealt):

            for player in self.players:

                card = self.draw_from_deck()

                if card is not None:
                    player.draw(card)

    def draw_from_deck(self):

        card = self.deck.draw()

        if card is None:
            self.reshuffle_discard_into_deck()
            card = self.deck.draw()

        if card is not None:
            card.is_wild = card.rank == self.wild_rank

        return card

    def reshuffle_discard_into_deck(self):

        if not self.discard_pile:
            return

        self.deck.cards = self.discard_pile.copy()
        self.discard_pile.clear()
        self.deck.shuffle()
        self.deck.set_wild_rank(self.wild_rank)

    @property
    def current_player(self):

        return self.players[self.current_player_index]

    def start_turn(self):

        return Turn(self.current_player, self)

    def add_discard(self, card):

        self.discard_pile.append(card)

    def end_turn(self):

        self.turn_count += 1
        self.current_player_index += 1

        if self.current_player_index >= len(self.players):
            self.current_player_index = 0
