/************
/* DISKMAG */
/***********/
#include <allegro.h>
#include <jpeg.h>
#include <stdio.h>
#include <string.h>
#include "datos.h"
/*******************************/
/* id 0 texto normal           */
/* id 1 texto color rojo       */
/* id 2 texto color negro      */
/*******************************/

enum TitemColor{color_rojo,color_verde,color_azul,color_negro,color_blanco,color_marron,color_amarillo,color_violeta,color_verdefosforito,color_azulclaro,color_naranja};
enum TitemJustificacion{derecha,izquierda,centro};
enum TitemLetra{letra_grande,letra_normal,letra_pc,letra_pct,letra_xm,letra_xmb,letra_xmi};

typedef struct{
 enum TitemColor color;
 enum TitemLetra letra;
 enum TitemJustificacion justificacion;
}TitemDatos;

typedef struct {
 TitemDatos item;
 char *cadena;
}Tnodo;


typedef struct{
 int numFilas;     //El numero de filas del documento
 int posFila; //La fila actual del documento
 Tnodo info[1000];
 char *texto[1000];
 BITMAP *fotos[20];
}TArticulo; //Contiene todo el articulo

int i;
int scancode;
TArticulo elArticulo; //GLOBAL Aqui guardo el Articulo
PALETTE paleta;
BITMAP *fondo = NULL;
BITMAP *letras = NULL;
BITMAP *videoTemporal = NULL;
BITMAP *auxBitmap = NULL;
DATAFILE *datafile;     //GLOBAL Contiene los datos de la revista

void ScrollArriba();
void ScrollAbajo();
void LeerArchivoDatos(char *nombre);
void BuscarItem(char *cad, TitemDatos * itemDatos);
void MostrarArticulo(int indice);
void InicializarArticulo();
void EliminarArticulo();
//void LeerArticuloDisco(char *nombre,TArticulo articulo);

int main(void){
 allegro_init();
 LeerArchivoDatos("datos.dat");
 install_keyboard();
 set_color_depth(16);
 letras = create_bitmap(640,480);
 auxBitmap = create_bitmap(640,480);
 videoTemporal = create_bitmap(640,480);
 clear_to_color(letras,bitmap_mask_color(letras));
 set_gfx_mode(GFX_AUTODETECT,640,480,0,0);
 fondo = load_jpeg("ola.jpg", paleta);
 set_palette(paleta);
 hline(fondo,0,80,639,0xFFFFFF);  //Lineas separatorias
 hline(fondo,0,400,639,0xFFFFFF);

 InicializarArticulo();
 MostrarArticulo(TEXTO_DELABU);
 set_gfx_mode(GFX_TEXT,80,25,0,0);
 for (i=0;i<10;i++){
  printf("%d ",elArticulo.info[i].item.color);
 }
 
 EliminarArticulo();
 
/* set_gfx_mode(GFX_TEXT,80,25,0,0);
 for (i=78;i<100;i++){
  printf("%d %c ",((char *)datafile[TEXTO_REVISTA].dat)[i],((char *)datafile[TEXTO_REVISTA].dat)[i]);
 }*/

 unload_datafile(datafile);
 destroy_bitmap(auxBitmap);
 destroy_bitmap(letras);
 destroy_bitmap(videoTemporal);
 destroy_bitmap(fondo);
 remove_keyboard();
 allegro_exit();
 printf("Numero filas: %d \nFila actual: %d",elArticulo.numFilas,elArticulo.posFila);
 return (0);
}


/************************************************/
void ScrollArriba(){
 int i,j=0,total=0, color=color_blanco, indiceFuente=FUENTE_XM;
 if (elArticulo.posFila<elArticulo.numFilas){
  total = elArticulo.numFilas-elArticulo.posFila;
  if (total>=5) total=5;
  blit(fondo,videoTemporal,0,0,0,0,640,480);
  blit(letras,letras,0,140,0,90,640,300);
  for (i=(elArticulo.posFila+1);i<(elArticulo.posFila+total+1);i++,j++){
   if (elArticulo.info[i].cadena!=NULL){
    switch (elArticulo.info[i].item.color){
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
     default: color = makecol(255,255,255);
    }

    switch (elArticulo.info[i].item.letra){
     case letra_grande: indiceFuente = FUENTE_GRANDE; break;
     case letra_normal: indiceFuente = FUENTE_NORMAL; break;
     case letra_pc: indiceFuente = FUENTE_PC; break;
     case letra_pct: indiceFuente = FUENTE_PCT; break;
     case letra_xm: indiceFuente = FUENTE_XM; break;
     case letra_xmb: indiceFuente = FUENTE_XMB; break;
     case letra_xmi: indiceFuente = FUENTE_XMI; break;
     default: indiceFuente = FUENTE_XM;
    }
    textout(letras, datafile[indiceFuente].dat,elArticulo.info[i].cadena,1,(340+j*10),color); //Soporta 80 caracteres y 30 filas
   }  
   //textout(letras,datafile[FUENTE_NORMAL].dat,elArticulo.texto[i],1,(340+j*10),0xFFFFFF); //Soprta 80 caracteres y 30 filas
  }
  elArticulo.posFila+=total;
  masked_blit(letras,videoTemporal,0,0,0,0,640,480);
  blit(videoTemporal,screen,0,0,0,0,640,480);
 }
}

/************************************************/
void ScrollAbajo(){
 int i,j=0,total=0, color=color_blanco,indiceFuente=FUENTE_XM;
 if (elArticulo.posFila>29){
  total = elArticulo.posFila-29;
  if (total>=5) total=5;
  clear_to_color(auxBitmap,bitmap_mask_color(auxBitmap));
  blit(fondo,videoTemporal,0,0,0,0,640,480);
  blit(letras,auxBitmap,0,90,0,140,640,250);
  for (i=(elArticulo.posFila-(total+29));i<(elArticulo.posFila-29);i++,j++)
   if (elArticulo.info[i].cadena!=NULL){
    switch (elArticulo.info[i].item.color){
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
     default: color = makecol(255,255,255);
    }

    switch (elArticulo.info[i].item.letra){
     case letra_grande: indiceFuente = FUENTE_GRANDE; break;
     case letra_normal: indiceFuente = FUENTE_NORMAL; break;
     case letra_pc: indiceFuente = FUENTE_PC; break;
     case letra_pct: indiceFuente = FUENTE_PCT; break;
     case letra_xm: indiceFuente = FUENTE_XM; break;
     case letra_xmb: indiceFuente = FUENTE_XMB; break;
     case letra_xmi: indiceFuente = FUENTE_XMI; break;
     default: indiceFuente = FUENTE_XM;
    }
    textout(auxBitmap, datafile[indiceFuente].dat,elArticulo.info[i].cadena,1,(90+j*10),color); //Soporta 80 caracteres y 30 filas
   }  
  
//   textout(auxBitmap,datafile[FUENTE_NORMAL].dat,elArticulo.texto[i],1,(90+j*10),0xFFFFFF); //Soprta 80 caracteres y 30 filas
  elArticulo.posFila-=total;
  masked_blit(auxBitmap,videoTemporal,0,0,0,0,640,480);
  blit(videoTemporal,screen,0,0,0,0,640,480);
  blit(auxBitmap,letras,0,0,0,0,640,480);
 }
}

/************************************************/
void LeerArchivoDatos(char *nombre){
 datafile = load_datafile("datos.dat");
 if (!datafile) {
   allegro_exit();
   printf("Error leyendo el archivo de datos\n");
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
  if (strcmp("VERDEFOSFORITO",cadenas[i])==0) itemDatos->color = color_verdefosforito;
  if (strcmp("AZULCLARO",cadenas[i])==0) itemDatos->color = color_azulclaro;
  if (strcmp("NARANJA",cadenas[i])==0) itemDatos->color = color_naranja;

  if (strcmp(cadenas[i],"GRANDE")==0) itemDatos->letra = letra_grande;
  if (strcmp(cadenas[i],"NORMAL")==0) itemDatos->letra = letra_normal;
  if (strcmp(cadenas[i],"PC")==0) itemDatos->letra = letra_pc;
  if (strcmp(cadenas[i],"PCT")==0) itemDatos->letra = letra_pct;
  if (strcmp(cadenas[i],"XM")==0) itemDatos->letra = letra_xm;
  if (strcmp(cadenas[i],"XMB")==0) itemDatos->letra = letra_xmb;
  if (strcmp(cadenas[i],"XMI")==0) itemDatos->letra = letra_xmi;

  if (strcmp(cadenas[i],"DERECHA")==0) itemDatos->justificacion = derecha;
  if (strcmp(cadenas[i],"IZQUIERDA")==0) itemDatos->justificacion = izquierda;  
  if (strcmp(cadenas[i],"CENTRO")==0) itemDatos->justificacion = centro;  
 }
}
/************************************************/
void MostrarArticulo(int indice){
 int indiceFuente=FUENTE_XM;
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
 while (cont<(datafile[indice].size)){
  car = ((char *)datafile[indice].dat)[cont];
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
 }




 datosItem.color = color_blanco;
 datosItem.letra = letra_pc;
 datosItem.justificacion = centro;
 salir=0;
 elArticulo.numFilas=0;
 i=0;
 j=0;
 cont=0;
 while (cont<(datafile[indice].size)){
  car = ((char *)datafile[indice].dat)[cont];
  if (car!=13){
   if (car=='[') {
    cont++;
    if (cont<(datafile[indice].size)){
     car = ((char *)datafile[indice].dat)[cont];
     if (car=='['){
      cadAux[i] = car;
      i++;
     }
     else{
      contItem = 0;
      while ((car!=']')&&(car!=10)){
       cadItem[contItem]=car;
       cont++;
       contItem++;
       car = ((char *)datafile[indice].dat)[cont];
      }
      cadItem[contItem]='\0';
      BuscarItem(cadItem,&datosItem);
     }
    }
   }
   else{
    cadAux[i] = car;
    i++;
   }
  }
  if (car==10){
   cadAux[i]='\0';
   elArticulo.info[j].cadena = (char *)malloc(sizeof(char)*(strlen(cadAux)+1));
   strcpy(elArticulo.info[j].cadena,cadAux);
   elArticulo.info[j].item = datosItem;
   j++;
   elArticulo.numFilas++;
   i=0;     
  }
  cont++;
 }
 

 
 for (j=0;j<30;j++)
 // if (elArticulo.texto[j]!=NULL) textout(letras, datafile[FUENTE_XM].dat,elArticulo.texto[j],1,(90+j*10),0xFFFFFF); //Soprta 80 caracteres y 30 filas 
  if (elArticulo.info[j].cadena!=NULL){
   switch (elArticulo.info[j].item.color){
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
    default: color = makecol(255,255,255);
   }

   switch (elArticulo.info[j].item.letra){
    case letra_grande: indiceFuente = FUENTE_GRANDE; break;
    case letra_normal: indiceFuente = FUENTE_NORMAL; break;
    case letra_pc: indiceFuente = FUENTE_PC; break;
    case letra_pct: indiceFuente = FUENTE_PCT; break;
    case letra_xm: indiceFuente = FUENTE_XM; break;
    case letra_xmb: indiceFuente = FUENTE_XMB; break;
    case letra_xmi: indiceFuente = FUENTE_XMI; break;
    default: indiceFuente = FUENTE_XM;
   }
   
   textout(letras, datafile[indiceFuente].dat,elArticulo.info[j].cadena,1,(90+j*10),color); //Soporta 80 caracteres y 30 filas
  }
 elArticulo.posFila = 29;
 

 blit(fondo,videoTemporal,0,0,0,0,640,480);
 masked_blit(letras,videoTemporal,0,0,0,0,640,480);
 blit(videoTemporal,screen,0,0,0,0,640,480);

 scancode=10;
 while (scancode!=KEY_ESC){
  if (keypressed()) scancode = readkey()>>8;
  if (scancode==KEY_UP) {
    ScrollAbajo();
    scancode=10;
  }
  if (scancode==KEY_DOWN) {
    ScrollArriba();
    scancode=10;
  }
  if (scancode==KEY_PGUP){
    ScrollAbajo();
    scancode=10;  
  }
    
  if (scancode==KEY_PGDN){
    ScrollArriba();
    scancode=10;
  }
 }
}

/************************************************/
void InicializarArticulo(){
 int i;
 for (i=0;i<1000;i++){
  elArticulo.texto[i]=NULL;
  elArticulo.info[i].cadena=NULL;
  elArticulo.info[i].item.color=color_blanco;
  elArticulo.info[i].item.letra=letra_pc;
  elArticulo.info[i].item.justificacion=centro;
 }
}

/************************************************/
void EliminarArticulo(){
 int i;
 for (i=0;i<1000;i++){
  free(elArticulo.texto[i]);
  free(elArticulo.info[i].cadena);
 }  
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
