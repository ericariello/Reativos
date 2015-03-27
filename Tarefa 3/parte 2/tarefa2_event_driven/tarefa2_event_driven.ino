/* event_driven_test */
#include "event_driven.h"
#define LED_PIN 13
#define BUT1_PIN 3
#define BUT2_PIN 2

static int led_timer_state = HIGH;
static int led_time = 500;
static int timerid1 = -1;
static int timerid2 = -1;

static int teste_button_is_pressed[2];

void button_changed (int pin, int value)
{
  int index = -1;
  if (pin==BUT1_PIN)
  {
    index = 0;
  }
  else
  {
    index = 1;
  }
  teste_button_is_pressed[index] = value; 
  if (value==1 && teste_button_is_pressed[0]+teste_button_is_pressed[1]==1)
  {
    activate_timer(timerid2);
  }
}

static void teste_stop()
{
  while (true);
}

static void teste_speed_up()
{
  led_time/=2;
  change_timer(0, led_time);
}

static void teste_speed_down()
{
  led_time*=2;
  change_timer(0, led_time);
}

void timer_expired (int timerId)
{
  Serial.print("timer: ");
  Serial.print(timerId);
  Serial.print("\n");
  if (timerId == 0)
  {
    led_timer_state = !led_timer_state;
    digitalWrite(LED_PIN, led_timer_state);
  }
  else /*if (timerId==1)*/
  {
    deactivate_timer(1);
    if (teste_button_is_pressed[0]+teste_button_is_pressed[1]==2)
    {
      teste_stop();
    }
    else if (teste_button_is_pressed[0]==1)
    {
      teste_speed_up();
    }
    else if (teste_button_is_pressed[1]==1)
    {
      teste_speed_down();
    }
  }
}

void init_event_driven ()
{
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUT1_PIN, INPUT);
  pinMode(BUT2_PIN, INPUT);
  digitalWrite(LED_PIN, HIGH);
  button_listen(BUT1_PIN); 
  button_listen(BUT2_PIN);
  timerid1 = timer_set(500);
  timerid2 = timer_set(200);
  deactivate_timer(timerid2);
  Serial.begin(9600);
}

