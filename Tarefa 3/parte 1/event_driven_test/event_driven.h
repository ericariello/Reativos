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

/* Metodos Arduino */
#ifdef __cplusplus
}
#endif
