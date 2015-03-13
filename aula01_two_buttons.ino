const int button_speed_up = 2;
const int button_slow_down = 3;
const int led = 10;

unsigned long button_speed_up_last_pressed;
unsigned long button_slow_down_last_pressed;

int button_speed_up_is_pressed = 0;
int button_slow_down_is_pressed = 0;

const unsigned long button_off_delay = 500;
const unsigned long state_change_factor = 2;
unsigned long state_duration = 1000;

int led_state = LOW;
unsigned long last_state_change;

void switch_led_state() {
  led_state = !led_state;
  
  last_state_change = millis();
  digitalWrite(led, led_state);
}

void setup() {
  // put your setup code here, to run once:
  pinMode(button_speed_up, INPUT);
  pinMode(button_slow_down, INPUT);
  
  pinMode(led, OUTPUT);
 
  switch_led_state(); 
}

void loop() {
  // put your main code here, to run repeatedly:
  unsigned long curr_time = millis();

  int button_input_pressed = digitalRead(button_speed_up);
  if (!button_speed_up_is_pressed && button_input_pressed)
  {
    button_speed_up_last_pressed = curr_time;
    button_speed_up_is_pressed = 1;
    state_duration /= state_change_factor;
  }
  else if (button_speed_up_is_pressed && !button_input_pressed && (curr_time - button_speed_up_last_pressed) > button_off_delay)
  {
    button_speed_up_is_pressed = 0;
  }

  button_input_pressed = digitalRead(button_slow_down);
  if (!button_slow_down_is_pressed && button_input_pressed)
  {
    button_slow_down_last_pressed = curr_time;
    button_slow_down_is_pressed = 1;
    state_duration *= state_change_factor;
  }
  else if (button_slow_down_is_pressed && !button_input_pressed && (curr_time - button_slow_down_last_pressed) > button_off_delay)
  {
    button_slow_down_is_pressed = 0;
  }

  if (button_speed_up_is_pressed && button_slow_down_is_pressed)
  {
    while (true) {}
  }

  if (state_duration < curr_time - last_state_change)
  {
    switch_led_state();
  }
}
