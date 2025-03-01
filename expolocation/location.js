import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, Alert } from 'react-native';
import MapView, { Marker } from 'react-native-maps';
import * as Location from 'expo-location';

const LocationScreen = () => {
  const [location, setLocation] = useState(null);
  
  useEffect(() => {
    console.log('location');
    (async () => {
      let { status } = await Location.requestForegroundPermissionsAsync();
      console.log('status1 =>', status)
      if (status !== 'granted') {
        Alert.alert('Permiso denegado', 'Se necesita acceso a la ubicación');
        return;
      }

      let currentLocation = await Location.getCurrentPositionAsync({});
      setLocation(currentLocation.coords);
    })();
  });

  return (
    <View style={styles.container}>
      {location ? (
        <MapView
          style={styles.map}
          initialRegion={{
            latitude: location.latitude,
            longitude: location.longitude,
            latitudeDelta: 0.01,
            longitudeDelta: 0.01,
          }}>
          <Marker
            coordinate={{ latitude: location.latitude, longitude: location.longitude }}
            title="Mi Ubicación"
            description="Aquí estoy"
          />
        </MapView>
      ) : (
        <Text>No se pudo obtener la ubicación</Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  map: {
    width: '100%',
    height: '100%',
  },
});

export default LocationScreen;
