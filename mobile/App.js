import React, { useRef, useState } from "react";
import { Animated, Pressable, StyleSheet, Text, View } from "react-native";

const COLORS = {
  cranberry: "#7A1E2C",
  cranberryDark: "#5E1420",
  walnut: "#6B3F24",
  walnutDark: "#3B2114",
  cream: "#F4E7D3",
  gold: "#D8A441",
  ink: "#2E1B12",
  card: "#FFFDF7"
};

const START_HAND = [
  { id: "c1", rank: "3", suit: "♥", wild: true },
  { id: "c2", rank: "7", suit: "♣", wild: false },
  { id: "c3", rank: "K", suit: "♦", wild: false }
];

const DRAW_PILE = [
  { id: "c4", rank: "8", suit: "♥", wild: false },
  { id: "c5", rank: "3", suit: "♠", wild: true },
  { id: "c6", rank: "Q", suit: "♣", wild: false }
];

function points(card) {
  if (card.wild) return 0;
  if (card.rank === "J") return 10;
  if (card.rank === "Q") return 11;
  if (card.rank === "K") return 12;
  if (card.rank === "A") return 13;
  return Number(card.rank);
}

function PlayingCard({ card, selected, onPress }) {
  return (
    <Pressable onPress={onPress}>
      <View style={[styles.card, selected && styles.selectedCard]}>
        <Text
          style={[
            styles.cardCorner,
            card.suit === "♥" || card.suit === "♦" ? styles.redSuit : styles.blackSuit
          ]}
        >
          {card.rank}
        </Text>

        <Text
          style={[
            styles.cardSuit,
            card.suit === "♥" || card.suit === "♦" ? styles.redSuit : styles.blackSuit
          ]}
        >
          {card.suit}
        </Text>

        {card.wild && <Text style={styles.wildBadge}>WILD</Text>}
      </View>
    </Pressable>
  );
}

export default function App() {
  const [hand, setHand] = useState(START_HAND);
  const [drawPile, setDrawPile] = useState(DRAW_PILE);
  const [discardPile, setDiscardPile] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [message, setMessage] = useState("Grace deals one card at a time.");

  const score = hand.reduce((total, card) => total + points(card), 0);

  function drawCard() {
    if (drawPile.length === 0) {
      setMessage("The draw pile is empty, honey.");
      return;
    }

    const [nextCard, ...remaining] = drawPile;

    setHand([...hand, nextCard]);
    setDrawPile(remaining);
    setMessage(`You drew ${nextCard.rank}${nextCard.suit}${nextCard.wild ? " — wild!" : "."}`);
  }

  function discardSelected() {
    if (!selectedId) {
      setMessage("Pick a card to discard first.");
      return;
    }

    const selectedCard = hand.find((card) => card.id === selectedId);

    setHand(hand.filter((card) => card.id !== selectedId));
    setDiscardPile([selectedCard, ...discardPile]);
    setSelectedId(null);

    if (selectedCard.wild) {
      setMessage("...Honey. You just threw away a wild.");
    } else {
      setMessage(`You discarded ${selectedCard.rank}${selectedCard.suit}.`);
    }
  }

  const topDiscard = discardPile[0];

  return (
    <View style={styles.screen}>
      <Text style={styles.logo}>Wild Hands</Text>
      <Text style={styles.tagline}>Friday Night at Grace’s</Text>

      <View style={styles.table}>
        <View style={styles.topRow}>
          <Text style={styles.playerName}>🍷 Grace</Text>
          <Text style={styles.playerName}>😈 Rico</Text>
          <Text style={styles.playerName}>🕵️ Nikki</Text>
        </View>

        <View style={styles.centerRow}>
          <View style={styles.deck}>
            <Text style={styles.deckText}>🂠</Text>
            <Text style={styles.deckLabel}>Draw</Text>
          </View>

          <View style={styles.wildMarker}>
            <Text style={styles.wildMarkerText}>3s WILD</Text>
          </View>

          <View style={styles.discard}>
            <Text style={styles.deckText}>
              {topDiscard ? `${topDiscard.rank}${topDiscard.suit}` : "—"}
            </Text>
            <Text style={styles.deckLabel}>Discard</Text>
          </View>
        </View>

        <Text style={styles.message}>“{message}”</Text>

        <View style={styles.hand}>
          {hand.map((card) => (
            <PlayingCard
              key={card.id}
              card={card}
              selected={selectedId === card.id}
              onPress={() => setSelectedId(selectedId === card.id ? null : card.id)}
            />
          ))}
        </View>

        <Text style={styles.playerBottom}>🙂 You</Text>
      </View>

      <View style={styles.scorePanel}>
        <Text style={styles.scoreText}>Current Score: {score}</Text>
        <Text style={styles.scoreSub}>Lower is better</Text>
      </View>

      <View style={styles.controls}>
        <Pressable style={styles.button} onPress={drawCard}>
          <Text style={styles.buttonText}>Draw</Text>
        </Pressable>

        <Pressable style={styles.secondaryButton} onPress={discardSelected}>
          <Text style={styles.secondaryButtonText}>Discard</Text>
        </Pressable>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: COLORS.cream,
    alignItems: "center",
    justifyContent: "center",
    padding: 14
  },
  logo: {
    fontSize: 38,
    fontWeight: "900",
    color: COLORS.cranberry
  },
  tagline: {
    fontSize: 15,
    color: COLORS.ink,
    marginBottom: 12
  },
  table: {
    width: "100%",
    maxWidth: 430,
    minHeight: 560,
    borderRadius: 34,
    backgroundColor: COLORS.walnut,
    borderWidth: 10,
    borderColor: COLORS.walnutDark,
    alignItems: "center",
    justifyContent: "space-between",
    padding: 18
  },
  topRow: {
    width: "100%",
    flexDirection: "row",
    justifyContent: "space-around"
  },
  playerName: {
    color: COLORS.gold,
    fontWeight: "900",
    fontSize: 15
  },
  centerRow: {
    width: "100%",
    flexDirection: "row",
    justifyContent: "space-around",
    alignItems: "center"
  },
  deck: {
    width: 72,
    height: 96,
    backgroundColor: COLORS.card,
    borderRadius: 12,
    borderWidth: 3,
    borderColor: COLORS.cranberry,
    alignItems: "center",
    justifyContent: "center"
  },
  discard: {
    width: 72,
    height: 96,
    backgroundColor: "#F7E0BD",
    borderRadius: 12,
    borderWidth: 3,
    borderColor: COLORS.gold,
    alignItems: "center",
    justifyContent: "center"
  },
  deckText: {
    fontSize: 32,
    fontWeight: "900",
    color: COLORS.cranberry
  },
  deckLabel: {
    fontSize: 12,
    fontWeight: "900",
    color: COLORS.ink
  },
  wildMarker: {
    backgroundColor: COLORS.cranberryDark,
    paddingVertical: 10,
    paddingHorizontal: 18,
    borderRadius: 20,
    borderWidth: 2,
    borderColor: COLORS.gold
  },
  wildMarkerText: {
    color: COLORS.gold,
    fontWeight: "900",
    fontSize: 16
  },
  message: {
    color: COLORS.cream,
    fontSize: 17,
    fontStyle: "italic",
    textAlign: "center",
    minHeight: 44
  },
  hand: {
    flexDirection: "row",
    gap: 8,
    justifyContent: "center",
    flexWrap: "wrap"
  },
  card: {
    width: 66,
    height: 94,
    borderRadius: 11,
    backgroundColor: COLORS.card,
    borderWidth: 3,
    borderColor: COLORS.cranberry,
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 6
  },
  selectedCard: {
    transform: [{ translateY: -18 }],
    borderColor: COLORS.gold,
    shadowColor: "#000",
    shadowOpacity: 0.35,
    shadowRadius: 10
  },
  cardCorner: {
    position: "absolute",
    top: 6,
    left: 7,
    fontSize: 18,
    fontWeight: "900"
  },
  cardSuit: {
    fontSize: 34,
    fontWeight: "900"
  },
  redSuit: {
    color: "#B21E35"
  },
  blackSuit: {
    color: "#1E1A18"
  },
  wildBadge: {
    position: "absolute",
    bottom: 6,
    fontSize: 10,
    fontWeight: "900",
    color: COLORS.gold,
    backgroundColor: COLORS.cranberry,
    borderRadius: 6,
    paddingHorizontal: 5,
    paddingVertical: 2
  },
  playerBottom: {
    color: COLORS.gold,
    fontSize: 22,
    fontWeight: "900"
  },
  scorePanel: {
    marginTop: 12,
    alignItems: "center"
  },
  scoreText: {
    color: COLORS.cranberry,
    fontSize: 20,
    fontWeight: "900"
  },
  scoreSub: {
    color: COLORS.ink,
    fontSize: 13
  },
  controls: {
    flexDirection: "row",
    gap: 10,
    marginTop: 12
  },
  button: {
    backgroundColor: COLORS.cranberry,
    borderRadius: 18,
    paddingVertical: 14,
    paddingHorizontal: 34
  },
  buttonText: {
    color: "white",
    fontSize: 18,
    fontWeight: "900"
  },
  secondaryButton: {
    borderColor: COLORS.cranberry,
    borderWidth: 2,
    borderRadius: 18,
    paddingVertical: 14,
    paddingHorizontal: 28
  },
  secondaryButtonText: {
    color: COLORS.cranberry,
    fontSize: 18,
    fontWeight: "900"
  }
});
