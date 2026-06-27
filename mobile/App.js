import React, { useState } from "react";
import { StyleSheet, Text, View, Pressable, ScrollView } from "react-native";

const suits = ["♥", "♦", "♣", "♠"];
const ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];

function buildDeck() {
  const deck = [];

  suits.forEach((suit) => {
    ranks.forEach((rank) => {
      deck.push({ id: `${rank}${suit}`, rank, suit });
    });
  });

  return deck.sort(() => Math.random() - 0.5);
}

function createInitialGame(round = 1) {
  const deck = buildDeck();
  const wildCard = deck.pop();

  return {
    deck,
    wildRank: wildCard.rank,
    wildCard,
    playerHand: deck.splice(-3),
    graceHand: deck.splice(-3),
    discardPile: [],
    round,
  };
}

function rankValue(rank) {
  const values = {
    A: 1,
    J: 11,
    Q: 12,
    K: 13,
  };

  return values[rank] || Number(rank);
}

function scoreValue(card, wildRank) {
  if (card.rank === wildRank) return 0;
  if (card.rank === "A") return 15;
  if (["J", "Q", "K"].includes(card.rank)) return 10;
  return Number(card.rank);
}

function canGoOut(hand, wildRank) {
  if (hand.length !== 3) return false;

  const naturalCards = hand.filter((card) => card.rank !== wildRank);

  if (naturalCards.length === 0) return true;

  const sameRank = naturalCards.every(
    (card) => card.rank === naturalCards[0].rank
  );

  if (sameRank) return true;

  const sameSuit = naturalCards.every(
    (card) => card.suit === naturalCards[0].suit
  );

  if (!sameSuit) return false;

  const values = naturalCards
    .map((card) => rankValue(card.rank))
    .sort((a, b) => a - b);

  for (let start = 1; start <= 11; start++) {
    const straight = [start, start + 1, start + 2];

    if (values.every((value) => straight.includes(value))) {
      return true;
    }
  }

  return false;
}

export default function App() {
  const initial = createInitialGame();

  const [deck, setDeck] = useState(initial.deck);
  const [wildRank, setWildRank] = useState(initial.wildRank);
  const [wildCard, setWildCard] = useState(initial.wildCard);
  const [playerHand, setPlayerHand] = useState(initial.playerHand);
  const [graceHand, setGraceHand] = useState(initial.graceHand);
  const [discardPile, setDiscardPile] = useState(initial.discardPile);
  const [selectedCard, setSelectedCard] = useState(null);
  const [currentTurn, setCurrentTurn] = useState("player");
  const [hasDrawn, setHasDrawn] = useState(false);
  const [discardDrawCardId, setDiscardDrawCardId] = useState(null);
  const [handsRevealed, setHandsRevealed] = useState(false);
  const [round, setRound] = useState(1);
  const [playerScore, setPlayerScore] = useState(0);
  const [graceScore, setGraceScore] = useState(0);
  const [message, setMessage] = useState("Dealer revealed the wild. Your turn.");

  function drawFromDeck() {
    if (currentTurn !== "player") return setMessage("Wait your turn.");
    if (hasDrawn) return setMessage("You already drew. Now discard.");
    if (deck.length === 0) return setMessage("Deck is empty.");

    const nextDeck = [...deck];
    const card = nextDeck.pop();

    setDeck(nextDeck);
    setPlayerHand([...playerHand, card]);
    setHasDrawn(true);
    setDiscardDrawCardId(null);
    setMessage("You drew from the deck. Now discard or go out.");
  }

  function takeDiscard() {
    if (currentTurn !== "player") return setMessage("Wait your turn.");
    if (hasDrawn) return setMessage("You already drew. Now discard.");
    if (discardPile.length === 0) return setMessage("No discarded card to take.");

    const nextDiscardPile = [...discardPile];
    const card = nextDiscardPile.pop();

    setDiscardPile(nextDiscardPile);
    setPlayerHand([...playerHand, card]);
    setHasDrawn(true);
    setDiscardDrawCardId(card.id);
    setMessage("You picked up the discard. You must keep that card this turn.");
  }

  function discardCard() {
    if (currentTurn !== "player") return setMessage("Wait your turn.");
    if (!hasDrawn) return setMessage("Draw before you discard.");
    if (!selectedCard) return setMessage("Pick a card first, honey.");

    if (selectedCard.id === discardDrawCardId) {
      return setMessage("You have to keep the card you picked up from discard.");
    }

    const nextHand = playerHand.filter((card) => card.id !== selectedCard.id);
    const nextDiscardPile = [...discardPile, selectedCard];

    setPlayerHand(nextHand);
    setDiscardPile(nextDiscardPile);
    setSelectedCard(null);
    setHasDrawn(false);
    setDiscardDrawCardId(null);
    setCurrentTurn("grace");
    setMessage("Card discarded. Grace is thinking.");

    setTimeout(() => graceTurn(deck, nextDiscardPile), 800);
  }

  function goOut() {
    if (currentTurn !== "player") return setMessage("Wait your turn.");
    if (!hasDrawn) return setMessage("Draw before you go out.");
    if (!selectedCard) return setMessage("Select the card you are discarding to go out.");

    if (selectedCard.id === discardDrawCardId) {
      return setMessage("You have to keep the card you picked up from discard.");
    }

    const revealedHand = playerHand.filter((card) => card.id !== selectedCard.id);

    if (!canGoOut(revealedHand, wildRank)) {
      setMessage("You need 3 of a kind or a same-suit straight to go out.");
      return;
    }

    const graceRoundScore = graceHand.reduce(
      (total, card) => total + scoreValue(card, wildRank),
      0
    );

    setPlayerHand(revealedHand);
    setDiscardPile([...discardPile, selectedCard]);
    setSelectedCard(null);
    setHasDrawn(false);
    setDiscardDrawCardId(null);
    setHandsRevealed(true);
    setGraceScore(graceScore + graceRoundScore);
    setCurrentTurn("roundOver");

    setMessage(`You went out! Grace scores ${graceRoundScore}.`);
  }

  function graceTurn(currentDeck, currentDiscardPile) {
    const nextDeck = [...currentDeck];
    let nextGraceHand = [...graceHand];

    if (nextDeck.length > 0) {
      nextGraceHand.push(nextDeck.pop());
    }

    const discardedCard = nextGraceHand.pop();

    setDeck(nextDeck);
    setGraceHand(nextGraceHand);

    if (discardedCard) {
      setDiscardPile([...currentDiscardPile, discardedCard]);
      setMessage("Grace discards. Your turn.");
    } else {
      setMessage("Grace passes. Your turn.");
    }

    setCurrentTurn("player");
  }

  function nextRound() {
    if (round >= 3) {
      setMessage("Game complete.");
      return;
    }

    const fresh = createInitialGame(round + 1);

    setDeck(fresh.deck);
    setWildRank(fresh.wildRank);
    setWildCard(fresh.wildCard);
    setPlayerHand(fresh.playerHand);
    setGraceHand(fresh.graceHand);
    setDiscardPile([]);
    setSelectedCard(null);
    setCurrentTurn("player");
    setHasDrawn(false);
    setDiscardDrawCardId(null);
    setHandsRevealed(false);
    setRound(round + 1);
    setMessage("Dealer revealed the wild. Your turn.");
  }

  function restartGame() {
    const fresh = createInitialGame(1);

    setDeck(fresh.deck);
    setWildRank(fresh.wildRank);
    setWildCard(fresh.wildCard);
    setPlayerHand(fresh.playerHand);
    setGraceHand(fresh.graceHand);
    setDiscardPile([]);
    setSelectedCard(null);
    setCurrentTurn("player");
    setHasDrawn(false);
    setDiscardDrawCardId(null);
    setHandsRevealed(false);
    setRound(1);
    setPlayerScore(0);
    setGraceScore(0);
    setMessage("Dealer revealed the wild. Your turn.");
  }

  function renderCard(card) {
    const selected = selectedCard?.id === card.id;
    const isWild = card.rank === wildRank;

    return (
      <Pressable
        key={card.id}
        onPress={() => setSelectedCard(card)}
        style={[styles.card, selected && styles.selectedCard]}
      >
        <Text style={styles.cardText}>
          {card.rank}
          {card.suit}
        </Text>
        {isWild && <Text style={styles.wildText}>WILD</Text>}
      </Pressable>
    );
  }

  const topDiscard = discardPile[discardPile.length - 1];

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Wild Hands</Text>
      <Text style={styles.subtitle}>Friday Night at Grace&apos;s</Text>

      <View style={styles.scoreRow}>
        <Text style={styles.scoreText}>You: {playerScore}</Text>
        <Text style={styles.scoreText}>Grace: {graceScore}</Text>
      </View>

      <Text style={styles.roundText}>Round {round} of 3</Text>

      <View style={styles.wildReveal}>
        <Text style={styles.wildRevealText}>
          Wild: {wildCard.rank}
          {wildCard.suit}
        </Text>
      </View>

      <View style={styles.table}>
        <Text style={styles.playerName}>Grace</Text>

        {handsRevealed ? (
          <View style={styles.revealedHand}>
            {graceHand.map((card) => (
              <Text key={card.id} style={styles.revealedCard}>
                {card.rank}
                {card.suit}
              </Text>
            ))}
          </View>
        ) : (
          <Text style={styles.graceInfo}>Cards: {graceHand.length}</Text>
        )}

        <View style={styles.centerRow}>
          <View style={styles.deck}>
            <Text style={styles.deckLabelLight}>Deck</Text>
            <Text style={styles.deckCount}>{deck.length}</Text>
          </View>

          <View style={styles.discard}>
            <Text style={styles.deckLabelDark}>Discard</Text>
            <Text style={styles.cardText}>
              {topDiscard ? `${topDiscard.rank}${topDiscard.suit}` : "—"}
            </Text>
          </View>
        </View>

        <Text style={styles.playerName}>You</Text>
      </View>

      <Text style={styles.message}>{message}</Text>

      <ScrollView horizontal style={styles.hand} contentContainerStyle={styles.handContent}>
        {playerHand.map(renderCard)}
      </ScrollView>

      <View style={styles.buttons}>
        <Pressable style={styles.button} onPress={drawFromDeck}>
          <Text style={styles.buttonText}>Draw Deck</Text>
        </Pressable>

        <Pressable style={styles.button} onPress={takeDiscard}>
          <Text style={styles.buttonText}>Take Discard</Text>
        </Pressable>

        <Pressable style={styles.button} onPress={discardCard}>
          <Text style={styles.buttonText}>Discard</Text>
        </Pressable>

        <Pressable style={styles.button} onPress={goOut}>
          <Text style={styles.buttonText}>Go Out</Text>
        </Pressable>
      </View>

      {currentTurn === "roundOver" && round < 3 && (
        <Pressable style={styles.smallButton} onPress={nextRound}>
          <Text style={styles.smallButtonText}>Next Round</Text>
        </Pressable>
      )}

      <Pressable style={styles.smallButton} onPress={restartGame}>
        <Text style={styles.smallButtonText}>Restart</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    minHeight: "100vh",
    width: "100%",
    backgroundColor: "#F4E7D3",
    alignItems: "center",
    paddingTop: 30,
  },
  title: {
    fontSize: 38,
    fontWeight: "bold",
    color: "#7A1E2C",
  },
  subtitle: {
    fontSize: 17,
    color: "#2E1B12",
    marginBottom: 8,
  },
  scoreRow: {
    flexDirection: "row",
    gap: 28,
    marginBottom: 4,
  },
  scoreText: {
    color: "#2E1B12",
    fontSize: 16,
    fontWeight: "bold",
  },
  roundText: {
    color: "#2E1B12",
    fontSize: 15,
    marginBottom: 6,
  },
  wildReveal: {
    backgroundColor: "#D8A441",
    paddingVertical: 6,
    paddingHorizontal: 18,
    borderRadius: 12,
    marginBottom: 8,
  },
  wildRevealText: {
    color: "#2E1B12",
    fontWeight: "bold",
    fontSize: 17,
  },
  table: {
    width: 330,
    height: 330,
    backgroundColor: "#6B3F24",
    borderRadius: 40,
    alignItems: "center",
    justifyContent: "space-around",
    padding: 16,
  },
  playerName: {
    fontSize: 22,
    color: "#D8A441",
    fontWeight: "bold",
  },
  graceInfo: {
    color: "#F4E7D3",
    fontSize: 16,
  },
  centerRow: {
    flexDirection: "row",
    gap: 25,
  },
  deck: {
    width: 80,
    height: 105,
    backgroundColor: "#7A1E2C",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  discard: {
    width: 80,
    height: 105,
    backgroundColor: "#FFF8EE",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  deckLabelLight: {
    color: "#F4E7D3",
    fontWeight: "bold",
  },
  deckLabelDark: {
    color: "#2E1B12",
    fontWeight: "bold",
  },
  deckCount: {
    color: "#F4E7D3",
    fontSize: 24,
    fontWeight: "bold",
  },
  message: {
    marginTop: 12,
    width: 330,
    textAlign: "center",
    color: "#7A1E2C",
    fontSize: 16,
    minHeight: 42,
  },
  hand: {
    height: 118,
    width: 390,
    maxWidth: "100%",
    flexGrow: 0,
    alignSelf: "center",
  },
  handContent: {
    flexGrow: 1,
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 10,
  },
  card: {
    width: 70,
    height: 100,
    backgroundColor: "#FFF8EE",
    borderRadius: 10,
    marginHorizontal: 6,
    alignItems: "center",
    justifyContent: "center",
    borderWidth: 2,
    borderColor: "#6B3F24",
  },
  selectedCard: {
    borderColor: "#D8A441",
    borderWidth: 5,
    transform: [{ translateY: -8 }],
  },
  cardText: {
    fontSize: 23,
    color: "#2E1B12",
    fontWeight: "bold",
  },
  wildText: {
    fontSize: 11,
    color: "#7A1E2C",
    fontWeight: "bold",
  },
  buttons: {
    flexDirection: "row",
    gap: 8,
    marginTop: 10,
    flexWrap: "wrap",
    justifyContent: "center",
    maxWidth: 380,
  },
  button: {
    backgroundColor: "#7A1E2C",
    paddingVertical: 11,
    paddingHorizontal: 14,
    borderRadius: 12,
  },
  buttonText: {
    color: "#F4E7D3",
    fontSize: 15,
    fontWeight: "bold",
  },
  smallButton: {
    backgroundColor: "#D8A441",
    paddingVertical: 9,
    paddingHorizontal: 18,
    borderRadius: 10,
    marginTop: 10,
  },
  smallButtonText: {
    color: "#2E1B12",
    fontWeight: "bold",
  },
  revealedHand: {
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    gap: 6,
    marginTop: 8,
  },
  revealedCard: {
    backgroundColor: "#FFF8EE",
    color: "#2E1B12",
    paddingVertical: 5,
    paddingHorizontal: 8,
    borderRadius: 6,
    fontWeight: "bold",
  },
});
