# get battery percentage of bluetooth devices
function get-blu-per() {
  local devices
  local name
  local percentage
  devices=$(bluetoothctl devices | cut -d " " -f 2)
  echo "$devices" | while IFS= read -r macaddress; do
    name=$(bluetoothctl info "$macaddress" | grep Name: | sed 's/Name: //' | sed 's/^[ \t]*//;s/[ \t]*$//')
    percentage=$(bluetoothctl info "$macaddress" | grep "Battery Percentage" | sed 's/.*(\([0-9]*\)).*/\1/')
    echo "$name => $percentage%"
  done
}
