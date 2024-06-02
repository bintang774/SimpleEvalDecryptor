#!/bin/sh
# Simple Eval Decryptor
# Version: 240514
# Author: @fastbooteraselk
# If you find bugs or errors, you can report it to me (@fastbooteraselk) on the Telegram app

if ! env | grep bin.mt.plus >/dev/null 2>&1; then
echo ""
echo "Please run this script on the MT Manager app!"
echo ""
exit 1
fi

if [ ! -d "$(pwd)/.include" ]; then
echo ""
echo "ERROR: Directory '.include' isn't found in this directory."
echo ""
exit 1
fi

#include ".include/colors.h"
. $(pwd)/.include/colors.sh

print_menu() {
if [ ! "$(whoami)" = "root" ]; then
IS_ROOTED="No"
else
IS_ROOTED="Yes"
fi

clear
echo ""
echo -e "${green}${bold}=================================${end}"
echo -e "${green}${bold}=${end}   Welcome to eval Decryptor   ${green}${bold}=${end}"
echo -e "${green}${bold}=================================${end}"
if [ "$IS_ROOTED" = "No" ]; then
echo "Device: $(getprop ro.product.device)"
case "$(getprop ro.build.version.sdk)" in
    28)
        AV="9" ;;
    29)
        AV="10" ;;
    30)
        AV="11" ;;
    31) 
        AV="12" ;;
    32)
        AV="12L" ;;
    33)
        AV="13" ;;
    34)
        AV="14" ;;
    *)
        AV="<9" ;;
esac
else
echo "Device: $(cat /system/build.prop | grep ro.build.product= | cut -f 2 -d '=')"
case "$(cat /system/build.prop | grep ro.build.version.sdk= | cut -f 2 -d '=')" in
    28)
        AV="9" ;;
    29)
        AV="10" ;;
    30)
        AV="11" ;;
    31) 
        AV="12" ;;
    32)
        AV="12L" ;;
    33)
        AV="13" ;;
    34)
        AV="14" ;;
    *)
        AV="<9" ;;
esac
fi
echo "Android Version: ${AV}"
echo "Exec with root: ${IS_ROOTED}"
echo
echo -e " ${white}${bold}↓ Enter your script name ↓${end} "
echo ""
if [ "$IS_ROOTED" = "No" ]; then
echo -ne "$(getprop ro.product.device)@$(uname -n) ${red}»${end} "; read script
else
echo -n "$(cat /system/build.prop | grep ro.build.product= | cut -f 2 -d '=')@$(whoami) ${red}»${end} "; read script
fi

if [ ! -f "./$script" ]; then
echo -e "${red_bg}ERROR${end} File '$script' is Not found" && exit 1
fi

if cat ./$script | grep -i 'libc' >/dev/null 2>&1; then
echo -e "${red_bg}ERROR${end} ELF Binary isn't supported by the Decryptor." && exit 1
fi

if cat ./$script | grep '| base64 -d' >/dev/null 2>&1; then 
echo -e "${red_bg}ERROR${end} Base64 Encryption isn't supported by the Decryptor." && exit 1
fi
start_decryptor
}

start_decryptor() {
  # Main
  local count=0

  while true; do
    sleep 0.5

    if ! grep -m 1 -w -e 'z="' -e 'eval "' ./"$script" >/dev/null 2>&1; then
      echo ""
      echo -e "${green_bg}SUCCESS${end} Decrypted shell script '$script'."
      echo "Layer: $count"
      exit 0
    fi

    sed -i 's/eval/echo/g' ./"$script"

    if [ "$IS_ROOTED" = "Yes" ]; then
      su -c sh ./"$script" > ./"$script".tes
    else
      sh ./"$script" > ./"$script".tes
    fi

    mv ./"$script".tes ./"$script"

    ((count++))
  done
}
# Call menu function
print_menu