#include <windows.h>
#include <stdlib.h>
#include <SDL\SDL.h>

SDL_Surface *screen;


int WINAPI WinMain (HINSTANCE hInstance, 
                        HINSTANCE hPrevInstance, 
                        PSTR szCmdLine, 
                        int iCmdShow){

 if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 ) {
     fprintf(stderr,"No se puede inicializar las SDL: %s\n", SDL_GetError());
     exit(1);
 }
 else{
  screen = SDL_SetVideoMode(640, 480, 16, SDL_SWSURFACE);
  if ( screen == NULL ) {
      fprintf(stderr, "No puedo poner 640x480: %s\n", SDL_GetError());
      exit(1);
  }
 }
 atexit(SDL_Quit);
}
