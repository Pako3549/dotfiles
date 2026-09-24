#!/usr/bin/env bash

profile="$(/usr/bin/tuned-adm active | sed 's/^Current active profile: //')"

case "$1:$profile" in
    next:balanced-battery)
        sudo /usr/bin/tuned-adm profile balanced
        ;;

    next:balanced)
        sudo /usr/bin/tuned-adm profile powersave
        ;;

    next:powersave)
        sudo /usr/bin/tuned-adm profile balanced-battery
        ;;

    next:*)
        sudo /usr/bin/tuned-adm profile balanced-battery
        ;;

    *)
        case "$profile" in
            balanced-battery)
                echo "Balanced"
                ;;
            balanced)
                echo "Performance"
                ;;
            powersave)
                echo "Power Saver"
                ;;
            *)
                echo "Balanced"
                ;;
        esac
        ;;
esac