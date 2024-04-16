# X735

https://wiki.geekworm.com/X735

## これは何

Geekworm X735 V3.0 (V2.5) を制御する Raspberry Pi 用パッケージ。

X735基板上のボタン操作だけでなく、reboot や poweroff コマンドに対しても連動する。

FANは、PWM制御及び回転数計測に対応している。
DeviceTree overlay で cooling-fan を追加し、CPU温度に連動させる。

## ビルドPackage

```
dpkg-buildpackage -uc -us
```


## インストール

```
sudo dpkg -i x735_0.0.1_all.deb
sudo cp /usr/share/x735/x735-cooling-fan.dtbo /boot/firmware/overlays/
```

/boot/firmware/config.txt に下記を追記する。
```
dtoverlay=x735-cooling-fan
```

※Linuxバージョンによっては /boot/firmware/ でなく /boot/ の場合があるので、インストールする実機を確認すること。

## Hardware Interface

### Power Management

|40-pin|GPIO|dir|func|
|------|---|-|---|
|29|GPIO 5|X735 -> raspi|SHUTDOWN|
|32|GPIO 12|X735 <- raspi|BOOT|
|38|GPIO 20|X735 <- raspi|BUTTON|

* SHOTDOWN - X735 からの REBOOT/POWEROFF 要求信号
  * Highパルス幅が 200 ~ 600ms: reboot (LED 早点滅)
  * Highパルス幅が 600ms ~ : poweroff (LED 遅点滅)

* BOOT - X735 への 起動完了通知  
  起動完了したら High にする。
  X735 は 
  * reboot の場合: BOOT が Low -> High 変化でreboot完了と判断する（LED点滅が点灯に変わる）
  * poweroff の場合: BOOT が Low になるとシャットダウン完了と判断し、電源OFFする 

* BUTTON - Button押下  
基板上のSWを押すのと同じ。
  * High : Button Press
  * Low : Button Release


### Fan control

|40-pin|GPIO|dir|func|
|------|---|-|---|
|33|GPIO 13|X735 <- raspi|FAN PWM|
|36|GPIO 16|X735 -> raspi|FAN Tach (1回転2パルス)|
