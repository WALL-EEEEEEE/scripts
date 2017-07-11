sudo VBoxManage modifyvm "MacOs" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff 
sudo VBoxManage setextradata "MacOs" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3" 
sudo VBoxManage setextradata "MacOs" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0" 
sudo VBoxManage setextradata "MacOs" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple" 
sudo VBoxManage setextradata "MacOs" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" 
sudo VBoxManage setextradata "MacOs" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1 
sudo vboxmanage setextradata "MacOs" CustomVideoMode1 1920x1080x32
