#!/bin/bash
# by Rob-niX
#grabs your location then turns curl wttr.in result into a text weather report
wttr_to_txt_download() {
#    echo "...downloading a weather report for your area"

    # location grab from closest public IP address
    json_content=$(curl -s https://ipinfo.io/json)
    #extracts .city information from json file
    city_name=$(jq -r '.city' <<<"$json_content")
    # grabs the weather report using
    weather_report=$(curl -s wttr.in/$city_name\?format=2)
} && wttr_to_txt_download
#hot city for testing
#weather_report=$(curl -s wttr.in/Ouargla\?format=2)


#created a function so it can be refrenced by other aplications
wttr_auto_report() {
echo $weather_report
}


#echo $weather_emoji
#-------------------------
wttr_to_txt_report() {
    #pulls out the weather weather_emoji from the weather_report curl command.
    weather_emoji=${weather_report:0:1}
    weather_text=$"The weather today in $city_name"
    echo -n "$weather_text "

    case $weather_emoji in
    #sunny emoji
        ☀️)
        printf "has a likelyhood of being clear. "
        ;;
    #cloudy
        ☁️)
        printf "has a likelyhood of being cloudy. "
        ;;
    #partly cloudy
        ⛅️)
        printf "has a likelyhood of being partly cloudy. "
        ;;
    #mist/fog
        🌦)
        printf "has a likelyhood of being partly cloudy with rain. "
        ;;

        ⛈️)
        printf "may thunder and rain. "
        ;;
    #snow
        ❄️)
        printf "has a likelyhood of snowing. "
        ;;
    #heavy rain
        🌧️)
        printf "is condusive of heavy rain. "
        ;;
    #blizzard
        🌨️)
        printf "is condusive of a blizzard. "
        ;;
    #lightening
        🌩️)
        printf "is condusive of lightening. "
        ;;

        🌫)
        printf "is foggy. "
        ;;

        *)
        printf "is unusual. "
        ;;
    esac

    #after finding weather the next sentance for wind direction starts.
    #this needs to track the wind emoji, because the length of the $weather_report string changes depending on how hot it is
    printf "The wind is blowing from the "

    # defines emoji to track
    wind_emoji="🌬"
    # weather_report=$(curl -s wttr.in/$city_name\?format=2)
    #pulls the index of $wind emoji from $weather_report
    emoji_position=$(expr index "$weather_report" "wind_emoji")
    #offset=$("5")
    #echo "The character '$wind_emoji' is at position $emoji_position"

    #offsets the position of the wind emoji to find the arrow position
    wind_emoji_offset=$(( $emoji_position - 5 ))
    #uncomment to see the wind offset value
    #echo "offset for wind is $wind_emoji_offset"

    #pulls the wind emoji from the $weather_report.
    weather_direction=${weather_report:$wind_emoji_offset:1}
    #test output
    #echo $weather_direction

    #prints appropiate wind emoji to the screen
    case $weather_direction in
    #north
        ↑)
        printf "south, "
        ;;
    #north esat
        ↗)
        printf "south west, "
        ;;
    #east
        →)
        printf "west, "
        ;;
    #south east
        ↘)
        printf "north west, "
        ;;
    #south
        ↓)
        printf "north,"
        ;;
    #south west
        ↙)
        printf "north east,"
        ;;
    #west
        ←)
        printf "east,"
        ;;
    #south east
        ↖)
        printf "south east,"
        ;;
    #blowing from ya pants
        *)
        printf "your pants, "
        ;;
    esac

    #------------------------------------------------------
    #The weather today in Plymouth is foggy. The wind is blowing from the south east,
    printf "with a windspeed of; "

    #uses
    #wind_emoji="🌬"
    # weather_report=$(curl -s wttr.in/$city_name\?format=2)
    #pulls the index of $wind emoji from $weather_report
    #wind_emoji_offset=$(( $emoji_position - 5 ))
    letter_k_="k"

    #find the position of the letter k in $weather_report
    wind_speed_end_position=$(expr index "$weather_report" "letter_k")
    #emoji_position=$(expr index "$weather_report" "wind_emoji")
    #using the emoji position from earlier count -4 to find start of the windspeed
    wind_speed_start_offset=$(( $emoji_position - 4 ))
    #using the $wind_speed_end_position, count 1 space back to find the actual end point
    wind_speed_end_offset=$(( $wind_speed_end_position - 1 ))
    #subtract numbers to get length of string
    wind_speed_var_length=$(( $wind_speed_end_offset - $wind_speed_start_offset ))
    #the script needs this so the command line appears in the correct place!
    wind_speed=${weather_report:$wind_speed_start_offset:$wind_speed_var_length}


    #---------------------Kilometers Per Hour------------------------------
    #windspeed test echos
    #printf $wind_speed"km/h"
    #uncomment for both kmh or mph
    #printf " or, "

    #---------------------Miles Per Hour-----------------------------------
    #multiply km/h by 0.621371 to get mph
    mph_multiply=".621371"
    wind_speed_mph=$(echo "scale=3; $wind_speed*$mph_multiply" | bc)
    #wind_mph=$(( $wind_speed * $mph_multiply ))
    #echo $wind_speed_mph"mph"
    #this cuts the last numbers off but doesn't round anything. I think it's good enough for this aplication but,
    wind_speed_cut_mph=$(printf '%.1f\n' $wind_speed_mph)
    printf $wind_speed_cut_mph"mph"
    printf "\n"
} && wttr_to_txt_report
