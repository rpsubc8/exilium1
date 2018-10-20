/************************************************************/
/* DISKMAG para DOS                                         */
/* Compila: gcc -s -O6 demo.c -oexilium.exe -ljgmod -lalleg */
/* Autor: Jaime Jose Gavin Sierra.  Alias: J.J.             */
/************************************************************/

//Para mayor velocidad de compilacion
#define alleg_joystick_unused
#define alleg_flic_unused
#define alleg_math_unused
#define alleg_gui_unused


#include <stdio.h>
#include <string.h>
#include <allegro.h>
#include <jgmod.h>
#include "config.h"
#include "datos.h"
#include "sliders1.h"
#include "optimiza.c"


#define maxFotos 20           //Soporte para 20 fotos cada articulo
#define maxInfo 3100          //Con soporte para mas de 100 hojas 100*30=3000
#define maxArticulos 50       //Soporte para 50 articulos
#define longitud_cadena 79    //Longitud maxima de la cadena de texto
#define desX_cadena 4         //Desplazamiento x de la cadena en pantalla
#define mas 0
#define menos 1



/*******************************/
/* id 0 texto normal           */
/* id 1 texto color rojo       */
/* id 2 texto color negro      */
/*******************************/

typedef unsigned char boolean;

//enum TitemColor{color_rojo,color_verde,color_azul,color_negro,color_blanco,color_marron,color_amarillo,color_violeta,color_verdefosforito,color_azulclaro,color_naranja,color_gris,color_grisclaro};
enum TitemJustificacion{derecha,izquierda,centro,nojustificado};
//enum TitemLetra{letra_grande,letra_normal,letra_pc,letra_pct,letra_xm,letra_xmb,letra_xmi};

typedef struct{  //Dibujo el bloque a partir de y + 10 pixels
 unsigned char xIni; //La coordenada X de inicio a dibujar
 short int yIni; //La coordenada Y de inicio a dibujar
 short int numFoto;   //El indice a la lista de fotos. 0 no hay foto
}TFoto;

typedef struct{
// enum TitemColor color;
//enum TitemLetra letra;
 int color;           //Contiene el color en crudo para optimizar
 short int letra;           //Contiene el indice a la fuente para optimizar
 enum TitemJustificacion justificacion;
 TFoto laFoto; //Un puntero ocupa 4 bytes, y esta estructura 4 bytes
}TitemDatos;

typedef struct {
 TitemDatos item;
 char *cadena;
}Tnodo;

typedef struct{
 unsigned char numFotos;      //El numero de fotos del documento
 short int numFilas;                //El numero de filas del documento
 short int posFila;                 //La fila actual del documento
 Tnodo info[maxInfo];
// char *texto[maxInfo];
 BITMAP * fotos[maxFotos];    //Lista de todas las fotos del documento
 PALETTE * paletas[maxFotos]; //Lista de las paletas de cada foto
}TArticulo;                   //Contiene todo el articulo

typedef struct{               //Contiene a los articulos por menu de inicio
 unsigned char numArticulos;  //El numero total de articulos
 unsigned char articuloActual;//El articulos actual
 short int articulo[maxArticulos]; //El indice al articulo
 char *textoPlataForma[maxArticulos];  //El nombre de la plataforma
 char *textoAutor[maxArticulos];       //El nombre del autor del articulo
 char *textoArticulo[maxArticulos];    //El titulo del articulo
}TArticulos;


volatile crono=0;
JGMOD *archivoMOD;
short int i;
boolean sonido=FALSE,raton=FALSE,driverSonido=FALSE; //GLOBAL para sabe si hay sonido
PALETTE paletaGris;
TArticulo elArticulo; //GLOBAL Aqui guardo el Articulo
BITMAP *fondo = NULL;
BITMAP *letras = NULL;
BITMAP *videoTemporal = NULL;
BITMAP *auxBitmap = NULL;
DATAFILE *datafile; //Contiene los datos de FUENTES y demas de la revista
DATAFILE *revista;  //Contiene los articulos de la revista
DATAFILE *configuracion; //Contiene los datos de configuracion y fotos
TArticulos losArticulos;
short int grises;         //Contiene si estamos en gris o color
int color_rojo,color_verde,color_azul,color_negro,color_blanco,color_marron,color_amarillo,color_violeta; //Para optimizar
int color_verdeFosforito,color_azulClaro,color_naranja,color_gris,color_grisClaro;


void ScrollArriba();
void ScrollAbajo();
void ScrollArriba30Lineas();
void ScrollAbajo30Lineas();
void LeerArchivoDatos(char *nombre, DATAFILE **datos);
void BuscarItem(char *cad, TitemDatos * itemDatos);
void MostrarArticulo(int indice);
void InicializarArticulo();
void EliminarArticulo();
void InicializarLosArticulos(TArticulos *losArticulos);
void EliminarLosArticulos(TArticulos *losArticulos);
void LeerArticulos(TArticulos *articulos);
void MostrarArticulosPantalla(TArticulos *losArticulos, BITMAP *pantalla);
void ScrollArribaArticulos(TArticulos *losArticulos, BITMAP *pantalla);
void ScrollAbajoArticulos(TArticulos *losArticulos, BITMAP *pantalla);
void ControlaEventos();
void MostrarTitulo(BITMAP *pantalla);
void MostrarInfoArticulo(BITMAP *pantalla);
void MostrarBotones();
//int JustificacionIzquierda(char *cadena,enum TitemLetra tipoLetra);
int JustificacionDerecha (char *cadena,int tipoLetra);
void AccionSonido();
void HacerJustificacion(char *cadena,int tipoLetra,enum TitemJustificacion justificacion);
void GeneraColores();
void Presentacion(DATAFILE *datos);
int ActivaMOD();
void DestruyeMOD();
void inc_crono1();
void Fundir();
void Desfundir(PALETTE paleta);
void Despedida(DATAFILE *datos);
void ReguladorVolumen(unsigned char tipo);
void MostrarLineaComandos(void);
//void LeerArticuloDisco(char *nombre,TArticulo articulo);


int main(int argc,char *argv[]){
 if (argc>1){
  if ((strcmp("/?",argv[1])==0)||(strcmp("?",argv[1])==0)){
    MostrarLineaComandos();
    return (0);
  }
 }

 allegro_init();
 install_keyboard();      //Instalo el teclado
 if (install_mouse()!=-1) raton=1; //Instalo el raton
 install_timer();         //Para poder mostrar raton activo el timer
 LeerArchivoDatos("datos.dat",&datafile);
 LeerArchivoDatos("sliders1.dat",&revista);
 LeerArchivoDatos("config1.dat",&configuracion);
 set_color_conversion(COLORCONV_NONE);


 switch(argc){
  case 2: if (!((strcmp("no",argv[1])==0)||(strcmp("NO",argv[1])==0)))
            //Muestra la presentacion
            Presentacion(configuracion);
          else ActivaMOD();

          if (strcmp("8",argv[1])==0){
           set_color_depth(8);
           grises = TRUE;
          }
          else{
           set_color_depth(16);
           grises = FALSE; //Estamos en color
          }
          break;
          
  case 3: if (!(((strcmp("no",argv[1])==0)||(strcmp("NO",argv[1])==0))||((strcmp("no",argv[2])==0)||(strcmp("NO",argv[2])==0))))
            //Muestra la presentacion
            Presentacion(configuracion);
          else ActivaMOD();
          
          if ((strcmp("8",argv[1])==0)||(strcmp("8",argv[2])==0)){
           set_color_depth(8);
           grises = TRUE;
          }
          else{
           set_color_depth(16);
           grises = FALSE; //Estamos en color
          }                        
          break;

  default: Presentacion(configuracion);
           set_color_depth(16);
           break;
 }




 
 letras = create_bitmap(640,480);
 auxBitmap = create_bitmap(640,480);
 videoTemporal = create_bitmap(640,480);
 clear_to_color(letras,bitmap_mask_color(letras));
 if (set_gfx_mode(GFX_AUTODETECT,640,480,0,0)!=0){
  allegro_exit();
  printf("Error en modo de video\nPruebe en escala de grises");
  exit(-1);
 }



 //Peparamos la pelata de grises
 if (grises){
  for (i=0;i<256;i++) paletaGris[i].r = paletaGris[i].g = paletaGris[i].b = (i>>2);
  set_palette(paletaGris);            //Ponemos la paleta de grises
 }

 GeneraColores();
 
 if (raton) show_mouse(screen);                       //Muestro raton
 fondo = configuracion[FOTO_FONDO].dat;
// set_palette(configuracion[PALETA_FONDO].dat);
// hline(fondo,0,80,639,makecol(255,255,255));  //Lineas separatorias
// hline(fondo,0,400,639,makecol(255,255,255));


 InicializarLosArticulos(&losArticulos);
 LeerArticulos(&losArticulos);
 
 InicializarArticulo();
 MostrarArticulo(losArticulos.articulo[0]);  //Muestra el articulo de delabu
 ControlaEventos();                           //Se mete en bucle de eventos



 if (driverSonido) DestruyeMOD();


 switch(argc){
  case 2: if (!((strcmp("no",argv[1])==0)||(strcmp("NO",argv[1])==0)))
            Despedida(configuracion);
          break;
          
  case 3: if (!(((strcmp("no",argv[1])==0)||(strcmp("NO",argv[1])==0))||((strcmp("no",argv[2])==0)||(strcmp("NO",argv[2])==0))))
            Despedida(configuracion);
          break;

  default: Despedida(configuracion); break;
 }

 
 
 set_gfx_mode(GFX_TEXT,80,25,0,0);
/* for (i=0;i<10;i++){
  printf("%d ",elArticulo.info[i].item.color);
 }
 printf("\nNumero de fotos totales: %d\nArgumentos: %d\n",elArticulo.numFotos,argc);
*/
 EliminarArticulo();
 EliminarLosArticulos(&losArticulos);
 
/* set_gfx_mode(GFX_TEXT,80,25,0,0);
 for (i=78;i<100;i++){
  printf("%d %c ",((char *)datafile[TEXTO_REVISTA].dat)[i],((char *)datafile[TEXTO_REVISTA].dat)[i]);
 }*/


 unload_datafile(configuracion);
 unload_datafile(revista);
 unload_datafile(datafile);
 destroy_bitmap(auxBitmap);
 destroy_bitmap(letras);
 destroy_bitmap(videoTemporal);
 if (raton) show_mouse(NULL);
 remove_timer;
 if (raton) remove_mouse();
 remove_keyboard();
 allegro_exit();
 //printf("Numero filas: %d \nFila actual: %d",elArticulo.numFilas,elArticulo.posFila);
 return (0);
}
END_OF_MAIN();


/************************************************/
void ScrollArriba(){
 int auxiliar;
 int i,j=0,total=0;
 
 if (elArticulo.posFila<elArticulo.numFilas){
//  total = elArticulo.numFilas-elArticulo.posFila;
//  if (total>=5) total=5;
/*  if ((elArticulo.posFila+5)>(elArticulo.numFilas))
   total = elArticulo.numFilas-elArticulo.posFila;
  else  */
   total=5;
  if (!grises) select_palette(configuracion[PALETA_FONDO].dat);
//  blit(fondo,videoTemporal,0,0,0,0,640,480);
//  blit(letras,letras,0,140,0,90,640,300);
  blit(fondo,videoTemporal,0,0,0,80,640,320);
  //rectfill(videoTemporal,0,400,640,400,0);
  blit(letras,letras,0,140,0,90,640,260);
  rectfill(letras,0,350,639,400,bitmap_mask_color(letras));


  //Dibujo las 4 filas anteriores para quitar defectos visuales
  for (i=(elArticulo.posFila+1-4);i<(elArticulo.posFila+total+1);i++,j++){
   if (elArticulo.info[i].cadena!=NULL){
/*    switch (elArticulo.info[i].item.color){
     case color_rojo: color = rojo; break;
     case color_verde: color= verde; break;
     case color_azul: color = azul; break;
     case color_negro: color = negro; break;
     case color_blanco: color = blanco; break;
     case color_marron: color = marron; break;
     case color_amarillo: color = amarillo; break;
     case color_violeta: color = violeta; break;
     case color_verdefosforito: color = verdeFosforito; break;
     case color_azulclaro: color = azulClaro; break;
     case color_naranja: color =  naranja; break;
     case color_gris: color = gris; break;
     case color_grisclaro: color = grisClaro; break;
     default: color = blanco;
    } */

    /*switch (elArticulo.info[i].item.letra){
     case letra_grande: indiceFuente = FUENTE_GRANDE; break;
     case letra_normal: indiceFuente = FUENTE_NORMAL; break;
     case letra_pc: indiceFuente = FUENTE_PC; break;
     case letra_pct: indiceFuente = FUENTE_PCT; break;
     case letra_xm: indiceFuente = FUENTE_XM; break;
     case letra_xmb: indiceFuente = FUENTE_XMB; break;
     case letra_xmi: indiceFuente = FUENTE_XMI; break;
     default: indiceFuente = FUENTE_XM;
    }*/

    auxiliar = 300+(j<<3)+(j<<1);
    switch (elArticulo.info[i].item.justificacion){
     case nojustificado: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
     case centro: textout_centre(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,319,auxiliar,elArticulo.info[i].item.color); break;
     case izquierda: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
                     //textout_justify(letras, datafile[indiceFuente].dat,elArticulo.info[i].cadena,JustificacionIzquierda(elArticulo.info[i].cadena,elArticulo.info[i].item.letra),639,(340+j*10),640,color); break;
     case derecha: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,(639-desX_cadena-JustificacionDerecha(elArticulo.info[i].cadena,elArticulo.info[i].item.letra)),auxiliar,elArticulo.info[i].item.color); break;//Soporta 80 caracteres y 30 filas
    }
    //textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,0,(340+(j<<3)+(j<<1)),elArticulo.info[i].item.color);

    if ((elArticulo.info[i].item.laFoto.numFoto)!=0){
      if (!grises) select_palette(*(elArticulo.paletas[((elArticulo.info[i].item.laFoto.numFoto))]));
      blit(elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)],letras,0,elArticulo.info[i].item.laFoto.yIni,(((elArticulo.info[i].item.laFoto.xIni)<<3)+desX_cadena),auxiliar,elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)]->w,10);
    }

   }  
   //textout(letras,datafile[FUENTE_NORMAL].dat,elArticulo.texto[i],1,(340+j*10),0xFFFFFF); //Soprta 80 caracteres y 30 filas
  }
  elArticulo.posFila+=total;
  masked_blit(letras,videoTemporal,0,0,0,0,640,480);
//  blit(videoTemporal,screen,0,0,0,0,640,480);
  MostrarInfoArticulo(letras);
  
//  if ((raton)&&(mouse_y>=30)&&(mouse_y<400)){
  if (raton){
   show_mouse(NULL);
   blit(videoTemporal,screen,0,50,0,50,640,350);
   show_mouse(screen);
  }
  else blit(videoTemporal,screen,0,50,0,50,640,350);
 }
}

/************************************************/
void ScrollAbajo(){
 int auxiliar;
 int i,j=0,total=0;
 
 if (elArticulo.posFila>29){
//  total = elArticulo.posFila-29;
  total=5;
//  if (total>=5) total=5;
  clear_to_color(auxBitmap,bitmap_mask_color(auxBitmap));
  if (!grises) select_palette(configuracion[PALETA_FONDO].dat);
//  blit(fondo,videoTemporal,0,0,0,0,640,480);
//  blit(letras,auxBitmap,0,90,0,140,640,250);
  blit(fondo,videoTemporal,0,0,0,80,640,320);
  //rectfill(videoTemporal,0,400,640,400,0);
  blit(letras,auxBitmap,0,90,0,140,640,250);

  
  for (i=(elArticulo.posFila-(total+29));i<(elArticulo.posFila-29);i++,j++)
   if (elArticulo.info[i].cadena!=NULL){
/*    switch (elArticulo.info[i].item.color){
     case color_rojo: color = rojo; break;
     case color_verde: color= verde; break;
     case color_azul: color = azul; break;
     case color_negro: color = negro; break;
     case color_blanco: color = blanco; break;
     case color_marron: color = marron; break;
     case color_amarillo: color = amarillo; break;
     case color_violeta: color = violeta; break;
     case color_verdefosforito: color = verdeFosforito; break;
     case color_azulclaro: color = azulClaro; break;
     case color_naranja: color = naranja; break;
     case color_gris: color = gris; break;
     case color_grisclaro: color = grisClaro; break;
     default: color = blanco;
    }*/

/*    switch (elArticulo.info[i].item.letra){
     case letra_grande: indiceFuente = FUENTE_GRANDE; break;
     case letra_normal: indiceFuente = FUENTE_NORMAL; break;
     case letra_pc: indiceFuente = FUENTE_PC; break;
     case letra_pct: indiceFuente = FUENTE_PCT; break;
     case letra_xm: indiceFuente = FUENTE_XM; break;
     case letra_xmb: indiceFuente = FUENTE_XMB; break;
     case letra_xmi: indiceFuente = FUENTE_XMI; break;
     default: indiceFuente = FUENTE_XM;
    }*/

    auxiliar = 90 + (j<<3)+(j<<1);
    switch (elArticulo.info[i].item.justificacion){
     case nojustificado: textout(auxBitmap, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
                         //textout(auxBitmap, datafile[indiceFuente].dat,elArticulo.info[i].cadena,0,(90+j*10),color); break;
     case centro: textout_centre(auxBitmap, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,319,auxiliar,elArticulo.info[i].item.color); break;
     case izquierda: textout(auxBitmap, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
                    // textout_justify(auxBitmap, datafile[indiceFuente].dat,elArticulo.info[i].cadena,JustificacionIzquierda(elArticulo.info[i].cadena,elArticulo.info[i].item.letra),639,(90+j*10),640,color); break;
     case derecha: textout(auxBitmap, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,(639-desX_cadena-JustificacionDerecha(elArticulo.info[i].cadena,elArticulo.info[i].item.letra)),auxiliar,elArticulo.info[i].item.color); break;//Soporta 80 caracteres y 30 filas
    }
    //textout(auxBitmap, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,0,(90+j*10),elArticulo.info[i].item.color);

    if ((elArticulo.info[i].item.laFoto.numFoto)!=0){
      if (!grises) select_palette(*(elArticulo.paletas[((elArticulo.info[i].item.laFoto.numFoto))]));
      blit(elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)],auxBitmap,0,elArticulo.info[i].item.laFoto.yIni,(((elArticulo.info[i].item.laFoto.xIni)<<3)+desX_cadena),auxiliar,elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)]->w,10);
    }


   }  
  
//   textout(auxBitmap,datafile[FUENTE_NORMAL].dat,elArticulo.texto[i],1,(90+j*10),0xFFFFFF); //Soprta 80 caracteres y 30 filas
  elArticulo.posFila-=total;
  masked_blit(auxBitmap,videoTemporal,0,0,0,0,640,480);
//  blit(videoTemporal,screen,0,0,0,0,640,480);
//  blit(auxBitmap,letras,0,0,0,0,640,480);
  MostrarInfoArticulo(auxBitmap);
//  if ((raton)&&(mouse_y>=30)&&(mouse_y<400)){
  if (raton){
   show_mouse(NULL);
   blit(videoTemporal,screen,0,50,0,50,640,350);
   show_mouse(screen);
  }
  else blit(videoTemporal,screen,0,50,0,50,640,350);
  blit(auxBitmap,letras,0,80,0,80,640,320);
 }
}

/************************************************/
void LeerArchivoDatos(char *nombre, DATAFILE **datos){
 *datos = load_datafile(nombre);
 if (*datos==NULL) {
   allegro_exit();
   printf("Error leyendo el archivo de datos\n");
   exit(-1);
 }
}

/************************************************/
void BuscarItem(char *cad, TitemDatos * itemDatos){
/* [COLOR=ROJO IZQUIERDA DOBLE]*/
 int i=0,j=0,contCad=0;
 char cadenas[100][100];
 char car;
 for (i=0;i<(strlen(cad)+1);i++){
  car = cad[i];
  if ((car=='\0')||(car==' ')){
   cadenas[j][contCad] = '\0';
   contCad=0;
   j++;
  }
  else{
   cadenas[j][contCad] = car;
   contCad++;
  }
 }
 for (i=0;i<j;i++){
  if (strcmp("ROJO",cadenas[i])==0) itemDatos->color = color_rojo;
  if (strcmp("VERDE",cadenas[i])==0) itemDatos->color = color_verde;
  if (strcmp("AZUL",cadenas[i])==0) itemDatos->color = color_azul;
  if (strcmp("NEGRO",cadenas[i])==0) itemDatos->color = color_negro;
  if (strcmp("BLANCO",cadenas[i])==0) itemDatos->color = color_blanco;
  if (strcmp("MARRON",cadenas[i])==0) itemDatos->color = color_marron;
  if (strcmp("AMARILLO",cadenas[i])==0) itemDatos->color = color_amarillo;
  if (strcmp("VIOLETA",cadenas[i])==0) itemDatos->color = color_violeta;
  if (strcmp("VERDEFOSFORITO",cadenas[i])==0) itemDatos->color = color_verdeFosforito;
  if (strcmp("AZULCLARO",cadenas[i])==0) itemDatos->color = color_azulClaro;
  if (strcmp("NARANJA",cadenas[i])==0) itemDatos->color = color_naranja;
  if (strcmp("GRIS",cadenas[i])==0) itemDatos->color = color_gris;
  if (strcmp("GRISCLARO",cadenas[i])==0) itemDatos->color = color_grisClaro;

  if (strcmp(cadenas[i],"GRANDE")==0) itemDatos->letra = FUENTE_GRANDE;
  if (strcmp(cadenas[i],"NORMAL")==0) itemDatos->letra = FUENTE_NORMAL;
  if (strcmp(cadenas[i],"PC")==0) itemDatos->letra = FUENTE_PC;
  if (strcmp(cadenas[i],"PCT")==0) itemDatos->letra = FUENTE_PCT;
  if (strcmp(cadenas[i],"XM")==0) itemDatos->letra = FUENTE_XM;
  if (strcmp(cadenas[i],"XMB")==0) itemDatos->letra = FUENTE_XMB;
  if (strcmp(cadenas[i],"XMI")==0) itemDatos->letra = FUENTE_XMI;
  if (strcmp(cadenas[i],"CHAR11")==0) itemDatos->letra = FUENTE_CHAR11;
  if (strcmp(cadenas[i],"CHAR11B")==0) itemDatos->letra = FUENTE_CHAR11B;
  if (strcmp(cadenas[i],"CHAR11I")==0) itemDatos->letra = FUENTE_CHAR11I;
  if (strcmp(cadenas[i],"CHAR11BI")==0) itemDatos->letra = FUENTE_CHAR11BI;
  if (strcmp(cadenas[i],"CHAR14")==0) itemDatos->letra = FUENTE_CHAR14;
  if (strcmp(cadenas[i],"CHAR14B")==0) itemDatos->letra = FUENTE_CHAR14B;
  if (strcmp(cadenas[i],"CHAR14I")==0) itemDatos->letra = FUENTE_CHAR14I;
  if (strcmp(cadenas[i],"CHAR14BI")==0) itemDatos->letra = FUENTE_CHAR14BI;
  

  if (strcmp(cadenas[i],"NO")==0) itemDatos->justificacion = nojustificado;
  if (strcmp(cadenas[i],"DERECHA")==0) itemDatos->justificacion = derecha;
  if (strcmp(cadenas[i],"IZQUIERDA")==0) itemDatos->justificacion = izquierda;  
  if (strcmp(cadenas[i],"CENTRO")==0) itemDatos->justificacion = centro;  
 }
}
/************************************************/
void MostrarArticulo(int indice){
 int auxiliar;
 int restoFoto;
 int indiceFoto,indicePaleta;
 int columnaX,filaY;
 char *endp;
 int aux;
 double numFotos=0;
 int color=0;
 TitemDatos datosItem;
 char cadAux[500];
 char cadItem[500];
 int contItem=0;
 int salir=0;
 int i=0;
 int j=0;
 int cont=0;
 char car;
 text_mode(bitmap_mask_color(letras));    //Hago que el fondo del texto sea transparente

/* while (cont<(revista[indice].size)){
  car = ((char *)revista[indice].dat)[cont];
  if (car!=13){
   cadAux[i] = car;
   i++;
  }
  if (car==10){
   cadAux[i]='\0';
   elArticulo.texto[j] = (char *)malloc(sizeof(char)*(i+1));
   strcpy(elArticulo.texto[j],cadAux);
   j++;
   elArticulo.numFilas++;
   i=0;   
  }
  cont++;
 }*/




 datosItem.color = color_blanco;
 datosItem.letra = FUENTE_PC;
 datosItem.justificacion = centro;
 salir=0;
 elArticulo.numFilas=0;
 i=0;
 j=0;
 cont=7;

 //Aqui leo las fotos
 cadAux[0]='\0';
 car=((char *)revista[indice].dat)[cont];;
 while ((car!=']')&&(car!=10)){
  if (car!=13){
   cadAux[i]=car;
   i++;
  }
  cont++;
  car=((char *)revista[indice].dat)[cont];
 }
 cadAux[i]='\0';
 numFotos = strtod(cadAux,&endp);
 elArticulo.numFotos=(int)numFotos; //Ya tengo las fotos totales
 cadAux[0]='\0';

 car=((char *)revista[indice].dat)[cont];
 while (car!=10){
  cont++;
  car=((char *)revista[indice].dat)[cont];
 }
 cont++;

 
 for (i=1;i<=numFotos;i++){//Pongo todas las fotos
  car=0;
  aux=0;
  while (car!=' '){
   car = ((char *)revista[indice].dat)[cont];
   if (car!=13){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  indiceFoto=(int)strtod(cadAux,&endp); //Cojo el indice de la foto en el dat
// elArticulo.numFotos=(unsigned char)indiceFoto;

  car=0;
  aux=0;
  while (car!=' '){
   car = ((char *)revista[indice].dat)[cont];
   if (car!=13){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  indicePaleta=(int)strtod(cadAux,&endp); //Cojo su paleta en el dat

  car=0;
  aux=0;
  while (car!=' '){
   car = ((char *)revista[indice].dat)[cont];
   if (car!=13){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  columnaX=(int)strtod(cadAux,&endp); //Su columna en el dat

  car=0;
  aux=0;
  while (car!=10){
   car = ((char *)revista[indice].dat)[cont];
   if (car!=13){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  filaY=(int)strtod(cadAux,&endp); //Su fila en el dat
  //Ahora es cuando pongo las fotos en el articulo
  elArticulo.paletas[i]= revista[indicePaleta].dat;
  elArticulo.fotos[i] = revista[indiceFoto].dat;

  restoFoto = elArticulo.fotos[i]->h%10; //Controla si es > multiplos de 10
  if (restoFoto>0) restoFoto=1;          //Para coger la foto entera
  
  for (j=0;j<((elArticulo.fotos[i]->h/10)+restoFoto);j++){
   elArticulo.info[j+filaY].item.laFoto.xIni = columnaX;
   elArticulo.info[j+filaY].item.laFoto.yIni = j*10;
   elArticulo.info[j+filaY].item.laFoto.numFoto = i;
  }  
 }
 cadAux[0]='\0';
 

 
 i=0;
 j=0;
 car=0;
 
 while (cont<(revista[indice].size)){
  car = ((char *)revista[indice].dat)[cont];
  if (car!=13){
   if (car=='[') {
    cont++;
    if (cont<(revista[indice].size)){
     car = ((char *)revista[indice].dat)[cont];
     if (car=='['){
      if (car!=13){
       cadAux[i] = car;
       i++;
      }
     }
     else{
      contItem = 0;
      while ((car!=']')&&(car!=10)){
       if (car!=13){
        cadItem[contItem]=car;
        contItem++;
       }
       cont++;
       car = ((char *)revista[indice].dat)[cont];
      }
      cadItem[contItem]='\0';
      BuscarItem(cadItem,&datosItem);
     }
    }
   }
   else{
    if (car!=10){
     if (car!=13){
      cadAux[i] = car;
      i++;
     }
    }
   }
  }
  if (car==10){
   cadAux[i]='\0';
   datosItem.laFoto.xIni = elArticulo.info[j].item.laFoto.xIni;
   datosItem.laFoto.yIni = elArticulo.info[j].item.laFoto.yIni;
   datosItem.laFoto.numFoto = elArticulo.info[j].item.laFoto.numFoto;
   elArticulo.info[j].item = datosItem;

   //Aqui pasamos los datos para justificar manualmente la cadena
   if (strlen(cadAux)>longitud_cadena) cadAux[longitud_cadena]='\0'; //recorta la cadena
   HacerJustificacion(cadAux,datosItem.letra,datosItem.justificacion);
   
   elArticulo.info[j].cadena = (char *)malloc(sizeof(char)*(strlen(cadAux)+1));
   strcpy(elArticulo.info[j].cadena,cadAux);   
   j++;
   elArticulo.numFilas++;
   i=0;     
  }
  cont++;
 }



 //Aqui pongo la primera foto
// elArticulo.numFotos = 1;
/*  elArticulo.fotos[1] = datafile[FOTO].dat;
  elArticulo.fotos[1]->x_ofs = 10;
  for (j=0;j<(elArticulo.fotos[1]->h/10);j++){
   elArticulo.info[j+6].item.laFoto.yIni = j*10;
   elArticulo.info[j+6].item.laFoto.numFoto = 1;
  }*/

 //borro el contenido actual de letras
 rectfill(letras,0,0,639,479,bitmap_mask_color(letras));
 
 for (j=0;j<30;j++)
 // if (elArticulo.texto[j]!=NULL) textout(letras, datafile[FUENTE_XM].dat,elArticulo.texto[j],1,(90+j*10),0xFFFFFF); //Soprta 80 caracteres y 30 filas 
  if (elArticulo.info[j].cadena!=NULL){
/*   switch (elArticulo.info[j].item.color){
    case color_rojo: color = makecol(255,0,0); break;
    case color_verde: color= makecol(0,180,0); break;
    case color_azul: color = makecol(0,0,255); break;
    case color_negro: color = makecol(0,0,0); break;
    case color_blanco: color = makecol(255,255,255); break;
    case color_marron: color = makecol(178,139,4); break;
    case color_amarillo: color = makecol(252,255,17); break;
    case color_violeta: color = makecol(211,128,246); break;
    case color_verdefosforito: color = makecol(80,255,66); break;
    case color_azulclaro: color = makecol(29,226,255); break;
    case color_naranja: color = makecol(255,125,29); break;
    case color_gris: color = makecol(136,148,152); break;
    case color_grisclaro: color = makecol(222,230,231); break;
    default: color = makecol(255,255,255);
   }*/

/*   switch (elArticulo.info[j].item.letra){
    case letra_grande: indiceFuente = FUENTE_GRANDE; break;
    case letra_normal: indiceFuente = FUENTE_NORMAL; break;
    case letra_pc: indiceFuente = FUENTE_PC; break;
    case letra_pct: indiceFuente = FUENTE_PCT; break;
    case letra_xm: indiceFuente = FUENTE_XM; break;
    case letra_xmb: indiceFuente = FUENTE_XMB; break;
    case letra_xmi: indiceFuente = FUENTE_XMI; break;
    default: indiceFuente = FUENTE_XM;
   }*/

   auxiliar = 90+(j<<3)+(j<<1);
   switch (elArticulo.info[j].item.justificacion){
    case nojustificado: textout(letras, datafile[(elArticulo.info[j].item.letra)].dat,elArticulo.info[j].cadena,desX_cadena,auxiliar,elArticulo.info[j].item.color); break;
                        //textout(letras, datafile[indiceFuente].dat,elArticulo.info[j].cadena,0,(90+j*10),color); break;
    case centro: textout_centre(letras, datafile[(elArticulo.info[j].item.letra)].dat,elArticulo.info[j].cadena,319,auxiliar,elArticulo.info[j].item.color); break;
    case izquierda: textout(letras, datafile[(elArticulo.info[j].item.letra)].dat,elArticulo.info[j].cadena,desX_cadena,auxiliar,elArticulo.info[j].item.color); break;
                    //textout_justify(letras, datafile[indiceFuente].dat,elArticulo.info[j].cadena,JustificacionIzquierda(elArticulo.info[j].cadena,elArticulo.info[j].item.letra),639,(90+j*10),640,color); break;
    case derecha: textout(letras, datafile[(elArticulo.info[j].item.letra)].dat,elArticulo.info[j].cadena,(639-desX_cadena-JustificacionDerecha(elArticulo.info[j].cadena,elArticulo.info[j].item.letra)),auxiliar,elArticulo.info[j].item.color); break;//Soporta 80 caracteres y 30 filas
   }
   //textout(letras, datafile[(elArticulo.info[j].item.letra)].dat,elArticulo.info[j].cadena,0,(90+j*10),elArticulo.info[j].item.color);


   if ((elArticulo.info[j].item.laFoto.numFoto)!=0){
    if (!grises) select_palette(*(elArticulo.paletas[((elArticulo.info[j].item.laFoto.numFoto))]));
    blit(elArticulo.fotos[(elArticulo.info[j].item.laFoto.numFoto)],letras,0,elArticulo.info[j].item.laFoto.yIni,(((elArticulo.info[j].item.laFoto.xIni)<<3)+desX_cadena),auxiliar,elArticulo.fotos[(elArticulo.info[j].item.laFoto.numFoto)]->w,10);
   }

  }
 elArticulo.posFila = 29;

 if (!grises) select_palette(configuracion[PALETA_FONDO].dat);
 blit(fondo,videoTemporal,0,0,0,80,640,321);
 //rectfill(videoTemporal,0,400,640,400,0);
 MostrarBotones();
 MostrarArticulosPantalla(&losArticulos,letras);
 masked_blit(letras,videoTemporal,0,0,0,0,640,480);
 if (!grises) select_palette(configuracion[PALETA_LOGO].dat);
 blit(configuracion[FOTO_LOGO].dat,videoTemporal,0,0,0,0,640,80);
 MostrarTitulo(letras);
 MostrarInfoArticulo(letras);
 if (raton) show_mouse(NULL);
 blit(videoTemporal,screen,0,0,0,0,640,480);
 if (raton) show_mouse(screen);


// select_palette(datafile[PALETA_FOTO].dat);
// blit(datafile[FOTO].dat,screen,0,0,0,0,300,150);
 //set_palette(datafile[PALETA_FOTO].dat);
}

/************************************************/
void InicializarArticulo(){
 int i;
 for (i=0;i<maxInfo;i++){
//  elArticulo.texto[i]=NULL;
  elArticulo.info[i].cadena=NULL;
  elArticulo.info[i].item.color=color_blanco;
  elArticulo.info[i].item.letra=FUENTE_PC;
  elArticulo.info[i].item.justificacion=centro;
  elArticulo.info[i].item.laFoto.numFoto = 0; //Al ser 0, no hay foto
 }
 elArticulo.numFotos = 0;     //Pone 0 fotos en al articulo
 for (i=0;i<maxFotos;i++)
  elArticulo.fotos[i] = NULL;
}

/************************************************/
void EliminarArticulo(){
 int i;
 for (i=0;i<maxInfo;i++){
//  free(elArticulo.texto[i]);
  free(elArticulo.info[i].cadena);  
 }
 elArticulo.numFotos = 0; 
}


/************************************************/
void LeerArticulos(TArticulos *articulos){
 int aux,i,total,cont=11;
 int numArticulos, indiceArticulo;
 char car;
 char *endp;
 char cadAux[500];
 total = configuracion[TEXTO_ARTICULOS].size;
 cadAux[0]='\0';
 i=0;
 car=((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];;
 while ((car!=']')&&(car!=10)){
  if (car!=13){
   cadAux[i]=car;
   i++;
  }
  cont++;
  car=((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];
 }
 cadAux[i]='\0';
 numArticulos = strtod(cadAux,&endp);
 articulos->numArticulos = numArticulos;
 
 cadAux[0]='\0';
 car=((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];
 while (car!=10){
  cont++;
  car=((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];
 }
 cont++;

 
 for (i=1;i<=numArticulos;i++){//Pongo todos los articulos
  car=0;
  aux=0;
  while (car!=' '){
   car = ((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];
   if ((car!=10)&&(car!=13)){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  indiceArticulo=(int)strtod(cadAux,&endp); //Cojo el indice del texto
  articulos->articulo[i-1] = indiceArticulo;
  cadAux[0]='\0';

  car=0;
  aux=0;  
  while (car!=10){
   car = ((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];
   if ((car!=10)&&(car!=13)){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  articulos->textoArticulo[i-1] = malloc((sizeof(char)*aux)+1);
  strcpy(articulos->textoArticulo[i-1],cadAux);
  cadAux[0]='\0';

  //Aqui cogemos el nombre del autor
  car=0;
  aux=0;  
  while (car!=10){
   car = ((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];
   if ((car!=10)&&(car!=13)){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  articulos->textoPlataForma[i-1] = malloc((sizeof(char)*aux)+1);
  strcpy(articulos->textoPlataForma[i-1],cadAux);
  cadAux[0]='\0';

  car=0;
  aux=0;  
  while (car!=10){
   car = ((char *)configuracion[TEXTO_ARTICULOS].dat)[cont];
   if ((car!=10)&&(car!=13)){
    cadAux[aux]=car;
    aux++;
   }
   cont++;
  }
  cadAux[aux]='\0';
  articulos->textoAutor[i-1] = malloc((sizeof(char)*aux)+1);
  strcpy(articulos->textoAutor[i-1],cadAux);
  cadAux[0]='\0';  
 }
}

/************************************************/
void MostrarArticulosPantalla(TArticulos *losArticulos, BITMAP *pantalla){
 int i,numeros,articuloActual;
 int blanco = makecol(255,255,255);
 int amarillo = makecol(226,240,40);//makecol(128,128,255);
 numeros = losArticulos->numArticulos;
 articuloActual = losArticulos->articuloActual;
 textout_centre(pantalla, datafile[FUENTE_PC].dat,(losArticulos->textoArticulo[articuloActual]),319,410,blanco); //Soporta 80 caracteres y 30 filas
 for (i=1;i<6;i++)
  if (i+articuloActual<numeros) textout_centre(pantalla, datafile[FUENTE_XM].dat,(losArticulos->textoArticulo[i+articuloActual]),319,410+(i*10),amarillo); //Soporta 80 caracteres y 30 filas

}

/************************************************/
void ScrollArribaArticulos(TArticulos *losArticulos, BITMAP *pantalla){
 if (losArticulos->articuloActual>0){
  losArticulos->articuloActual-=1;
  rectfill(pantalla,120,400,520,470,bitmap_mask_color(pantalla));
  MostrarArticulosPantalla(losArticulos,pantalla);
  if (!grises) select_palette(configuracion[PALETA_BARRA].dat);
  blit(configuracion[FOTO_BARRA].dat,videoTemporal,120,0,120,400,400,70);
  masked_blit(pantalla,videoTemporal,120,400,120,400,400,70);
  //if ((raton)&&(mouse_x>=120)&&(mouse_x<520)&&(mouse_y>=380)&&(mouse_y<470)){
  if (raton){
   show_mouse(NULL);
   blit(videoTemporal,screen,120,400,120,400,400,70);
   show_mouse(screen);
  }
  else blit(videoTemporal,screen,120,400,120,400,400,70);
 }
}

/************************************************/
void ScrollAbajoArticulos(TArticulos *losArticulos, BITMAP *pantalla){
 if (losArticulos->articuloActual<(losArticulos->numArticulos-1)){
  losArticulos->articuloActual+=1;
  rectfill(pantalla,120,400,520,470,bitmap_mask_color(pantalla));
  MostrarArticulosPantalla(losArticulos,pantalla);
  if (!grises) select_palette(configuracion[PALETA_BARRA].dat);
  blit(configuracion[FOTO_BARRA].dat,videoTemporal,120,0,120,400,400,70);
  masked_blit(pantalla,videoTemporal,120,400,120,400,400,70);
  //if ((raton)&&(mouse_x>=120)&&(mouse_x<520)&&(mouse_y>=380)&&(mouse_y<470)){
  if (raton){
   show_mouse(NULL);
   blit(videoTemporal,screen,120,400,120,400,400,70);
   show_mouse(screen);
  }
  else blit(videoTemporal,screen,120,400,120,400,400,70);
 }
}

/************************************************/
void InicializarLosArticulos(TArticulos *losArticulos){
 unsigned char i;
 losArticulos->numArticulos = 0;
 losArticulos->articuloActual = 0;
 for (i=0;i<maxArticulos;i++){
  losArticulos->articulo[i]=0;
  losArticulos->textoArticulo[i]=NULL;
  losArticulos->textoPlataForma[i]=NULL;
  losArticulos->textoAutor[i]=NULL;
 }
}

/************************************************/
void EliminarLosArticulos(TArticulos* losArticulos){
 losArticulos->numArticulos = 0;
 losArticulos->articuloActual = 0;
 for (i=0;i<maxArticulos;i++){
  losArticulos->articulo[i]=0;
  free(losArticulos->textoArticulo[i]); //Libero la memoria ocupada
  free(losArticulos->textoPlataForma[i]);
  free(losArticulos->textoAutor[i]);
  losArticulos->textoArticulo[i]=NULL;  //Por si acaso no la libera
  losArticulos->textoPlataForma[i]=NULL;
  losArticulos->textoAutor[i]=NULL;
 }
}

/************************************************/
void ControlaEventos(){
 int salir=0;
 int scancode=0;
 int ratonX=0,ratonY=0;    //Para los mickeys del raton
 while (!salir){
  if (keypressed()){
   scancode = readkey()>>8;
   switch(scancode){
    case KEY_ENTER: EliminarArticulo();
                    InicializarArticulo();
                    MostrarArticulo(losArticulos.articulo[(losArticulos.articuloActual)]);
                    break;
    case KEY_ESC: salir = 1; break;
    case KEY_UP: ScrollAbajo(); break;
    case KEY_DOWN: ScrollArriba(); break;
    case KEY_PGUP: ScrollAbajo30Lineas(); break;
    case KEY_PGDN: ScrollArriba30Lineas(); break;
    case KEY_LEFT: ScrollArribaArticulos(&losArticulos,letras); break;
    case KEY_RIGHT: ScrollAbajoArticulos(&losArticulos,letras); break;
    case KEY_F12: save_pcx("screen.pcx",videoTemporal,NULL); break;
    case KEY_F10: save_pcx("screen.pcx",videoTemporal,NULL); break;
    case KEY_PLUS_PAD: ReguladorVolumen(mas); break;
    case KEY_MINUS_PAD: ReguladorVolumen(menos); break;
    case KEY_S: AccionSonido(); break;
   }
  }

  if (raton){
   get_mouse_mickeys(&ratonX,&ratonY);
   if ((mouse_b & 2)&&(ratonY!=0)){
       if (ratonY>0) ScrollArriba();
       if (ratonY<0) ScrollAbajo();
     }

   if ((mouse_b & 4)&&(ratonY!=0)){
     if (ratonY>0) ScrollAbajoArticulos(&losArticulos,letras);
     if (ratonY<0) ScrollArribaArticulos(&losArticulos,letras);
   }
   
   if (mouse_b & 1) {
     while (mouse_b!=0); //Se ha liberado el boton
     if ((mouse_y>400)&&(mouse_y<480)&&(mouse_x>=0)&&(mouse_x<80)) AccionSonido();
     else{
      if ((mouse_y>400)&&(mouse_y<480)&&(mouse_x>560)&&(mouse_x<640)){
       while (mouse_b!=0); //Se ha liberado el boton
       salir = 1;
      }
      else{
       EliminarArticulo();
       InicializarArticulo();
       MostrarArticulo(losArticulos.articulo[(losArticulos.articuloActual)]);
      }
     }
   }
  }
 }
}

/************************************************/
void MostrarTitulo(BITMAP *pantalla){
 //Muestra el titulo del articulo en la zona superior izquierda
 int azulado = makecol(128,255,255);
 int blanco = makecol(255,255,255);
  rectfill(pantalla,0,60,463,80,bitmap_mask_color(pantalla));

  textout(pantalla, datafile[FUENTE_XM].dat,"Seccion",0,50,azulado); //Soporta 80 caracteres y 30 filas
  textout(pantalla, datafile[FUENTE_XM].dat,losArticulos.textoPlataForma[(losArticulos.articuloActual)],64,50,blanco); //Soporta 80 caracteres y 30 filas

  textout(pantalla, datafile[FUENTE_XM].dat,"Titulo",0,60,azulado); //Soporta 80 caracteres y 30 filas
  textout(pantalla, datafile[FUENTE_XM].dat,losArticulos.textoArticulo[(losArticulos.articuloActual)],64,60,blanco); //Soporta 80 caracteres y 30 filas
  
  textout(pantalla, datafile[FUENTE_XM].dat,"Autor",0,70,azulado); //Soporta 80 caracteres y 30 filas
  textout(pantalla, datafile[FUENTE_XM].dat,losArticulos.textoAutor[(losArticulos.articuloActual)],64,70,blanco); //Soporta 80 caracteres y 30 filas
  if (!grises) select_palette(configuracion[PALETA_LOGO].dat);
  blit(configuracion[FOTO_LOGO].dat,videoTemporal,0,50,0,50,464,30);
  masked_blit(pantalla,videoTemporal,0,50,0,50,464,30);
}

/************************************************/
void MostrarInfoArticulo(BITMAP *pantalla){
//Muestra las p ginas totales del articulo y la situaci¢n en el mismo
  int filas,filaActual;
  char cadena[33];
  char temp[128];
  filas = elArticulo.numFilas;
  filaActual = elArticulo.posFila;
  filaActual /= 30;
  filas /=30;
  if (((filas % 30)!=0)||(filas<30)) filas+=1;
  if (((filaActual % 30)!=0)||(filaActual<30)) filaActual+=1;
  if (filaActual>filas) filaActual=filas;
  itoa(filaActual,cadena,10);
  strcpy(temp,cadena);
  strcat(temp,"/");
  itoa(filas,cadena,10);
  strcat(temp,cadena);
  strcat(temp," pag");
  rectfill(pantalla,540,45,639,75,bitmap_mask_color(pantalla));
  textout(pantalla, datafile[FUENTE_GRANDE].dat,temp,540,45,makecol(255,255,255)); //Soporta 80 caracteres y 30 filas
  if (!grises) select_palette(configuracion[PALETA_LOGO].dat);
  blit(configuracion[FOTO_LOGO].dat,videoTemporal,540,45,540,45,100,30);
  masked_blit(pantalla,videoTemporal,540,45,540,45,100,30);
//  blit(videoTemporal,screen,540,50,540,50,100,30); Para volcar a video se encarga otro
}

/************************************************/
void MostrarBotones(){
 int i;
 if (!grises) select_palette(configuracion[PALETA_BARRA].dat);
 blit(configuracion[FOTO_BARRA].dat,videoTemporal,0,0,0,400,640,80);
 if (sonido==FALSE){
  for (i=0;i<6;i++){
   line(videoTemporal,16+i,422,56+i,460,makecol(255,0,0));
   line(videoTemporal,16+i,460,56+i,422,makecol(255,0,0));
  }
 }
}

/************************************************/
/*int JustificacionIzquierda(char *cadena,enum TitemLetra tipoLetra){
//Saca los pixels X que debe de poner en testout para justificar
 int longitud=strlen(cadena);
 int i=0;
 if (longitud>0){
  while ((cadena[i]==' ')&&(i<longitud))
   i++;
 };
 switch (tipoLetra){
  case letra_grande: i=(i<<8)+(i<<1); break; //i=i*16
  default:  i = (i<<3); //i=i*8;
 }
 return (i);
}*/

/************************************************/
int JustificacionDerecha(char *cadena,int tipoLetra){
//Saca los pixels X que debe de poner en testout para justificar
 int longitud=strlen(cadena);
 int i=longitud;
 if (longitud>0){
  while ((cadena[i]==' ')&&(i>=0))
   i--;
 };
 switch (tipoLetra){
  case FUENTE_GRANDE:  i=(i<<3)+(i<<1); break; //i=i*10
  default:  i = (i<<3); //i=i*8;
 } 
 return (i);
}


/************************************************/
void ScrollArriba30Lineas(){
 //Si pulsamod KEY_PUAGDOWN
 int auxiliar;
 int i,j=0,total=0;

 if (elArticulo.posFila<elArticulo.numFilas){
/*  if ((elArticulo.posFila+30)>(elArticulo.numFilas))
   total= elArticulo.numFilas - elArticulo.posFila;
  else*/
   total=30;
  if (!grises) select_palette(configuracion[PALETA_FONDO].dat);
  blit(fondo,videoTemporal,0,0,0,80,640,320);
  //rectfill(videoTemporal,0,400,640,400,0);
  rectfill(letras,0,90,639,400,bitmap_mask_color(letras));


  for (i=(elArticulo.posFila+1);i<(elArticulo.posFila+total+1);i++,j++){
   if (elArticulo.info[i].cadena!=NULL){
/*    switch (elArticulo.info[i].item.color){
     case color_rojo: color = rojo; break;
     case color_verde: color= verde; break;
     case color_azul: color = azul; break;
     case color_negro: color = negro; break;
     case color_blanco: color = blanco; break;
     case color_marron: color = marron; break;
     case color_amarillo: color = amarillo; break;
     case color_violeta: color = violeta; break;
     case color_verdefosforito: color = verdeFosforito; break;
     case color_azulclaro: color = azulClaro; break;
     case color_naranja: color = naranja; break;
     case color_gris: color = gris; break;
     case color_grisclaro: color = grisClaro; break;
     default: color = blanco;
    }*/

/*    switch (elArticulo.info[i].item.letra){
     case letra_grande: indiceFuente = FUENTE_GRANDE; break;
     case letra_normal: indiceFuente = FUENTE_NORMAL; break;
     case letra_pc: indiceFuente = FUENTE_PC; break;
     case letra_pct: indiceFuente = FUENTE_PCT; break;
     case letra_xm: indiceFuente = FUENTE_XM; break;
     case letra_xmb: indiceFuente = FUENTE_XMB; break;
     case letra_xmi: indiceFuente = FUENTE_XMI; break;
     default: indiceFuente = FUENTE_XM;
    }*/

    auxiliar = 90+(j<<3)+(j<<1);
    switch (elArticulo.info[i].item.justificacion){
     case nojustificado: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
                         //textout(letras, datafile[indiceFuente].dat,elArticulo.info[i].cadena,0,(90+j*10),color); break;
     case centro: textout_centre(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,319,auxiliar,elArticulo.info[i].item.color); break;
     case izquierda: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
                     //textout_justify(letras, datafile[indiceFuente].dat,elArticulo.info[i].cadena,JustificacionIzquierda(elArticulo.info[i].cadena,elArticulo.info[i].item.letra),639,(90+j*10),640,color); break;
     case derecha: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,(639-desX_cadena-JustificacionDerecha(elArticulo.info[i].cadena,elArticulo.info[i].item.letra)),auxiliar,elArticulo.info[i].item.color); break;//Soporta 80 caracteres y 30 filas
    }
    //textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,0,(90+j*10),elArticulo.info[i].item.color);


    if ((elArticulo.info[i].item.laFoto.numFoto)!=0){
      if (!grises) select_palette(*(elArticulo.paletas[((elArticulo.info[i].item.laFoto.numFoto))]));
      blit(elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)],letras,0,elArticulo.info[i].item.laFoto.yIni,(((elArticulo.info[i].item.laFoto.xIni)<<3)+desX_cadena),auxiliar,elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)]->w,10);
    }

    
   }
  }
  elArticulo.posFila+=total;
  masked_blit(letras,videoTemporal,0,0,0,0,640,480);
  MostrarInfoArticulo(letras);
  //if ((raton)&&(mouse_y>=30)&&(mouse_y<400)){
  if (raton){
   show_mouse(NULL);
   blit(videoTemporal,screen,0,50,0,50,640,350);
   show_mouse(screen);
  }
  else blit(videoTemporal,screen,0,50,0,50,640,350);
 }
}

/************************************************/
void ScrollAbajo30Lineas(){
 //Si pulsamos KEY_PUAGUP
 int auxiliar;
 int i,j=0,total=0;

 if (elArticulo.posFila>29){
  total=30;
  if (elArticulo.posFila<60)
   elArticulo.posFila = 0;
  else
   elArticulo.posFila = elArticulo.posFila-59;
   
  if (!grises) select_palette(configuracion[PALETA_FONDO].dat);
  blit(fondo,videoTemporal,0,0,0,80,640,320);
  //rectfill(videoTemporal,0,400,640,400,0);
  rectfill(letras,0,90,639,400,bitmap_mask_color(letras));


  for (i=(elArticulo.posFila);i<(elArticulo.posFila+total);i++,j++){
   if (elArticulo.info[i].cadena!=NULL){
/*    switch (elArticulo.info[i].item.color){
     case color_rojo: color = rojo; break;
     case color_verde: color= verde; break;
     case color_azul: color = azul; break;
     case color_negro: color = negro; break;
     case color_blanco: color = blanco; break;
     case color_marron: color = marron; break;
     case color_amarillo: color = amarillo; break;
     case color_violeta: color = violeta; break;
     case color_verdefosforito: color = verdeFosforito; break;
     case color_azulclaro: color = azulClaro; break;
     case color_naranja: color = naranja; break;
     case color_gris: color = gris; break;
     case color_grisclaro: color = grisClaro; break;
     default: color = blanco;
    }*/

/*    switch (elArticulo.info[i].item.letra){
     case letra_grande: indiceFuente = FUENTE_GRANDE; break;
     case letra_normal: indiceFuente = FUENTE_NORMAL; break;
     case letra_pc: indiceFuente = FUENTE_PC; break;
     case letra_pct: indiceFuente = FUENTE_PCT; break;
     case letra_xm: indiceFuente = FUENTE_XM; break;
     case letra_xmb: indiceFuente = FUENTE_XMB; break;
     case letra_xmi: indiceFuente = FUENTE_XMI; break;
     default: indiceFuente = FUENTE_XM;
    }*/

    auxiliar = 90+(j<<3)+(j<<1);
    switch (elArticulo.info[i].item.justificacion){
     case nojustificado: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
                         //textout(letras, datafile[indiceFuente].dat,elArticulo.info[i].cadena,0,(90+j*10),color); break;
     case centro: textout_centre(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,319,auxiliar,elArticulo.info[i].item.color); break;
     case izquierda: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,desX_cadena,auxiliar,elArticulo.info[i].item.color); break;
                     //textout_justify(letras, datafile[indiceFuente].dat,elArticulo.info[i].cadena,JustificacionIzquierda(elArticulo.info[i].cadena,elArticulo.info[i].item.letra),639,(90+j*10),640,color); break;
     case derecha: textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,(639-desX_cadena-JustificacionDerecha(elArticulo.info[i].cadena,elArticulo.info[i].item.letra)),auxiliar,elArticulo.info[i].item.color); break;//Soporta 80 caracteres y 30 filas
    }
    //textout(letras, datafile[(elArticulo.info[i].item.letra)].dat,elArticulo.info[i].cadena,0,(90+j*10),elArticulo.info[i].item.color);


    if ((elArticulo.info[i].item.laFoto.numFoto)!=0){
      if (!grises) select_palette(*(elArticulo.paletas[((elArticulo.info[i].item.laFoto.numFoto))]));
      blit(elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)],letras,0,elArticulo.info[i].item.laFoto.yIni,(((elArticulo.info[i].item.laFoto.xIni)<<3)+desX_cadena),auxiliar,elArticulo.fotos[(elArticulo.info[i].item.laFoto.numFoto)]->w,10);
    }

    
   }
  }
  elArticulo.posFila=elArticulo.posFila+29;
  masked_blit(letras,videoTemporal,0,0,0,0,640,480);
  MostrarInfoArticulo(letras);
  //if ((raton)&&(mouse_y>=30)&&(mouse_y<400)){
  if (raton){
   show_mouse(NULL);
   blit(videoTemporal,screen,0,50,0,50,640,350);
   show_mouse(screen);
  }
  else blit(videoTemporal,screen,0,50,0,50,640,350);
 }
}

/************************************************/
void AccionSonido(){
 int i;
 if (driverSonido){
  if (sonido){
   sonido = FALSE;
   if (!grises) select_palette(configuracion[PALETA_BARRA].dat);
   blit(configuracion[FOTO_BARRA].dat,videoTemporal,0,0,0,400,80,80);
   for (i=0;i<6;i++){
    line(videoTemporal,16+i,422,56+i,460,makecol(255,0,0));
    line(videoTemporal,16+i,460,56+i,422,makecol(255,0,0));
   }
   pause_mod(); //Para el MOD
  }
  else{
   sonido = TRUE;
   if (!grises) select_palette(configuracion[PALETA_BARRA].dat);
   blit(configuracion[FOTO_BARRA].dat,videoTemporal,0,0,0,400,80,80);
   resume_mod();
  }
  //if ((mouse_y>=380)&&(mouse_y<480)&&(mouse_x>=0)&&(mouse_x<80)){
  if (raton){
   show_mouse(NULL);
   blit(videoTemporal,screen,0,400,0,400,80,80);
   show_mouse(screen);
  }
  else blit(videoTemporal,screen,0,400,0,400,80,80);
 }
}

/************************************************/
void HacerJustificacion(char *cadena,int tipoLetra,enum TitemJustificacion justificacion){
 char cadAux[500];
 unsigned char listaEspacios[500];
 int i=0;
 int j=0;
 int espacios=0;  //contiene el n1 de espacios en la cadena original
 int espaciosIzquierda=0; //Los espacios a la izquierda de la cadena
 int espacioLibre;        //El espacio libre que queda a la derecha
 int bucleEspacios=0;     //El n§ de espacios a poner en cada espacio original
 int resto=0;
 int cont=0;
 int longitud=strlen(cadena);
 int salir;
 int indiceEspacio;
 int topeCadena=0;
 
 strcpy(cadAux,cadena);
 if (longitud>0){
  //Salto todos los espacios en blanco de la izquierda
  while ((cadAux[i]==' ')&&(i<longitud))
   i++;
  espaciosIzquierda = i;
   //Cuento espacios en blanco
  while(i<longitud){
   if (cadAux[i]==' ') espacios++;
   i++;
  }

  if (justificacion==izquierda){
   switch (tipoLetra){
    case FUENTE_GRANDE:   topeCadena= 64; break;
    default: topeCadena = longitud_cadena;
   }

   espacioLibre = topeCadena-longitud;
   if (espacios==0){
    bucleEspacios = 0;
    resto = 0;
   }
   else{
    bucleEspacios = espacioLibre/espacios;
    resto = espacioLibre % espacios;
   }

   cont=espaciosIzquierda;
   indiceEspacio=0;
   if (espacioLibre<espacios){
    for (i=espaciosIzquierda;i<longitud;i++,cont++){
     if ((cadAux[i]==' ')&&(indiceEspacio<resto)){
      cadena[cont]=' ';
      cadena[cont+1]=' ';
      cont++;
      indiceEspacio++;
     }
     else cadena[cont]=cadAux[i];
    }
    cadena[cont]='\0';
   }
   else{
    indiceEspacio=0;
    for (i=0;i<espacios;i++) listaEspacios[i]=bucleEspacios+1;
    for (i=0;i<resto;i++) listaEspacios[i]++;
    for (i=espaciosIzquierda;i<longitud;i++,cont++){
     if (cadAux[i]==' '){
      for (j=0;j<listaEspacios[indiceEspacio];j++,cont++)
       cadena[cont]=' ';
      indiceEspacio++;
      cont--;
     }
     else cadena[cont]=cadAux[i];
    }
    cadena[cont]='\0';
   }
  }
 }
}

/************************************************/
void GeneraColores(){
  color_rojo = makecol(255,0,0); color_verde = makecol(0,180,0); //Para optimizar
  color_azul = makecol(0,0,255); color_negro = makecol(0,0,0);
  color_blanco = makecol(255,255,255);  color_marron = makecol(178,139,4);
  color_amarillo = makecol(252,255,17); color_violeta = makecol(211,128,246);
  color_verdeFosforito = makecol(80,255,66); color_azulClaro = makecol(29,226,255);
  color_naranja = makecol(255,125,29);       color_gris = makecol(136,148,152);
  color_grisClaro = makecol(222,230,231);
}

/************************************************/
void inc_crono(){
 crono++;
}
END_OF_FUNCTION(inc_crono);

/************************************************/
void Presentacion(DATAFILE *datos){
//Muestra la foto de portada y hace efecto FADER
 BITMAP *foto;
 BITMAP *issue;
 BITMAP *exilium;
 int posX,posY;
 foto = datos[FOTO_PRESENTACION].dat;
 issue = datos[FOTO_ISSUE].dat;
 exilium = datos[FOTO_EXILIUM].dat;
 posX = (640-(foto->w))>>1;
 posY = (480-(foto->h))>>1;
 set_color_depth(8);
 if (set_gfx_mode(GFX_AUTODETECT,640,480,0,0)!=0){
  allegro_exit();
  printf("Error en modo de video");
  exit(-1);
 }
 set_palette(black_palette);

 
 blit(foto,screen,0,0,posX,posY,foto->w,foto->h);
 ActivaMOD(); //Activamos la musica
 LOCK_VARIABLE(crono);
 LOCK_FUNCTION(inc_crono);
 install_int(inc_crono,500); //Arranco el temporizador de segundos
 

 Desfundir (datos[PALETA_PRESENTACION].dat);
 //fade_in(datos[PALETA_PRESENTACION].dat,1);

 while (crono<27);
 //Mostrar Issue a los 13.5 segundos
 masked_blit(issue,screen,0,0,505,340,issue->w,issue->h);
 

 while (crono<33);
 //Mostrar Diskmag Exsilium (Destierro) a los 16.5 segundos
 masked_blit(exilium,screen,0,0,25,30,exilium->w,exilium->h);
 

 while (crono<46); //Espera a fundir a los 23 segundos
 //fade_out(1);
 Fundir();

 while (crono<51); //Espera a los 25.5 segundos
 
 
 remove_int(inc_crono);
}

/************************************************/
int ActivaMOD(){
 char car, aux[255], archivoSonido[255];
 char *endp;
 int i,cont,tope,numCanales=0;

 //Cogemos el nombre del archivo de sonido
 archivoSonido[0]='\0';
 i=0;
 tope = configuracion[TEXTO_SONIDO].size;
 car = ((char *)configuracion[TEXTO_SONIDO].dat)[i];
 while ((car!=' ')&&(i<tope)){
  archivoSonido[i] = car;
  i++;
  car = ((char *)configuracion[TEXTO_SONIDO].dat)[i];
 }
 archivoSonido[i]='\0'; 

 //Leemos el numero de canales
 i++;
 cont = 0;
 aux[0]='\0';
 car = ((char *)configuracion[TEXTO_SONIDO].dat)[i];
 while ((car!=13)&&(car!=10)&&(i<tope)){
  aux[cont] = car;
  i++;
  cont++;  
  car = ((char *)configuracion[TEXTO_SONIDO].dat)[i];
 }
 aux[cont]='\0';
 numCanales = strtod (aux,&endp);

 
 
    reserve_voices (numCanales, -1);     // call this before install_sound if needed
    if (install_sound (DIGI_AUTODETECT, MIDI_NONE, NULL) < 0)
        {
        //printf ("Error initializing sound card");
        return -1;
        }

    if (install_mod (numCanales) < 0)    // call install_mod only after install_sound
        {
        //printf ("Error setting digi voices");
        return -1;
        }

    archivoMOD = load_mod (archivoSonido);
    if (archivoMOD == NULL)
        {
        //printf ("Error reading introgho.mod");
        return -1;
        }

    play_mod (archivoMOD, TRUE);
    sonido = driverSonido = TRUE;
}


/************************************************/
void DestruyeMOD(){
 stop_mod();
 destroy_mod (archivoMOD);
}

/************************************************/
void Fundir(){
  //Soluciona el problema del retrazo en VOODOO
 PALETTE paleta;
 boolean salir = FALSE; 
 short int i = 0;
 unsigned char j; 
 get_palette(paleta);
 while (!salir){
  salir = TRUE;
  for (i=0;i<256;i++){
   if (paleta[i].r!=0){
     salir = FALSE;
     paleta[i].r -=1;
   }
   if (paleta[i].g!=0){
     salir = FALSE;
     paleta[i].g -=1;
   }
   if (paleta[i].b!=0){
     salir = FALSE;
     paleta[i].b -=1;
   }
  }

  for (j=0;j<2;j++)
   vsync();
  set_palette(paleta);
 }
}

/************************************************/
void Desfundir(PALETTE paleta){
//Desfunde la imagen bien en VODOO
 PALETTE pal;
 boolean salir = FALSE;
 unsigned char j;
 short int i = 0;
 
 get_palette(pal);
 while (!salir){
  salir = TRUE;
  for (i=0;i<256;i++){
   if (pal[i].r!=paleta[i].r){
     salir = FALSE;
     pal[i].r +=1;
   }
   if (pal[i].g!=paleta[i].g){
     salir = FALSE;
     pal[i].g +=1;
   }
   if (pal[i].b!=paleta[i].b){
     salir = FALSE;
     pal[i].b +=1;
   }
  }

  for (j=0;j<4;j++)
   vsync();
  set_palette(pal);
 }
}

/************************************************/
void Despedida(DATAFILE *datos){
 BITMAP *foto;
 BITMAP *issue;
 BITMAP *exilium;
 short int i;
 int posX,posY;
 foto = datos[FOTO_PRESENTACION].dat;
 issue = datos[FOTO_ISSUE].dat;
 exilium = datos[FOTO_EXILIUM].dat;
 posX = (640-(foto->w))>>1;
 posY = (480-(foto->h))>>1;
 set_color_depth(8);
 if (set_gfx_mode(GFX_AUTODETECT,640,480,0,0)!=0){
  allegro_exit();
  printf("Error en modo de video");
  exit(-1);
 }
 set_palette(black_palette);

 
 blit(foto,screen,0,0,posX,posY,foto->w,foto->h);
 masked_blit(issue,screen,0,0,505,340,issue->w,issue->h);
 masked_blit(exilium,screen,0,0,25,30,exilium->w,exilium->h); 
 crono=0;
 LOCK_VARIABLE(crono);
 LOCK_FUNCTION(inc_crono);
 install_int(inc_crono,500); //Arranco el temporizador de segundos

 Desfundir (datos[PALETA_PRESENTACION].dat);
 //fade_in(datos[PALETA_PRESENTACION].dat,1);

 
 while (crono<9);

 Fundir(); 
 
 remove_int(inc_crono);
}

/************************************************/
void ReguladorVolumen(unsigned char tipo){
 short int volumen,i;
 boolean salir=FALSE;
 BITMAP *captura;
 captura = create_bitmap(640,50);
 volumen = get_mod_volume();

 //if ((raton)&&(mouse_y>=300)&&(mouse_y<370)){
 if (raton){
   show_mouse(NULL);
   blit(screen,captura,0,320,0,0,640,50);
   show_mouse(screen);   
 }
 else blit(screen,captura,0,320,0,0,640,50);

 switch(tipo){
  case mas: while (key[KEY_PLUS_PAD]){
             if (volumen<251) volumen +=5;
             //if ((raton)&&(mouse_y>=300)&&(mouse_y<370)){
             if (raton){
               show_mouse(NULL);
               vsync();
               triangle(screen,5,365,45,325,45,365,color_verdeFosforito);
               rectfill(screen,70,325,(volumen<<1)+70,365,color_verdeFosforito);
               show_mouse(screen);
             }
             else{
              vsync();
              triangle(screen,5,365,45,325,45,365,color_verdeFosforito);
              rectfill(screen,70,325,(volumen<<1)+70,365,color_verdeFosforito);
             }
             set_mod_volume(volumen);
            }
            break;
  
  case menos: while (key[KEY_MINUS_PAD]){
               if (volumen>5) volumen-=5;
               //if ((raton)&&(mouse_y>=300)&&(mouse_y<370)){
               if (raton){
                show_mouse(NULL);
                vsync();
                blit(captura,screen,0,0,0,320,640,50);
                triangle(screen,5,365,45,325,45,365,color_verdeFosforito);
                rectfill(screen,70,325,(volumen<<1)+70,365,color_verdeFosforito);
                show_mouse(screen);
               }
               else{
                vsync();
                blit(captura,screen,0,0,0,320,640,50);
                triangle(screen,5,365,45,325,45,365,color_verdeFosforito);
                rectfill(screen,70,325,(volumen<<1)+70,365,color_verdeFosforito);
               }
               set_mod_volume(volumen);
              }
              break;
 }

 //if ((raton)&&(mouse_y>=300)&&(mouse_y<370)){
 if (raton){
  show_mouse(NULL);
  blit(captura,screen,0,0,0,320,640,50);
  show_mouse(screen);
 }
 else blit(captura,screen,0,0,0,320,640,50);

 destroy_bitmap(captura);

 
// vsync();
}

/************************************************/
void MostrarLineaComandos(void){
 printf("\n Diskmag Exilium issue #1   Grupo: SLIDERS   Fecha: 26-4-2002\n");
 printf("==============================================================\n\n");
 printf(" exilium [8|16] [no] [/?|?] [setup]\n\n");
 printf("   8    --> 8 bits de color\n");
 printf("  16    --> 16 bits de color\n");
 printf("  no    --> No visualiza la presentacion\n");
 printf("  /?    --> Muestra ayuda\n\n");
 printf("Ejemplo: exilium 8 no        Sin prensentacion y 256 colores\n");
 printf("         exilium /?          Muestra esta ayuda\n\n");
 printf("Por defecto arranca en 16 bits de color y con presentacion\n");
}

/************************************************/
/*void LeerArticuloDisco(char *nombre,TArticulo articulo){
 FILE *fichero;
 char *buffer;
 int i,tamanio, leidos;
 fichero = fopen(nombre,"rb");
 if (fichero!=NULL){
  fseek(fichero,0L,SEEK_END);
  tamanio = ftell(fichero);
  fseek(fichero,0L,SEEK_SET);
  buffer = (char *)malloc(tamanio);
  leidos = fread(buffer,sizeof(char),tamanio,fichero);
 }
 if (articulo!=NULL) free(articulo);
 articulo = buffer;
 fclose(fichero);
 printf("%d bytes\n",tamanio);
 for (i=0;i<tamanio;i++)
  printf("%c",articulo[i]);
}  */
