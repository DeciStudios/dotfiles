#!/bin/bash

# Replace with your own OpenWeather API key
API_KEY="817bc2ea9941b8d72d0f5656d3d19147"
CITY="Swindon,uk"

# Fetch weather data from OpenWeatherAPI
weather_data=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=metric")

# Extract necessary info using jq
temperature=$(echo $weather_data | jq -r '.main.temp')
weather_condition=$(echo $weather_data | jq -r '.weather[0].main')
icon_code=$(echo $weather_data | jq -r '.weather[0].icon')

# Map weather condition to Nerd Font icon
case $weather_condition in
  "Clear")
    icon="󰖨 "  # Clear sky
    ;;
  "Clouds")
    icon=" "  # Cloudy
    ;;
  "Rain")
    icon=" "  # Rain
    ;;
  "Snow")
    icon=" "  # Snow
    ;;
  "Thunderstorm")
    icon=" "  # Thunderstorm
    ;;
  "Drizzle")
    icon=" "  # Drizzle
    ;;
  "Haze")
    icon=" "  # Haze
    ;;
  "Mist")
    icon=" "  # Mist
    ;;
  *)
    icon=" "  # Default icon
    ;;
esac

# Print output: weather icon + temperature
echo "$icon"
