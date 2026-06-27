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
  card: "#FFFDF7",
  feltShadow: "#24130B"
};

const PLAYERS = [
  { name: "Grace", seat: "top", emoji: "🍷" },
  { name: "Rico", seat: "left", emoji: "😈" },
  { name: "Nikki", seat: "right", emoji: "🕵️" },
  { name: "You", seat: "bottom", emoji: "🙂" }
];

const PLAYER_HAND = [
  { rank: "3", suit: "♥", wild: true },
  { rank: "7", suit: "♣", wild: false },
  { rank: "K", suit: "♦", wild: false }
];

function FlyingCard({ delay, finalX, finalY, rotate, face, showFace }) {
  const x = useRef(new Animated.Value(0)).current;
  const y = useRef(new Animated.Value(-120)).current;
  const opacity = useRef(new Animated.Value(0)).current;
  const scale = useRef(new Animated.Value(0.65)).current;

  React.useEffect(() => {
    const timer = setTimeout(() => {
      Animated.parallel([
        Animated.spring(x, { toValue: finalX, friction: 7, tension: 75, useNativeDriver: true }),
        Animated.spring(y, { toValue: finalY, friction: 7, tension: 75, useNativeDriver: true }),
        Animated.timing(opacity, { toValue: 1, duration: 180, useNativeDriver: true }),
        Animated.spring(scale, { toValue: 1, friction: 5, useNativeDriver: true })
      ]).start();
    }, delay);

    return () => clearTimeout(timer);
  }, [delay, finalX, finalY, opacity, scale, x, y]);

  return (
    <Animated.View
      style={[
        styles.card,
        {
          opacity,
          transform: [{ translateX: x }, { translateY: y }, { rotate }, { scale }]
        }
      ]}
    >
      {showFace ? (
        <>
          <Text style={[styles.cardCorner, face.suit === "♥" || face.suit === "♦" ? styles.redSuit : styles.blackSuit]}>
            {face.rank}
          </Text>
          <Text style={[styles.cardSuit, face.suit === "♥" || face.suit === "♦" ? styles.redSuit : styles.blackSuit]}>
            {face.suit}
          </Text>
          {face.wild && <Text style={styles.wildBadge}>WILD</Text>}
        </>
      ) : (
        <Text style={styles.cardBack}>◆</Text>
      )}
    </Animated.View>
  );
}

function Seat({ player, style }) {
  return (
    <View style={[styles.seat, style]}>
      <Text style={styles.seatEmoji}>{player.emoji}</Text>
      <Text style={styles.seatName}>{player.name}</Text>
    </View>
  );
}

function GiftBubble({ visible }) {
  if (!visible) return null;

  return (
    <View style={styles.giftBubble}>
      <Text style={styles.giftText}>🍪 Grace brought cookies!</Text>
    </View>
  );
}

function TableTalk({ visible }) {
  if (!visible) return null;

  return (
    <View style={styles.talkBubble}>
      <Text style={styles.talkText}>Rico: “You sure about that?”</Text>
    </View>
  );
}

function GameTable() {
  const [dealKey, setDealKey] = useState(0);
  const [showFace, setShowFace] = useState(false);
  const [giftVisible, setGiftVisible] = useState(false);
  const [talkVisible, setTalkVisible] = useState(false);

  function dealAgain() {
    setShowFace(false);
    setGiftVisible(false);
    setTalkVisible(false);
    setDealKey((value) => value + 1);

    setTimeout(() => setShowFace(true), 1300);
    setTimeout(() => setTalkVisible(true), 1700);
    setTimeout(() => setGiftVisible(true), 2200);
  }

  React.useEffect(() => {
    dealAgain();
  }, []);

  return (
    <View style={styles.screen}>
      <View style={styles.header}>
        <Text style={styles.logo}>Wild Hands</Text>
        <Text style={styles.tagline}>Friday Night at Grace’s</Text>
      </View>

      <View style={styles.room}>
        <Text style={styles.roomGlow}>🔥</Text>
        <Text style={styles.cookieTray}>🍪</Text>
        <Text style={styles.wineGlass}>🍷</Text>

        <View style={styles.tableWrap}>
          <View style={styles.table}>
            <Seat player={PLAYERS[0]} style={styles.topSeat} />
            <Seat player={PLAYERS[1]} style={styles.leftSeat} />
            <Seat player={PLAYERS[2]} style={styles.rightSeat} />
            <Seat player={PLAYERS[3]} style={styles.bottomSeat} />

            <View style={styles.deck}>
              <Text style={styles.deckText}>🂠</Text>
            </View>

            <View style={styles.wildMarker}>
              <Text style={styles.wildMarkerText}>3s WILD</Text>
            </View>

            <View style={styles.cardLayer} key={dealKey}>
              <FlyingCard delay={150} finalX={-82} finalY={148} rotate="-12deg" face={PLAYER_HAND[0]} showFace={showFace} />
              <FlyingCard delay={450} finalX={0} finalY={162} rotate="0deg" face={PLAYER_HAND[1]} showFace={showFace} />
              <FlyingCard delay={750} finalX={82} finalY={148} rotate="12deg" face={PLAYER_HAND[2]} showFace={showFace} />
            </View>

            <TableTalk visible={talkVisible} />
            <GiftBubble visible={giftVisible} />
          </View>
        </View>
      </View>

      <Text style={styles.graceLine}>“I’ll deal ’em one at a time, honey.”</Text>

      <View style={styles.controls}>
        <Pressable style={styles.button} onPress={dealAgain}>
          <Text style={styles.buttonText}>Deal Again</Text>
        </Pressable>

        <Pressable style={styles.secondaryButton} onPress={() => setShowFace(!showFace)}>
          <Text style={styles.secondaryButtonText}>Flip Cards</Text>
        </Pressable>
      </View>
    </View>
  );
}

export default function App() {
  return <GameTable />;
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: COLORS.cream,
    alignItems: "center",
    justifyContent: "center",
    padding: 16
  },
  header: {
    alignItems: "center",
    marginBottom: 10
  },
  logo: {
    fontSize: 42,
    fontWeight: "900",
    color: COLORS.cranberry
  },
  tagline: {
    fontSize: 16,
    color: COLORS.ink,
    marginTop: 2
  },
  room: {
    width: "100%",
    maxWidth: 430,
    minHeight: 560,
    alignItems: "center",
    justifyContent: "center",
    borderRadius: 32,
    backgroundColor: "#F7E0BD",
    borderWidth: 4,
    borderColor: COLORS.walnut,
    overflow: "hidden"
  },
  roomGlow: {
    position: "absolute",
    top: 18,
    left: 28,
    fontSize: 42
  },
  cookieTray: {
    position: "absolute",
    top: 28,
    right: 38,
    fontSize: 34
  },
  wineGlass: {
    position: "absolute",
    bottom: 30,
    right: 34,
    fontSize: 36
  },
  tableWrap: {
    shadowColor: "#000",
    shadowOpacity: 0.35,
    shadowRadius: 20,
    shadowOffset: { width: 0, height: 12 }
  },
  table: {
    width: 360,
    height: 480,
    borderRadius: 190,
    backgroundColor: COLORS.walnut,
    borderWidth: 12,
    borderColor: COLORS.walnutDark,
    alignItems: "center",
    justifyContent: "center",
    overflow: "hidden"
  },
  table: {
    width: 360,
    height: 480,
    borderRadius: 190,
    backgroundColor: COLORS.walnut,
    borderWidth: 12,
    borderColor: COLORS.walnutDark,
    alignItems: "center",
    justifyContent: "center",
    overflow: "hidden"
  },
  seat: {
    position: "absolute",
    alignItems: "center",
    backgroundColor: "rgba(244,231,211,0.18)",
    borderColor: COLORS.gold,
    borderWidth: 1,
    borderRadius: 16,
    paddingVertical: 5,
    paddingHorizontal: 10
  },
  topSeat: {
    top: 18
  },
  bottomSeat: {
    bottom: 18
  },
  leftSeat: {
    left: 14,
    top: 212
  },
  rightSeat: {
    right: 14,
    top: 212
  },
  seatEmoji: {
    fontSize: 22
  },
  seatName: {
    color: COLORS.gold,
    fontWeight: "900",
    fontSize: 14
  },
  deck: {
    position: "absolute",
    top: 152,
    width: 60,
    height: 84,
    borderRadius: 10,
    backgroundColor: COLORS.card,
    borderWidth: 3,
    borderColor: COLORS.cranberry,
    alignItems: "center",
    justifyContent: "center",
    shadowColor: "#000",
    shadowOpacity: 0.32,
    shadowRadius: 9
  },
  deckText: {
    fontSize: 38
  },
  wildMarker: {
    position: "absolute",
    top: 252,
    backgroundColor: COLORS.cranberryDark,
    paddingVertical: 8,
    paddingHorizontal: 18,
    borderRadius: 18,
    borderWidth: 2,
    borderColor: COLORS.gold
  },
  wildMarkerText: {
    color: COLORS.gold,
    fontSize: 18,
    fontWeight: "900"
  },
  cardLayer: {
    position: "absolute",
    top: 218,
    left: 180,
    width: 0,
    height: 0
  },
  card: {
    position: "absolute",
    width: 66,
    height: 94,
    marginLeft: -33,
    marginTop: -47,
    borderRadius: 11,
    backgroundColor: COLORS.card,
    borderWidth: 3,
    borderColor: COLORS.cranberry,
    alignItems: "center",
    justifyContent: "center",
    shadowColor: "#000",
    shadowOpacity: 0.28,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 5 }
  },
  cardBack: {
    color: COLORS.cranberry,
    fontSize: 34,
    fontWeight: "900"
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
  talkBubble: {
    position: "absolute",
    left: 54,
    top: 112,
    backgroundColor: COLORS.card,
    borderRadius: 14,
    padding: 9,
    borderWidth: 2,
    borderColor: COLORS.cranberry,
    maxWidth: 180
  },
  talkText: {
    color: COLORS.ink,
    fontSize: 13,
    fontWeight: "800"
  },
  giftBubble: {
    position: "absolute",
    right: 40,
    bottom: 102,
    backgroundColor: "#FFF8EC",
    borderRadius: 14,
    padding: 9,
    borderWidth: 2,
    borderColor: COLORS.gold
  },
  giftText: {
    color: COLORS.ink,
    fontWeight: "800"
  },
  graceLine: {
    fontSize: 17,
    fontStyle: "italic",
    color: COLORS.cranberry,
    textAlign: "center",
    marginVertical: 14
  },
  controls: {
    flexDirection: "row",
    gap: 10
  },
  button: {
    backgroundColor: COLORS.cranberry,
    borderRadius: 18,
    paddingVertical: 14,
    paddingHorizontal: 26
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
    paddingHorizontal: 22
  },
  secondaryButtonText: {
    color: COLORS.cranberry,
    fontSize: 18,
    fontWeight: "900"
  }
});
