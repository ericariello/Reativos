/* event_driven.c */
#define maxTimers 2
#define maxButtons 2

int button_is_pressed[maxButtons];
int button_pins[maxButtons];
int nextButton = 0;

int timer_is_active[maxTimers];
int timers[maxTimers];
int timersRunning[maxTimers];
int nextTimer = 0;
int last_time = 0;

void button_changed(int pin, int value);
void timer_expired(void);
void init();

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
    timer_is_active[nextTimer] = 1;
    timers[nextTimer] = ms;
    timersRunning[nextTimer] = 0;
    nextTimer++;
    return nextTimer-1;
  }
  return -1;
}

void activate_timer(int timerId)
{
  if (timerId<nextTimer)
  {
      timer_is_active[timerId] = 1;
      timersRunning[timerId] = 0;
  }
}

void deactivate_timer(int timerId)
{
  if (timerId<nextTimer)
  {
      timer_is_active[timerId] = 0;
  }
}

void change_timer(int timerId, int time)
{
  if (timerId<nextTimer)
  {
      timers[timerId] = time;
  }
}

void setup (void)
{
  init_event_driven();
}

void checkButtonEvents()
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

void checkTimerEvents ()
{
  int current_time = millis();
  int diff = current_time - last_time;
  int n;
  for (n=0; n<nextTimer; n++)
  {
    if (timer_is_active[n])
    {
      timersRunning[n] += diff;
      if (timersRunning[n]>=timers[n])
      {
        timersRunning[n] %= timers[n];
        timer_expired(n);
      }
    }
  }
  last_time = current_time;
}

void loop (void)
{
   checkButtonEvents();
   checkTimerEvents();
}

/* event_driven_test */

#define LED_PIN 13
#define BUT1_PIN 3
#define BUT2_PIN 2

int led_timer_state = HIGH;
int led_time = 500;
int timerid1 = -1;
int timerid2 = -1;

int teste_button_is_pressed[2];

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

void teste_stop()
{
  while (true);
}

void teste_speed_up()
{
  led_time/=2;
  change_timer(0, led_time);
}

void teste_speed_down()
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

