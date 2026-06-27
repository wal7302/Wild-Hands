import React, { useState } from "react";
import { StyleSheet, Text, View, Pressable, ScrollView } from "react-native";

const suits = ["♥", "♦", "♣", "♠"];
const ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];

function buildDeck() {
  const deck = [];
  suits.forEach((suit) => {
    ranks.forEach((rank) => {
      deck.push({ id: `${rank}${suit}`, rank, suit, wild: rank === "3" });
    });
  });
  return deck.sort(() => Math.random() - 0.5);
}

function createInitialGame() {
  const deck = buildDeck();
  return {
    deck,
    playerHand: deck.splice(-3),
    graceHand: deck.splice(-3),
    discardPile: [],
  };
}

export default function App() {
  const initial = createInitialGame();

  const [deck, setDeck] = useState(initial.deck);
  const [playerHand, setPlayerHand] = useState(initial.playerHand);
  const [graceHand, setGraceHand] = useState(initial.graceHand);
  const [discardPile, setDiscardPile] = useState(initial.discardPile);
  const [selectedCard, setSelectedCard] = useState(null);
  const [currentTurn, setCurrentTurn] = useState("player");
  const [hasDrawn, setHasDrawn] = useState(false);
  const [discardDrawCardId, setDiscardDrawCardId] = useState(null);
  const [round, setRound] = useState(1);
  const [message, setMessage] = useState("Your turn. Draw from deck or take discard.");

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
    setMessage("You drew from the deck. Now discard.");
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
    setMessage(selectedCard.wild ? "...Honey. You discarded a wild. Grace is thinking." : "Card discarded. Grace is thinking.");

    setTimeout(() => graceTurn(deck, nextDiscardPile), 800);
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
      setMessage("Grace discards. Your turn. Draw from deck or take discard.");
    } else {
      setMessage("Grace passes. Your turn.");
    }

    setCurrentTurn("player");
  }

  function restartGame() {
    const fresh = createInitialGame();
    setDeck(fresh.deck);
    setPlayerHand(fresh.playerHand);
    setGraceHand(fresh.graceHand);
    setDiscardPile([]);
    setSelectedCard(null);
    setCurrentTurn("player");
    setHasDrawn(false);
    setDiscardDrawCardId(null);
    setRound(1);
    setMessage("Your turn. Draw from deck or take discard.");
  }

  function renderCard(card) {
    const selected = selectedCard?.id === card.id;

    return (
      <Pressable
        key={card.id}
        onPress={() => setSelectedCard(card)}
        style={[styles.card, selected && styles.selectedCard]}
      >
        <Text style={styles.cardText}>{card.rank}{card.suit}</Text>
        {card.wild && <Text style={styles.wildText}>WILD</Text>}
      </Pressable>
    );
  }

  const topDiscard = discardPile[discardPile.length - 1];

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Wild Hands</Text>
      <Text style={styles.subtitle}>Friday Night at Grace&apos;s</Text>

      <View style={styles.table}>
        <Text style={styles.playerName}>Grace</Text>
        <Text style={styles.graceInfo}>Cards: {graceHand.length}</Text>

        <View style={styles.centerRow}>
          <View style={styles.deck}>
            <Text style={styles.deckLabel}>Deck</Text>
            <Text style={styles.deckCount}>{deck.length}</Text>
          </View>

          <View style={styles.discard}>
            <Text style={styles.deckLabel}>Discard</Text>
            <Text style={styles.cardText}>{topDiscard ? `${topDiscard.rank}${topDiscard.suit}` : "—"}</Text>
          </View>
        </View>

        <Text style={styles.wildRule}>3s are wild</Text>
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
      </View>

      <Pressable style={styles.smallButton} onPress={restartGame}>
        <Text style={styles.smallButtonText}>Restart</Text>
      </Pressable>

      <Text style={styles.roundText}>Round {round} of 3</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    minHeight: "100vh",
    width: "100%",
    backgroundColor: "#F4E7D3",
    alignItems: "center",
    paddingTop: 35,
  },
  title: {
    fontSize: 40,
    fontWeight: "bold",
    color: "#7A1E2C",
  },
  subtitle: {
    fontSize: 18,
    color: "#2E1B12",
    marginBottom: 12,
  },
  table: {
    width: 330,
    height: 360,
    backgroundColor: "#6B3F24",
    borderRadius: 40,
    alignItems: "center",
    justifyContent: "space-around",
    padding: 18,
  },
  playerName: {
    fontSize: 24,
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
    height: 110,
    backgroundColor: "#7A1E2C",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  discard: {
    width: 80,
    height: 110,
    backgroundColor: "#FFF8EE",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  deckLabel: {
    color: "#2E1B12",
    fontWeight: "bold",
  },
  deckCount: {
    color: "#F4E7D3",
    fontSize: 24,
    fontWeight: "bold",
  },
  wildRule: {
    color: "#F4E7D3",
    fontSize: 20,
  },
  message: {
    marginTop: 14,
    width: 330,
    textAlign: "center",
    color: "#7A1E2C",
    fontSize: 17,
    minHeight: 45,
  },
  hand: {
    height: 120,
    width: "100%",
    maxWidth: 390,
    flexGrow: 0,
  },
  handContent: {
    minWidth: "100%",
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
    fontSize: 24,
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
    marginTop: 12,
    flexWrap: "wrap",
    justifyContent: "center",
  },
  button: {
    backgroundColor: "#7A1E2C",
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 12,
  },
  buttonText: {
    color: "#F4E7D3",
    fontSize: 16,
    fontWeight: "bold",
  },
  smallButton: {
    backgroundColor: "#D8A441",
    paddingVertical: 9,
    paddingHorizontal: 18,
    borderRadius: 10,
    marginTop: 12,
  },
  smallButtonText: {
    color: "#2E1B12",
    fontWeight: "bold",
  },
  roundText: {
    marginTop: 8,
    color: "#2E1B12",
    fontSize: 16,
  },
});
