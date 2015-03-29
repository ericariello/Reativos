#include <SDL2/SDL.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define UP 0
#define DOWN 2
#define RIGHT 1
#define LEFT 3

struct Animation_Rectangle {
    SDL_Rect* sdl_rect;
    int direction;
    int squaresize;
    int count;
    int stop;
};

void changeRectanglePosition(SDL_Rect* r, int direction)
{
    switch (direction) {
            case UP:
            r->y -= 10;
            break;
            case DOWN:
            r->y += 10;
            break;
            case RIGHT:
            r->x += 10;
            break;
            case LEFT:
            r->x -= 10;
            break;
        default:
            break;
    }
}

void moveRectangleInSquare(struct Animation_Rectangle* animation_Rectangle)
{
    if (animation_Rectangle->count==0)
    {
        animation_Rectangle->direction += 1;
        animation_Rectangle->direction %= 4;
        animation_Rectangle->count = animation_Rectangle->squaresize;
    }
    fprintf(stderr, "%d %d %d\n", animation_Rectangle->direction, animation_Rectangle->count, animation_Rectangle->squaresize);
    changeRectanglePosition(animation_Rectangle->sdl_rect, animation_Rectangle->direction);
    animation_Rectangle->count--;
}

Uint32 updateRectangles (Uint32 interval, void *param)
{
    SDL_Event event;
    SDL_UserEvent userevent;
    
    /* In this example, our callback pushes an SDL_USEREVENT event
     into the queue, and causes our callback to be called again at the
     same interval: */
    
    userevent.type = SDL_USEREVENT;
    userevent.code = 0;
    userevent.data1 = (void*)("timer expired");
    userevent.data2 = NULL;
    
    event.type = SDL_USEREVENT;
    event.user = userevent;
    
    SDL_PushEvent(&event);
    return(interval);
}

int pointIsInsideRectangle (SDL_Rect r, int x, int y)
{
    if (x>r.x && x<r.x+r.w && y>r.y && y<r.y+r.h)
        return 1;
    return 0;
}
int main (int argc, char* args[])
{
    int err = SDL_Init(SDL_INIT_EVERYTHING);
    assert(err == 0);
    SDL_Window* window = SDL_CreateWindow("Animacao", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN );
    assert(window != NULL);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer != NULL);
    
    /* EXECUTION */
    SDL_Rect sld_rects[2] = {{ 200,200, 50, 50 }, { 400,100, 50, 50 }};
    SDL_Event e;
    
    /* timer */
    Uint32 delay = 100;
    SDL_TimerID my_timer_id = SDL_AddTimer(delay, updateRectangles, NULL);
    
    struct Animation_Rectangle myRectangles[2];
    myRectangles[0].sdl_rect = &(sld_rects[0]);
    myRectangles[0].direction = RIGHT;
    myRectangles[0].squaresize = 10;
    myRectangles[0].count = myRectangles[0].squaresize;
    myRectangles[0].stop = 0;
    
    myRectangles[1].sdl_rect = &(sld_rects[1]);
    myRectangles[1].direction = RIGHT;
    myRectangles[1].squaresize = 8;
    myRectangles[1].count = myRectangles[1].squaresize;
    myRectangles[1].stop = 0;
    
    while (1)
    {    
        while (SDL_PollEvent(&e) == 0);
        
        if (e.type == SDL_QUIT)
            break;
        else if (e.type == SDL_USEREVENT) {
            char* data1 = (char*)e.user.data1;
            if (strcmp(data1, "timer expired")==0)
                for (int i = 0; i < 2; i++)
                    if (myRectangles[i].stop == 0)
                        moveRectangleInSquare(&(myRectangles[i]));
        }
        else if (e.type == SDL_MOUSEBUTTONDOWN) {
            SDL_MouseButtonEvent* me = (SDL_MouseButtonEvent*)&e;
            int x = me->x, y = me->y;
            for (int i = 0; i < 2; i++)
                if (pointIsInsideRectangle(*(myRectangles[i].sdl_rect), x, y))
                    myRectangles[i].stop = 1;
        }
        
        SDL_SetRenderDrawColor(renderer, 0xFF,0xFF,0xFF,0x00);
        SDL_RenderFillRect(renderer, NULL);
        SDL_SetRenderDrawColor(renderer, 0x00,0x00,0xFF,0x00);
        SDL_RenderFillRect(renderer, &(sld_rects[0]));
        SDL_RenderFillRect(renderer, &(sld_rects[1]));
        SDL_RenderPresent(renderer);
    }
    
    /* FINALIZATION */
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}