/*******************************************************************/
/* Ejemplo de SDL bajo WINDOWS con MINGW32   Para Diskmag Exilium  */
/* Para compilar hay que disponer de las librerias SDL             */
/* Se compila: gcc prueba.c -prueba.exe -lsdl                      */
/*******************************************************************/
#include <windows.h>
#include <stdlib.h>
#include <SDL\SDL.h>

int WINAPI WinMain (HINSTANCE hInstance, 
                        HINSTANCE hPrevInstance, 
                        PSTR szCmdLine, 
                        int iCmdShow) 
   {
   if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 ) {
       fprintf(stderr,"No se puede inicializar las SDL: %s\n", SDL_GetError());
       exit(1);
   }
   atexit(SDL_Quit);
  }
