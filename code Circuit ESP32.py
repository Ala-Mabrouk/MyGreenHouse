"""
MicroPython IoT Weather Station Example for Wokwi.com

To view the data:

1. Go to http://www.hivemq.com/demos/websocket-client/
2. Click "Connect"
3. Under Subscriptions, click "Add New Topic Subscription"
4. In the Topic field, type "wokwi-weather" then click "Subscribe"

Now click on the DHT22 sensor in the simulation,
change the temperature/humidity, and you should see
the message appear on the MQTT Broker, in the "Messages" pane.

Copyright (C) 2022, Uri Shaked

https://wokwi.com/arduino/projects/322577683855704658
"""

import network
import time
import machine
from machine import Pin ,PWM,SoftI2C
from lcd_api import LcdApi
from i2c_lcd import I2cLcd
import dht
import ujson
from umqtt.simple import MQTTClient
from time import sleep

 # MQTT Server Parameters
MQTT_CLIENT_ID = "micropython-weather-demo"
MQTT_BROKER    = "broker.hivemq.com"
MQTT_USER      = ""#"ISI_MCU_Project"
MQTT_PASSWORD  = ""#"STM32groupeISI"
MQTT_TOPIC     = "ISIariana/2ING2/my_GreenHouse/sensors"


# compounds declaration
sensor = dht.DHT22(Pin(15))
led=Pin(13,Pin.OUT)
  # servo (verin)
pwm = PWM(Pin(23))
pwm.freq(50)
  #lcd 
sdaPIN=machine.Pin(21)  #for ESP32
sclPIN=machine.Pin(19)

I2C_ADDR = 0x27
totalRows = 4
totalColumns = 20

#initializing the I2C method for ESP32
i2c = SoftI2C(scl=Pin(19), sda=Pin(21), freq=10000)  
lcd = I2cLcd(i2c, I2C_ADDR, totalRows, totalColumns)

I2C_ADDR = 0x27
totalRows = 4
totalColumns = 20

#initialisation of pins
led.value(1)
for position in range(5000,1000,-500):
  pwm.duty_u16(position)
   

#initialisation of variables
waterOn="true"
lightValue="true"
prev_Data = ""
prev_waterOn=""
prev_Light=""
strLight="ON"
strWater="ON"
# here we will treat all the comming info from user (light / run water)
def sub_cb(topic, msg):
  global prev_waterOn
  global prev_Light 
  global strLight 
  global strWater 
  global lightValue
  global waterOn
  res=msg.decode('UTF-8')# res= "water value|light value"
  info=res.split("|")# decomposing res 
  print(info)
  waterOn=info[0]
  lightValue=info[1]
  # water control
  if waterOn != prev_waterOn:
    if(waterOn=="true"):
      strWater="ON"
      for position in range(9000,1000,-50):
          pwm.duty_u16(position)
          sleep(0.01)      
    if(waterOn=="false"):
      strWater="OFF"
      for position in range(1000,9000,50):
          pwm.duty_u16(position)
          sleep(0.01)
    prev_waterOn=waterOn  

 # light control
  if(lightValue!=prev_Light):
    if(lightValue=="false"):
      strLight="OFF"
      led.value(0)
    if(lightValue=="true"):
      strLight="ON"
      led.value(1);
    prev_Light=lightValue   

  lcd.clear()
  lcd.putstr("my green house info:")
  lcd.putstr( "t: "+ str(sensor.temperature())+" H: "+str(sensor.humidity())+"     ") 
  lcd.putstr( "Light: "+strLight+"           " ) 
  lcd.putstr( "Water Van: "+strWater ) 


# connection to wifi
print("Connecting to WiFi", end="")
sta_if = network.WLAN(network.STA_IF)
sta_if.active(True)
sta_if.connect('Wokwi-GUEST', '')
while not sta_if.isconnected():
  print(".", end="")
  time.sleep(0.1)
print(" Connected to WiFi!")

# connection to wifi
print("Connecting to MQTT server... ", end="")
client = MQTTClient(MQTT_CLIENT_ID, MQTT_BROKER, user=MQTT_USER, password=MQTT_PASSWORD)
#setting client handler
client.set_callback(sub_cb)
client.connect()
print("Connected!")

#listennig for controllers values (water|light)
client.subscribe("ISIariana/2ING2/my_GreenHouse/Controllers")


lcd.putstr("my green house info:")
while True:
  
  #print("looking for controllers value ?")
  #reading controller if exists new values (subscribed )
  client.check_msg()

  # reading sensor values
  
  print("Measuring weather conditions... ", end="")
  sensor.measure() 
  message = ujson.dumps({
    "t": sensor.temperature(),
    "h": sensor.humidity(),
    "l": lightValue,
    "w": waterOn
  })
  
  if message != prev_Data:
    print("Updated!")
    print("Reporting to MQTT topic {}: {}".format(MQTT_TOPIC, message))
    client.publish(MQTT_TOPIC, message)
    prev_Data = message
    lcd.clear()
    lcd.putstr("my green house info:")
    lcd.putstr( "t: "+ str(sensor.temperature())+" H: "+str(sensor.humidity())+"     ") 
    lcd.putstr( "Light: "+strLight+"           " ) 
    lcd.putstr( "Water Van: "+strWater ) 

  else:
    print("No change")
  time.sleep(1)
 
 