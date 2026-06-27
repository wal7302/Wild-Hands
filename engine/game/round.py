from engine.models.deck import Deck
from engine.game.turn import Turn
from engine.game.turn_state import TurnState
from engine.game.events import EventLog, GameEventType
from engine.social.table_talk import TableTalkLibrary
from engine.table.deal_sequence import DealSequence


class Round:

    def __init__(self, players, cards_dealt, dealer_name="Grace Lott"):

        self.players = players
        self.cards_dealt = cards_dealt
        self.wild_rank = cards_dealt
        self.dealer_name = dealer_name
        self.deck = Deck()
        self.deck.set_wild_rank(cards_dealt)
        self.discard_pile = []
        self.current_player_index = 0
        self.turn_count = 0
        self.finished = False
        self.events = EventLog()
        self.deal_sequence = DealSequence()
        self.turn_state = TurnState()

        self.events.add(
            GameEventType.ROUND_STARTED,
            message=f"Round {cards_dealt} started. {cards_dealt}s are wild."
        )

    def deal(self):

        for player in self.players:
            player.hand.clear()

        self.deal_sequence.shuffle(self.dealer_name)

        for _ in range(self.cards_dealt):

            for player in self.players:

                card = self.draw_from_deck()

                if card is not None:
                    player.draw(card)
                    self.deal_sequence.card_dealt(player.name, card)

        self.deal_sequence.wild_revealed(self.wild_rank)

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

        self.events.add(
            GameEventType.CARD_DISCARDED,
            player_name=self.current_player.name,
            message=f"{self.current_player.name} discarded {card.display}.",
            metadata={"card": card.display}
        )

        if card.is_wild:
            reactions = [
                phrase.text
                for phrase in TableTalkLibrary.wild_toss_reactions()
            ]

            self.events.add(
                GameEventType.WILD_DISCARDED,
                player_name=self.current_player.name,
                message=f"{self.current_player.name} discarded a wild!",
                metadata={"reactions": reactions}
            )

            self.events.add(
                GameEventType.TABLE_TALK_TRIGGERED,
                message="Wild Toss reactions unlocked temporarily.",
                metadata={"available_reactions": reactions}
            )

    def mark_player_went_out(self, player):

        self.finished = True

        self.events.add(
            GameEventType.PLAYER_WENT_OUT,
            player_name=player.name,
            message=f"{player.name} went out!"
        )

    def end_turn(self):

        self.turn_count += 1
        self.current_player_index += 1

        if self.current_player_index >= len(self.players):
            self.current_player_index = 0

        self.turn_state = TurnState()
