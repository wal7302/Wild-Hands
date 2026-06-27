import React from "react";
import {
    View,
    Text,
    Pressable
} from "react-native";

export default function PorchScreen({

    styles,
    onContinue

}) {

    return (

        <View style={styles.screen}>

            <Text style={styles.houseTitle}>
                🏡 Grace's
            </Text>

            <Text style={styles.tagline}>
                Friday Evening
            </Text>

            <View style={styles.houseCard}>

                <Text
                    style={{
                        fontSize:120,
                        textAlign:"center"
                    }}
                >
                    🏡
                </Text>

                <Text
                    style={styles.graceLine}
                >
                    The porch light glows warmly.
                </Text>

                <Text
                    style={styles.graceLine}
                >
                    You hear laughter inside.
                </Text>

                <Pressable
                    style={styles.button}
                    onPress={onContinue}
                >
                    <Text
                        style={styles.buttonText}
                    >
                        Knock
                    </Text>

                </Pressable>

            </View>

        </View>

    );

}
