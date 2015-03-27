/* event_driven.h */
#ifdef __cplusplus
extern "C" {
#endif
/* Registro de Listeners */
void button_listen(int pin);
int timer_set(int ms);

/* Callbacks de Listeners */
void button_changed (int pin, int value);
void timer_expired (int timerId);

/* Callback de inicializaçao */
void init_event_driven ();

/* Metodos extra */
void activate_timer(int timerId);
void deactivate_timer(int timerId);
void change_timer(int timerId, int time);

/* Metodos Arduino */
#ifdef __cplusplus
}
#endif
