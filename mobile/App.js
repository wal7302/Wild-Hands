import React, { useRef, useState } from "react";
import { Animated, Pressable, StyleSheet, Text, View } from "react-native";

const COLORS = {
  cranberry: "#7A1E2C",
  walnut: "#6B3F24",
  cream: "#F4E7D3",
  gold: "#D8A441",
  ink: "#2E1B12",
  card: "#FFFDF7"
};

function Card({ delay, finalX, finalY, rotate }) {
  const x = useRef(new Animated.Value(0)).current;
  const y = useRef(new Animated.Value(-110)).current;
  const opacity = useRef(new Animated.Value(0)).current;
  const scale = useRef(new Animated.Value(0.7)).current;

  React.useEffect(() => {
    const timer = setTimeout(() => {
      Animated.parallel([
        Animated.spring(x, {
          toValue: finalX,
          friction: 7,
          tension: 70,
          useNativeDriver: true
        }),
        Animated.spring(y, {
          toValue: finalY,
          friction: 7,
          tension: 70,
          useNativeDriver: true
        }),
        Animated.timing(opacity, {
          toValue: 1,
          duration: 220,
          useNativeDriver: true
        }),
        Animated.spring(scale, {
          toValue: 1,
          friction: 5,
          useNativeDriver: true
        })
      ]).start();
    }, delay);

    return () => clearTimeout(timer);
  }, []);

  return (
    <Animated.View
      style={[
        styles.card,
        {
          opacity,
          transform: [
            { translateX: x },
            { translateY: y },
            { rotate },
            { scale }
          ]
        }
      ]}
    >
      <Text style={styles.cardBack}>◆</Text>
    </Animated.View>
  );
}

function GameTable() {
  const [dealKey, setDealKey] = useState(0);

  return (
    <View style={styles.screen}>
      <Text style={styles.logo}>Wild Hands</Text>

      <View style={styles.tableWrap}>
        <View style={styles.table}>
          <Text style={styles.grace}>🍷 Grace</Text>

          <View style={styles.deck}>
            <Text style={styles.deckText}>🂠</Text>
          </View>

          <Text style={styles.wildText}>3s are wild tonight</Text>

          <View style={styles.cardLayer} key={dealKey}>
            <Card delay={100} finalX={-72} finalY={105} rotate="-10deg" />
            <Card delay={420} finalX={0} finalY={118} rotate="0deg" />
            <Card delay={740} finalX={72} finalY={105} rotate="10deg" />
          </View>

          <Text style={styles.you}>You</Text>
        </View>
      </View>

      <Text style={styles.graceLine}>
        “I’ll deal ’em one at a time, honey.”
      </Text>

      <Pressable style={styles.button} onPress={() => setDealKey(dealKey + 1)}>
        <Text style={styles.buttonText}>Deal Again</Text>
      </Pressable>
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
    padding: 20
  },
  logo: {
    fontSize: 42,
    fontWeight: "900",
    color: COLORS.cranberry,
    marginBottom: 18
  },
  tableWrap: {
    shadowColor: "#000",
    shadowOpacity: 0.35,
    shadowRadius: 18,
    shadowOffset: { width: 0, height: 12 }
  },
  table: {
    width: 350,
    height: 500,
    borderRadius: 190,
    backgroundColor: COLORS.walnut,
    borderWidth: 10,
    borderColor: "#3B2114",
    alignItems: "center",
    justifyContent: "space-between",
    paddingVertical: 34,
    overflow: "hidden"
  },
  grace: {
    color: COLORS.gold,
    fontSize: 23,
    fontWeight: "900"
  },
  you: {
    color: COLORS.gold,
    fontSize: 24,
    fontWeight: "900"
  },
  deck: {
    position: "absolute",
    top: 165,
    width: 58,
    height: 78,
    borderRadius: 10,
    backgroundColor: COLORS.card,
    borderWidth: 3,
    borderColor: COLORS.cranberry,
    alignItems: "center",
    justifyContent: "center",
    shadowColor: "#000",
    shadowOpacity: 0.3,
    shadowRadius: 8
  },
  deckText: {
    fontSize: 38
  },
  wildText: {
    position: "absolute",
    top: 265,
    color: COLORS.cream,
    fontSize: 22,
    fontWeight: "900"
  },
  cardLayer: {
    position: "absolute",
    top: 225,
    left: 175,
    width: 0,
    height: 0
  },
  card: {
    position: "absolute",
    width: 62,
    height: 88,
    marginLeft: -31,
    marginTop: -44,
    borderRadius: 10,
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
    fontSize: 30,
    fontWeight: "900"
  },
  graceLine: {
    fontSize: 18,
    fontStyle: "italic",
    color: COLORS.cranberry,
    textAlign: "center",
    marginVertical: 18
  },
  button: {
    backgroundColor: COLORS.cranberry,
    borderRadius: 18,
    paddingVertical: 15,
    paddingHorizontal: 36
  },
  buttonText: {
    color: "white",
    fontSize: 20,
    fontWeight: "900"
  }
});
