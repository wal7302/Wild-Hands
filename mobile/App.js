import React, { useState } from "react";
import { StyleSheet, Text, View, Pressable, ScrollView } from "react-native";

const suits = ["♥", "♦", "♣", "♠"];
const ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];

function buildDeck() {
  const deck = [];

  suits.forEach((suit) => {
    ranks.forEach((rank) => {
      deck.push({
        id: `${rank}${suit}`,
        rank,
        suit,
        wild: rank === "3",
      });
    });
  });

  return deck.sort(() => Math.random() - 0.5);
}

export default function App() {
  const [deck, setDeck] = useState(buildDeck());
  const [playerHand, setPlayerHand] = useState([]);
  const [graceHand, setGraceHand] = useState([]);
  const [discardPile, setDiscardPile] = useState([]);
  const [selectedCard, setSelectedCard] = useState(null);
  const [currentTurn, setCurrentTurn] = useState("player");
  const [hasDrawn, setHasDrawn] = useState(false);
  const [round, setRound] = useState(1);
  const [message, setMessage] = useState("Your turn. Draw a card.");

  function drawCard() {
    if (currentTurn !== "player") {
      setMessage("Wait your turn.");
      return;
    }

    if (hasDrawn) {
      setMessage("You already drew. Now discard.");
      return;
    }

    if (deck.length === 0) {
      setMessage("Deck is empty.");
      return;
    }

    const nextDeck = [...deck];
    const card = nextDeck.pop();

    setDeck(nextDeck);
    setPlayerHand([...playerHand, card]);
    setHasDrawn(true);
    setMessage("Choose a card to discard.");
  }

  function discardCard() {
    if (currentTurn !== "player") {
      setMessage("Wait your turn.");
      return;
    }

    if (!hasDrawn) {
      setMessage("Draw before you discard.");
      return;
    }

    if (!selectedCard) {
      setMessage("Pick a card first, honey.");
      return;
    }

    const nextHand = playerHand.filter((card) => card.id !== selectedCard.id);
    const nextDiscardPile = [...discardPile, selectedCard];

    setPlayerHand(nextHand);
    setDiscardPile(nextDiscardPile);
    setSelectedCard(null);
    setHasDrawn(false);
    setCurrentTurn("grace");

    if (selectedCard.wild) {
      setMessage("...Honey. You discarded a wild. Grace is thinking.");
    } else {
      setMessage("Card discarded. Grace is thinking.");
    }

    setTimeout(() => {
      graceTurn(nextDeckSafe(deck), nextDiscardPile);
    }, 900);
  }

  function nextDeckSafe(currentDeck) {
    return [...currentDeck];
  }

  function graceTurn(currentDeck, currentDiscardPile) {
    let nextDeck = [...currentDeck];
    let nextGraceHand = [...graceHand];

    if (nextDeck.length > 0) {
      const drawnCard = nextDeck.pop();
      nextGraceHand.push(drawnCard);
    }

    let discardedCard = null;

    if (nextGraceHand.length > 0) {
      discardedCard = nextGraceHand[nextGraceHand.length - 1];
      nextGraceHand = nextGraceHand.slice(0, -1);
    }

    setDeck(nextDeck);
    setGraceHand(nextGraceHand);

    if (discardedCard) {
      setDiscardPile([...currentDiscardPile, discardedCard]);
      setMessage("Grace discards. Your turn. Draw a card.");
    } else {
      setMessage("Grace passes. Your turn. Draw a card.");
    }

    setCurrentTurn("player");
  }

  function startNewRound() {
    setDeck(buildDeck());
    setPlayerHand([]);
    setGraceHand([]);
    setDiscardPile([]);
    setSelectedCard(null);
    setCurrentTurn("player");
    setHasDrawn(false);
    setRound(round + 1);
    setMessage("New round. Your turn. Draw a card.");
  }

  function restartGame() {
    setDeck(buildDeck());
    setPlayerHand([]);
    setGraceHand([]);
    setDiscardPile([]);
    setSelectedCard(null);
    setCurrentTurn("player");
    setHasDrawn(false);
    setRound(1);
    setMessage("Your turn. Draw a card.");
  }

  function renderCard(card) {
    const selected = selectedCard?.id === card.id;

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
            <Text style={styles.deckText}>Deck</Text>
            <Text style={styles.deckCount}>{deck.length}</Text>
          </View>

          <View style={styles.discard}>
            <Text style={styles.deckText}>Discard</Text>
            <Text style={styles.cardText}>
              {topDiscard ? `${topDiscard.rank}${topDiscard.suit}` : "—"}
            </Text>
          </View>
        </View>

        <Text style={styles.wildRule}>3s are wild</Text>
        <Text style={styles.playerName}>You</Text>
      </View>

      <Text style={styles.message}>{message}</Text>

      <ScrollView horizontal style={styles.hand}>
        {playerHand.map(renderCard)}
      </ScrollView>

      <View style={styles.buttons}>
        <Pressable style={styles.button} onPress={drawCard}>
          <Text style={styles.buttonText}>Draw</Text>
        </Pressable>

        <Pressable style={styles.button} onPress={discardCard}>
          <Text style={styles.buttonText}>Discard</Text>
        </Pressable>
      </View>

      <View style={styles.footerButtons}>
        <Pressable style={styles.smallButton} onPress={startNewRound}>
          <Text style={styles.smallButtonText}>New Round</Text>
        </Pressable>

        <Pressable style={styles.smallButton} onPress={restartGame}>
          <Text style={styles.smallButtonText}>Restart</Text>
        </Pressable>
      </View>

      <Text style={styles.roundText}>Round {round} of 3</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#F4E7D3",
    alignItems: "center",
    paddingTop: 45,
  },
  title: {
    fontSize: 40,
    fontWeight: "bold",
    color: "#7A1E2C",
  },
  subtitle: {
    fontSize: 18,
    color: "#2E1B12",
    marginBottom: 15,
  },
  table: {
    width: 330,
    height: 390,
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
    backgroundColor: "#F4E7D3",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
  },
  deckText: {
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
    marginTop: 18,
    width: 330,
    textAlign: "center",
    color: "#7A1E2C",
    fontSize: 18,
    minHeight: 50,
  },
  hand: {
    maxHeight: 120,
    marginTop: 10,
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
    gap: 14,
    marginTop: 18,
  },
  button: {
    backgroundColor: "#7A1E2C",
    paddingVertical: 13,
    paddingHorizontal: 30,
    borderRadius: 12,
  },
  buttonText: {
    color: "#F4E7D3",
    fontSize: 18,
    fontWeight: "bold",
  },
  footerButtons: {
    flexDirection: "row",
    gap: 12,
    marginTop: 14,
  },
  smallButton: {
    backgroundColor: "#D8A441",
    paddingVertical: 9,
    paddingHorizontal: 18,
    borderRadius: 10,
  },
  smallButtonText: {
    color: "#2E1B12",
    fontWeight: "bold",
  },
  roundText: {
    marginTop: 10,
    color: "#2E1B12",
    fontSize: 16,
  },
});
