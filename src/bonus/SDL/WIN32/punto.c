/*******************************************************************/
/* Ejemplo que dibuja un pixel en SDL para la diskmag Exilium      */
/* Se ha puesto una espera de pulsar una tecla getch() para verlo  */
/* Estos ejemplos son para WIN32                                   */
/*******************************************************************/
#include <windows.h>
#include <stdlib.h>
#include <SDL\SDL.h>

SDL_Surface *screen;


void DrawPixel(SDL_Surface *screen,int x,int y,Uint8 R,Uint8 G,Uint8 B){
  Uint32 color = SDL_MapRGB(screen->format, R, G, B);
  if ( SDL_MUSTLOCK(screen) ) {
      if ( SDL_LockSurface(screen) < 0 )  return;
  }
  switch (screen->format->BytesPerPixel) {
      case 1: { /* Assuming 8-bpp */
          Uint8 *bufp;
          bufp = (Uint8 *)screen->pixels + y*screen->pitch + x;
          *bufp = color;
      }
      break;

       case 2: { /* Probably 15-bpp or 16-bpp */
          Uint16 *bufp;
          bufp = (Uint16 *)screen->pixels + y*screen->pitch/2 + x;
          *bufp = color;
      }
      break;

      case 3: { /* Slow 24-bpp mode, usually not used */
          Uint8 *bufp;
          bufp = (Uint8 *)screen->pixels + y*screen->pitch + x * 3;
          if(SDL_BYTEORDER == SDL_LIL_ENDIAN) {
              bufp[0] = color;
              bufp[1] = color >> 8;
              bufp[2] = color >> 16;
          } else {
              bufp[2] = color;
              bufp[1] = color >> 8;
              bufp[0] = color >> 16;
          }
      }
      break;

      case 4: { /* Probably 32-bpp */
          Uint32 *bufp;
          bufp = (Uint32 *)screen->pixels + y*screen->pitch/4 + x;
          *bufp = color;
      }
      break;
  }
  if ( SDL_MUSTLOCK(screen) ) {
      SDL_UnlockSurface(screen);
  }
  SDL_UpdateRect(screen, x, y, 1, 1);
}



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
  else DrawPixel(screen,320,200,255,255,255);
  getch();
 }
 atexit(SDL_Quit);
}
