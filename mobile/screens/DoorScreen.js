import React from "react";
import { View, Text, Pressable } from "react-native";

export default function DoorScreen({ styles, onContinue }) {
  return (
    <View style={styles.screen}>
      <Text style={styles.houseTitle}>Knock... Knock...</Text>

      <View style={styles.houseCard}>
        <Text style={{ fontSize: 110, textAlign: "center" }}>🚪</Text>

        <Text style={styles.graceLine}>The door opens.</Text>

        <Text style={styles.graceLine}>
          Grace smiles and takes a sip of her wine.
        </Text>

        <Text style={styles.graceLine}>
          “Well hey there, honey.”
        </Text>

        <Pressable style={styles.button} onPress={onContinue}>
          <Text style={styles.buttonText}>Step Inside</Text>
        </Pressable>
      </View>
    </View>
  );
}
