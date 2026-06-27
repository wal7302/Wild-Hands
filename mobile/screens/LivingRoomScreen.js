import React from "react";
import { View, Text, Pressable } from "react-native";

export default function LivingRoomScreen({ styles, onContinue }) {
  return (
    <View style={styles.screen}>
      <Text style={styles.roomTitle}>Grace’s Game Room</Text>

      <View style={styles.houseCard}>
        <Text style={{ fontSize: 70, textAlign: "center" }}>🔥 🍪 🍷</Text>

        <Text style={styles.sceneText}>The fireplace glows softly.</Text>
        <Text style={styles.sceneText}>Fresh cookies are on the counter.</Text>
        <Text style={styles.sceneText}>A solid wood table waits in the center.</Text>

        <Text style={styles.graceLine}>
          “Pick any seat, honey.”
        </Text>

        <Pressable style={styles.button} onPress={onContinue}>
          <Text style={styles.buttonText}>Go to Table</Text>
        </Pressable>
      </View>
    </View>
  );
}
