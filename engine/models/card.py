from dataclasses import dataclass
from enum import Enum
class Suit(Enum):
    HEARTS='H';DIAMONDS='D';CLUBS='C';SPADES='S'
@dataclass
class Card:
    rank:int
    suit:Suit
    wild:bool=False
