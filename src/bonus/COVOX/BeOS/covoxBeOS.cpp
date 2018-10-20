/***************************************************************************/
/* Programa realizado por Jaime Jose Gavin Sierra.  Alias: J.J.   5-7-2000 */
/* Programa que reproduce archivos de sonido en formato crudo SND o RAW de */
/* 8 bits y 44 Khz. No se distribuye ni bajo licencia GNU,GPL,SHAREWARE,   */
/* FREEWARE ni COPYRIGHT.Tan solo es de caracter de aprendizaje, y se ha   */
/* realizado para aprender y no para sacar dinero por parte de terceros    */
/* Este programa es identico al realizado bajo DOS con TMTPASCAL, salvo que*/
/* esta realizado en C y funciona bajo BeOS. Para compilarlo, hay que ir al*/
/* terminal y teclear:  gcc covox.cpp -ocovox. Y para ejecutarlo:          */
/* ./covox sonid.snd.                                                      */
/* El resto es exacto que la version para DOS. El unico problema que he en-*/
/* contrado es que desconozco como usar temporizadores con la precision de */
/* los del TMTPASCAL bajo BeOS, o directamente usando el 8253 o el 8254 del*/
/* PC.Por tanto, no me ha quedado otro remedio que poner un retardo,que por*/
/* supuesto variara de un equipo a otro. Por tanto, habra que cambiar esa  */
/* funcion segun el equipo sea rapido o lento. Lo siento,pero no se me ocu-*/
/* rrio otra forma, ya que bajo SDL los temporizadores son de milisegundos */
/* y las API's de BeOS son tambi‚n de milisegundos, y yo necesito microse- */
/* gundos.Por tanto, el que sepa como poner un temporizador o sem foro de  */
/* de esa precisi¢n, ya sabe, que lo mande lo antes posible a la direccion */
/* i1766818@petra.euitio.uniovi.es   o a  beprogramadores.org              */
/* Por cierto, para usar el puerto paralelo,he recurrido a un driver exter-*/
/* no creado por Pieter Panman y que se usa como los dispositivos de LINUX */
/* Para instalarlo, solo hay que seguir las instrucciones adjuntas del     */
/* driver de puerto paralelo, que he traducido.Es una pena, que BeOS no in-*/
/* corpore por defecto el puerto paralelo, como le sucede al serie.        */
/* Buena suerte, y ha programar cosas para BeOS, que es un buen S.O.       */
/* Por cierto, en BeOS suena peor que en DOS,pero es por culpa de que no he*/
/* dado con el temporizador y porque en sistemas concurrentes no va tan    */
/* fluido como en monotarea. En Windows pasa lo mismo                      */
/***************************************************************************/

#include <stdio.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <OS.h>
#include <support/SupportDefs.h>
#define max_cont 10000000
#define volumen 50

void Retardo(){ /*Funcion que actua como de reloj para retardar*/
  int i;
  for (i=0;i<2000;i++); /*Un simple bucle de retardo*/
}

int main(int argc, char **argv){
 if (argc>1){
  unsigned long int aux;
  unsigned long int leidos;
  int fd;
  unsigned char buffer[max_cont];
  unsigned char valor;
  FILE *fichero;
  fichero = fopen(argv[1],"rb"); /*Apertura del fichero de sonido*/
    leidos = fread(buffer,1,max_cont,fichero);   
  fclose(fichero);
 
  printf("Bytes leidos: %d\n",leidos);
  fd = open("/dev/misc/parallelport", O_RDWR);  /*Abro el canal del COVOX SOUND*/
    aux = 0;
    while (aux<leidos){
      valor = buffer[aux]; /*Leo el byte del buffer de sonido*/
      if (valor<(255-volumen)) valor+=volumen; /*Subo el audio*/
      write (fd,&valor,1); /*Escribo en el COVOX SOUND*/
      Retardo();           /*Hago la espera*/
      aux +=1;
    }
  write (fd,0,1);    /*Limpio el COVOX SOUND al salir*/
  close(fd);
 }
 else
   printf("Instrucciones\n     ./covox  sonido.snd\n");
}
