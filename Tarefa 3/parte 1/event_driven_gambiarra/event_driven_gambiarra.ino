/* event_driven.c */
#define maxTimers 2 /* numero maximo de timers */
#define maxButtons 2 /* numero maximo de botoes */

int button_is_pressed[maxButtons]; /* indica se os botoes estao pressionados */
int button_pins[maxButtons]; /* pinos nos quais se encontram os botoes */
int nextButton = 0; /* indice do proximo botao */
int timers[maxTimers]; /* tempo de timeout dos timers */
int timersRunning[maxTimers]; /* tempo de execucao do timer */
int nextTimer = 0; /* indice do proximo timer */
int last_time = 0; /* ultimo tempo capturado */

/* registra o listener de um botao se ainda houver espaço no buffer */
void button_listen(int pin)
{
  if (nextButton < maxButtons)
  {
    button_pins[nextButton] = pin;
    nextButton++;
  }
}

/* registra listener de timer se ainda houve espaço no buffer */
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

/* inicializaçao */
void setup (void)
{
  init_event_driven();
}

/* checa se algum dos botoes mudou de estado */
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

/* checa se algum dos timers estourou */
void checkTimerEvents ()
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

/* loop de execuçao */
void loop (void)
{
   checkButtonEvents();
   checkTimerEvents();
}

/* event_driven_test */

#define LED_PIN 13
#define BUT_PIN 2

#define LED_T1_PIN 1
#define LED_T2_PIN 0

int led_timer_state = LOW;
int led_timer2_state = LOW;

int timerid1 = -1;
int timerid2 = -1;

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

