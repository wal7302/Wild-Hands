import React, { useState } from "react";
import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View, Pressable } from "react-native";

const COLORS = {
  cranberry: "#7A1E2C",
  walnut: "#6B3F24",
  cream: "#F4E7D3",
  gold: "#D8A441",
  ink: "#2E1B12"
};

function HomeScreen({ onSitDown }) {
  return (
    <View style={styles.screen}>
      <Text style={styles.logo}>Wild Hands</Text>
      <Text style={styles.tagline}>Every Deal Changes the Game</Text>

      <View style={styles.houseCard}>
        <Text style={styles.houseTitle}>🏡 Grace's House</Text>
        <Text style={styles.houseSub}>Friday Evening</Text>

        <View style={styles.sceneBox}>
          <Text style={styles.sceneText}>🔥 Fireplace glowing</Text>
          <Text style={styles.sceneText}>🍪 Chocolate chip cookies cooling</Text>
          <Text style={styles.sceneText}>🍷 Grace sipping red wine</Text>
          <Text style={styles.sceneText}>🪵 Solid wood table waiting</Text>
        </View>

        <Text style={styles.graceLine}>
          “Looks like everyone’s here, honey.”
        </Text>

        <Pressable style={styles.button} onPress={onSitDown}>
          <Text style={styles.buttonText}>Sit Down</Text>
        </Pressable>
      </View>

      <StatusBar style="dark" />
    </View>
  );
}

function TableScreen({ onBack }) {
  return (
    <View style={styles.screen}>
      <Text style={styles.roomTitle}>Grace’s Game Room</Text>

      <View style={styles.table}>
        <Text style={styles.playerTop}>Grace</Text>
        <Text style={styles.deck}>🂠</Text>
        <Text style={styles.tableText}>Solid Wood Family Table</Text>
        <Text style={styles.playerBottom}>You</Text>
      </View>

      <Text style={styles.graceLine}>Grace shuffles the deck...</Text>

      <Pressable style={styles.secondaryButton} onPress={onBack}>
        <Text style={styles.secondaryButtonText}>Back to House</Text>
      </Pressable>
    </View>
  );
}

export default function App() {
  const [screen, setScreen] = useState("home");

  if (screen === "table") {
    return <TableScreen onBack={() => setScreen("home")} />;
  }

  return <HomeScreen onSitDown={() => setScreen("table")} />;
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
    fontWeight: "800",
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
    borderColor: COLORS.walnut,
    shadowColor: "#000",
    shadowOpacity: 0.18,
    shadowRadius: 12
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
  sceneBox: {
    backgroundColor: "#F7E0BD",
    borderRadius: 18,
    padding: 16,
    marginBottom: 18
  },
  sceneText: {
    fontSize: 16,
    marginBottom: 8,
    color: COLORS.ink
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
    fontWeight: "700"
  },
  secondaryButton: {
    borderColor: COLORS.cranberry,
    borderWidth: 2,
    borderRadius: 18,
    paddingVertical: 14,
    paddingHorizontal: 24
  },
  secondaryButtonText: {
    color: COLORS.cranberry,
    fontSize: 18,
    fontWeight: "700"
  },
  roomTitle: {
    fontSize: 30,
    fontWeight: "800",
    color: COLORS.cranberry,
    marginBottom: 24
  },
  table: {
    width: 330,
    height: 430,
    borderRadius: 180,
    backgroundColor: COLORS.walnut,
    borderWidth: 8,
    borderColor: "#3B2114",
    alignItems: "center",
    justifyContent: "space-around",
    padding: 30
  },
  tableText: {
    color: COLORS.cream,
    fontSize: 20,
    fontWeight: "700"
  },
  deck: {
    fontSize: 56
  },
  playerTop: {
    color: COLORS.gold,
    fontSize: 22,
    fontWeight: "800"
  },
  playerBottom: {
    color: COLORS.gold,
    fontSize: 22,
    fontWeight: "800"
  }
});
