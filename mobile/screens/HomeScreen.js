import React from "react";
import { View, Text, Pressable } from "react-native";

export default function HomeScreen({ styles, onEnter }) {

    return (

        <View style={styles.screen}>

            <Text style={styles.logo}>
                Wild Hands
            </Text>

            <Text style={styles.tagline}>
                Every Deal Changes the Game
            </Text>

            <View style={styles.houseCard}>

                <Text style={styles.houseTitle}>
                    🏡 Welcome to Grace's
                </Text>

                <Text style={styles.houseSub}>
                    Friday Evening
                </Text>

                <Text style={styles.graceLine}>
                    "Well hey there, honey."
                </Text>

                <Pressable
                    style={styles.button}
                    onPress={onEnter}
                >
                    <Text style={styles.buttonText}>
                        Come On In
                    </Text>

                </Pressable>

            </View>

        </View>

    );

}
