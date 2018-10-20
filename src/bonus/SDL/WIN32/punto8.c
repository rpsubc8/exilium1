/************************************************************************/
/* Ejemplo de SDL para WIN32 optimizado para dibujar un punto en 8 bits */
/* de color.                                                            */
/************************************************************************/
#include <windows.h>
#include <stdlib.h>
#include <SDL\SDL.h>


void DibujaPunto(SDL_Surface *pantalla,int x,int y,Uint8 color){
  Uint8 *pantallaAux;
  if (SDL_MUSTLOCK(pantalla)) {
      if (SDL_LockSurface(pantalla)<0) return;
  }

  pantallaAux = (Uint8 *)pantalla->pixels;
  pantallaAux[(((pantalla->pitch)*y) + x)] = color;

  if (SDL_MUSTLOCK(pantalla)) {
      SDL_UnlockSurface(pantalla);
  }
  SDL_UpdateRect(pantalla, x, y, 1, 1);
}


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
  screen = SDL_SetVideoMode(640, 480, 8, SDL_SWSURFACE);
  if ( screen == NULL ) {
      fprintf(stderr, "No puedo poner 640x480: %s\n", SDL_GetError());
      exit(1);
  }
  else DibujaPunto(screen,320,200,255);
 }
 getch();
 atexit(SDL_Quit);
}
