/* event_driven_test */
#include "event_driven.h"
#define LED_PIN 13
#define BUT_PIN 2

#define LED_T1_PIN 1
#define LED_T2_PIN 0

static int led_timer_state = LOW;
static int led_timer2_state = LOW;

static int timerid1 = -1;
static int timerid2 = -1;

void button_changed (int pin, int value)
{
  digitalWrite(LED_PIN, value); 
}

void timer_expired (int timerId)
{
  if (timerId == timerid1)
  {
    led_timer_state = !led_timer_state;
    digitalWrite(LED_T1_PIN, led_timer_state);
  }
  else if (timerId == timerid2)
  {
    led_timer2_state = !led_timer2_state;
    digitalWrite(LED_T2_PIN, led_timer2_state);
  }
}

void init_event_driven ()
{
  pinMode(LED_PIN, OUTPUT);
  pinMode(LED_T1_PIN, OUTPUT);
  pinMode(LED_T2_PIN, OUTPUT);
  pinMode(BUT_PIN, INPUT);
  digitalWrite(LED_PIN, LOW);
  digitalWrite(LED_T1_PIN, LOW);
  digitalWrite(LED_T2_PIN, LOW);
  button_listen(BUT_PIN); 
  timerid1 = timer_set(2000);
  timerid2 = timer_set(5000);
}

