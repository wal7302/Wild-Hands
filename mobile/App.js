import React, { useEffect, useRef, useState } from "react";
import { Animated, Pressable, StyleSheet, Text, View } from "react-native";
import { StatusBar } from "expo-status-bar";

const COLORS = {
  cranberry: "#7A1E2C",
  walnut: "#6B3F24",
  cream: "#F4E7D3",
  gold: "#D8A441",
  ink: "#2E1B12"
};

function FadeInView({ children }) {
  const fade = useRef(new Animated.Value(0)).current;
  const slide = useRef(new Animated.Value(20)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(fade, { toValue: 1, duration: 600, useNativeDriver: true }),
      Animated.timing(slide, { toValue: 0, duration: 600, useNativeDriver: true })
    ]).start();
  }, []);

  return (
    <Animated.View style={{ opacity: fade, transform: [{ translateY: slide }], width: "100%", alignItems: "center" }}>
      {children}
    </Animated.View>
  );
}

function HomeScreen({ onEnter }) {
  return (
    <View style={styles.screen}>
      <FadeInView>
        <Text style={styles.logo}>Wild Hands</Text>
        <Text style={styles.tagline}>Every Deal Changes the Game</Text>

        <View style={styles.houseCard}>
          <Text style={styles.houseTitle}>🏡 Welcome to Grace’s</Text>
          <Text style={styles.houseSub}>Friday Evening</Text>

          <Text style={styles.graceLine}>“Well hey there, honey.”</Text>

          <Pressable style={styles.button} onPress={onEnter}>
            <Text style={styles.buttonText}>🚪 Come On In</Text>
          </Pressable>
        </View>
      </FadeInView>
      <StatusBar style="dark" />
    </View>
  );
}

function PorchScreen({ onContinue }) {
  const knock = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.loop(
      Animated.sequence([
        Animated.timing(knock, { toValue: 1.08, duration: 250, useNativeDriver: true }),
        Animated.timing(knock, { toValue: 1, duration: 250, useNativeDriver: true })
      ]),
      { iterations: 3 }
    ).start();
  }, []);

  return (
    <View style={styles.screen}>
      <FadeInView>
        <Text style={styles.houseTitle}>Grace’s Front Porch</Text>
        <Animated.Text style={[styles.bigEmoji, { transform: [{ scale: knock }] }]}>🏡</Animated.Text>
        <Text style={styles.graceLine}>The porch light glows warmly.</Text>
        <Text style={styles.graceLine}>You hear laughter inside.</Text>

        <Pressable style={styles.button} onPress={onContinue}>
          <Text style={styles.buttonText}>Knock Knock</Text>
        </Pressable>
      </FadeInView>
    </View>
  );
}

function DoorScreen({ onContinue }) {
  const open = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(open, { toValue: 1, duration: 900, useNativeDriver: true }).start();
  }, []);

  const rotate = open.interpolate({
    inputRange: [0, 1],
    outputRange: ["0deg", "-12deg"]
  });

  return (
    <View style={styles.screen}>
      <FadeInView>
        <Text style={styles.houseTitle}>Knock... Knock...</Text>

        <Animated.Text style={[styles.bigEmoji, { transform: [{ rotate }] }]}>🚪</Animated.Text>

        <Text style={styles.graceLine}>The door opens.</Text>
        <Text style={styles.graceLine}>🍷 Grace smiles and takes a sip of wine.</Text>
        <Text style={styles.graceLine}>“Come on in.”</Text>

        <Pressable style={styles.button} onPress={onContinue}>
          <Text style={styles.buttonText}>Step Inside</Text>
        </Pressable>
      </FadeInView>
    </View>
  );
}

function LivingRoomScreen({ onContinue }) {
  return (
    <View style={styles.screen}>
      <FadeInView>
        <Text style={styles.roomTitle}>Grace’s Game Room</Text>
        <Text style={styles.bigEmoji}>🔥 🍪 🍷</Text>

        <View style={styles.houseCard}>
          <Text style={styles.sceneText}>The fireplace glows softly.</Text>
          <Text style={styles.sceneText}>Fresh cookies are on the counter.</Text>
          <Text style={styles.sceneText}>A solid wood table waits in the center.</Text>

          <Text style={styles.graceLine}>“Pick any seat, honey.”</Text>

          <Pressable style={styles.button} onPress={onContinue}>
            <Text style={styles.buttonText}>Go to Table</Text>
          </Pressable>
        </View>
      </FadeInView>
    </View>
  );
}

function DealtCard({ delay, label }) {
  const move = useRef(new Animated.Value(-80)).current;
  const fade = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    setTimeout(() => {
      Animated.parallel([
        Animated.timing(move, { toValue: 0, duration: 450, useNativeDriver: true }),
        Animated.timing(fade, { toValue: 1, duration: 450, useNativeDriver: true })
      ]).start();
    }, delay);
  }, []);

  return (
    <Animated.View style={[styles.card, { opacity: fade, transform: [{ translateY: move }] }]}>
      <Text style={styles.cardText}>{label}</Text>
    </Animated.View>
  );
}

function TableScreen({ onBack }) {
  return (
    <View style={styles.screen}>
      <Text style={styles.roomTitle}>The Table</Text>

      <View style={styles.table}>
        <Text style={styles.playerTop}>Grace</Text>
        <Text style={styles.deck}>🂠</Text>
        <Text style={styles.tableText}>3s are wild</Text>

        <View style={styles.hand}>
          <DealtCard delay={200} label="🂠" />
          <DealtCard delay={500} label="🂠" />
          <DealtCard delay={800} label="🂠" />
        </View>

        <Text style={styles.playerBottom}>You</Text>
      </View>

      <Text style={styles.graceLine}>Grace deals one card at a time...</Text>

      <Pressable style={styles.secondaryButton} onPress={onBack}>
        <Text style={styles.secondaryButtonText}>Back to House</Text>
      </Pressable>
    </View>
  );
}

export default function App() {
  const [screen, setScreen] = useState("home");

  if (screen === "porch") return <PorchScreen onContinue={() => setScreen("door")} />;
  if (screen === "door") return <DoorScreen onContinue={() => setScreen("living")} />;
  if (screen === "living") return <LivingRoomScreen onContinue={() => setScreen("table")} />;
  if (screen === "table") return <TableScreen onBack={() => setScreen("home")} />;

  return <HomeScreen onEnter={() => setScreen("porch")} />;
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: COLORS.cream,
    alignItems: "center",
    justifyContent: "center",
    padding: 24
  },
  logo: {
    fontSize: 46,
    fontWeight: "900",
    color: COLORS.cranberry,
    marginBottom: 8
  },
  tagline: {
    fontSize: 16,
    color: COLORS.ink,
    marginBottom: 28
  },
  houseCard: {
    width: "100%",
    maxWidth: 420,
    backgroundColor: "#FFF8EC",
    borderRadius: 28,
    padding: 24,
    borderWidth: 3,
    borderColor: COLORS.walnut
  },
  houseTitle: {
    fontSize: 28,
    fontWeight: "800",
    color: COLORS.walnut,
    textAlign: "center"
  },
  houseSub: {
    fontSize: 16,
    color: COLORS.ink,
    textAlign: "center",
    marginBottom: 18
  },
  sceneText: {
    fontSize: 16,
    marginBottom: 10,
    color: COLORS.ink,
    textAlign: "center"
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
    paddingVertical: 16,
    alignItems: "center"
  },
  buttonText: {
    color: "white",
    fontSize: 20,
    fontWeight: "800"
  },
  secondaryButton: {
    borderColor: COLORS.cranberry,
    borderWidth: 2,
    borderRadius: 18,
    paddingVertical: 14,
    paddingHorizontal: 24,
    marginTop: 20
  },
  secondaryButtonText: {
    color: COLORS.cranberry,
    fontSize: 18,
    fontWeight: "700"
  },
  roomTitle: {
    fontSize: 30,
    fontWeight: "900",
    color: COLORS.cranberry,
    marginBottom: 24
  },
  bigEmoji: {
    fontSize: 100,
    textAlign: "center",
    marginBottom: 20
  },
  table: {
    width: 340,
    height: 460,
    borderRadius: 190,
    backgroundColor: COLORS.walnut,
    borderWidth: 8,
    borderColor: "#3B2114",
    alignItems: "center",
    justifyContent: "space-around",
    padding: 28
  },
  tableText: {
    color: COLORS.cream,
    fontSize: 22,
    fontWeight: "900"
  },
  deck: {
    fontSize: 56
  },
  playerTop: {
    color: COLORS.gold,
    fontSize: 22,
    fontWeight: "900"
  },
  playerBottom: {
    color: COLORS.gold,
    fontSize: 22,
    fontWeight: "900"
  },
  hand: {
    flexDirection: "row",
    gap: 8
  },
  card: {
    width: 48,
    height: 68,
    backgroundColor: "#FFFDF7",
    borderRadius: 8,
    alignItems: "center",
    justifyContent: "center",
    borderWidth: 2,
    borderColor: COLORS.cranberry
  },
  cardText: {
    fontSize: 32
  }
});
