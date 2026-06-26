from engine.models.deck import Deck
from engine.game.turn import Turn


class Round:

    def __init__(self, players, cards_dealt):

        self.players = players
        self.cards_dealt = cards_dealt
        self.wild_rank = cards_dealt
        self.deck = Deck()
        self.deck.set_wild_rank(cards_dealt)
        self.current_player_index = 0
        self.turn_count = 0
        self.finished = False

    def deal(self):

        for player in self.players:
            player.hand.clear()

        for _ in range(self.cards_dealt):

            for player in self.players:

                card = self.deck.draw()
                card.is_wild = card.rank == self.wild_rank
                player.draw(card)

    @property
    def current_player(self):

        return self.players[self.current_player_index]

    def start_turn(self):

        return Turn(self.current_player, self.deck)

    def end_turn(self):

        self.turn_count += 1
        self.current_player_index += 1

        if self.current_player_index >= len(self.players):
            self.current_player_index = 0
