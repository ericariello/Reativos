/* event_driven.c */
#include "Arduino.h"
#include "event_driven.h"
#define maxTimers 2
#define maxButtons 2

//extern void init_event_driven();
//extern void button_changed(int buttonPin, int value);
//extern void timer_expired(int timerId);

static int button_is_pressed[maxButtons];
static int button_pins[maxButtons];
static int nextButton = 0;
static int timers[maxTimers];
static int timersRunning[maxTimers];
static int nextTimer = 0;
static int last_time = 0;

void button_listen(int pin)
{
  if (nextButton < maxButtons)
  {
    button_pins[nextButton] = pin;
    nextButton++;
  }
}

int timer_set(int ms)
{
  if (nextTimer < maxTimers) 
  {
    timers[nextTimer] = ms;
    timersRunning[nextTimer] = 0;
    nextTimer++;
    return nextTimer-1;
  }
  return -1;
}

void setup (void)
{
  init_event_driven();
}

static void checkButtonEvents()
{
  int n;
  for (n=0; n<nextButton; n++)
  {
    int button_input_pressed = digitalRead(button_pins[n]);
    if (button_is_pressed[n]!=button_input_pressed)
    {
      button_is_pressed[n] = button_input_pressed;
      button_changed(button_pins[n], button_is_pressed[n]);
    }
  }
}

static void checkTimerEvents ()
{
  int current_time = millis();
  int diff = current_time - last_time;
  int n;
  for (n=0; n<nextTimer; n++)
  {
    timersRunning[n] += diff;
    if (timersRunning[n]>=timers[n])
    {
      timersRunning[n] -= timers[n];
      timer_expired(n);
    }
  }
  last_time = current_time;
}

void loop (void)
{
   checkButtonEvents();
   checkTimerEvents();
}

