(*************************************************************************)
(* COVOX SOUND 8 bits                                           5-7-2000 *)
(* Programa realizado por Jaime Jose Gavin Sierra.   Alias: J.J.         *)
(* Portado a D.O.S. y BeOS de caracter para aprendizaje                  *)
(* No se distribuye ni bajo licencia GNU,GPL,SHAREWARE,FREEWARE,COPYRIGHT*)
(* Se distribuye de tal forma que nadie puede sacar dinero, ya que       *)
(* solo es de caracter para aprendizaje y desarrollo multiplataforma     *)
(* Quien quiera mejorar lo presente, puede contribuir mandando la me-    *)
(* jora a i1766818@petra.euitio.uniovi.es o bien a beprogramadores.org   *)
(* Lo unico que hace este programa es reproducir los archivos en for-    *)
(* mato crudo SND o RAW de 8 bits y 44 Khz a traves de una COVOX SOUND   *)
(* Para saber lo que es una COVOX SOUND, pueden remitirse al COVOX.TXT   *)
(* Este programa esta hecho bajo TMTPASCAL en su versi¢n libre, pero no  *)
(* para uso comercial.                                                   *)
(* Para compilarlo bajo DOS, teclear:   TMTPC covox.pas                  *)
(* He usado los temporizadores de la libreria Zentimer para controlar    *)
(* la frecuencia de muestreo. Puesto que la precisi¢n de estos es de 1e6 *)
(* es decir, de 1000000 de Hz, como hay que muestrear a 44000 Hz, nos da *)
(* un valor de (1e6 DIV 44 Khz = 22.72 Hz), pero para evitar calculo con *)
(* flotantes, devido a su lentitud, se ha aproximado a 22. Si queremos 22*)
(* 22Khz(chequeo=45), y para 11Khz ser¡a 90. Las pruebas han sido reali- *)
(* zadas en un Athlon a 800 Mhz y en un Pentium 133 Mhz, y a 44 Khz se   *)
(* portan muy bien. Todab¡a no he probado en un 486,pero seguro que fun- *)
(* ciona correctamente. En el caso de un 80386, no podr¡a constatarlo.El *)
(* uso de los Zentimer, obliga a disponer un 80386 o superior, por usar  *)
(* los temporizadores del AT. El tamanio del buffer de sonido se puede   *)
(* bajar si disponemos de poca memoria RAM,cambiando el valor de la cte  *)
(* MAX_CONT.Los ficheros no se comprueba la apertura correcta,por ser una*)
(* prueba.El fichero de sonido se pasa como argumento desde linea de co- *)
(* mandos. Este programa funciona en DOS puro y duro, y bajo ventana DOS *)
(* de WINDOWS sin problemas.Se ha hecho iterativo y sin concurrencia,para*)
(* evitar problemas con WINDOWS y por ser una prueba.Para ello habr¡a que*)
(* colgar un gestor de la interrupci¢n 8h o en su defecto de la 1Ch.Se ha*)
(* amplificado el sonido 50 puntos por encima,para evitar ruidos, ya que *)
(* de por si, sale muy bajo y con un poco de distorsi¢n. Si se pulsa una *)
(* tecla se puede salir del programa de manera comoda o bien, cuando se  *)
(* haya terminado de reproducir la cancion.No se comprueba en que puerto *)
(* esta el COVOX SOUND,por ser una prueba.Para ello,se debe de cambiar la*)
(* cte PUERTO,por el correspondiente y volver a compilar                 *)
(* Espero que haya servido de ayuda, y suerte con esta prueba            *)
(* Como aniadidos,hare un compresor para que ocupen menos los archivos de*)
(* audio, asi como dejarlo concurrente y la posibilidad de hacer un COVOX*)
(* SOUND de 13 bits,con los 8 bits de datos y los 5 de control para tener*)
(* mas precision.Asi mismo, tambien hare un programa bajo DELPHI para que*)
(* funcione bajo WINDOWS,asi como en LINUX.                              *)
(* NOTAS: Para dejar un archivo en formato RAW o SND a 8 bits y 44 Khz,se*)
(*        puede usar el GOLDWAVE de Windows o alguno similar.Hay que gra-*)
(*        bar en unsigned 8bits 44 Khz.                                  *)
(*************************************************************************)
PROGRAM COVOX;
USES Zentimer,Crt;
CONST
 volumen = 50;        (*Amplifica la se¤al para evitar ruidos*)
 MAX_CONT = 2000000;  (*2 MB para leer archivo de sonido *)
 chequeo = 22;        (*para que muestree a 44 Khz *)
 PUERTO = $378;       (*Direccion del LPT1*)
VAR
 timer: LZtimer;      (*El temporizador para muestreo*)
 fichero: FILE;
 valor: byte;
 tamanio,aux,leidos: longint;
 buffer: ARRAY[0..MAX_CONT] OF byte;  (*El buffer con el archivo de sonido*)

BEGIN
 IF (PARAMCOUNT>0) THEN
  BEGIN
   ASSIGN (fichero,PARAMSTR(1));
   RESET (fichero,1);
    tamanio:= FILESIZE(fichero);  (*calculo el tamanio del fichero de sonido*)
    IF (tamanio>MAX_CONT) THEN tamanio:= MAX_CONT;
    BLOCKREAD (fichero,buffer,tamanio,leidos); (*leo el fichero de sonido*)
   CLOSE (fichero);
   WRITELN ('Bytes leidos: ',leidos);
   aux:= 0;
   Writeln('Pulsa cualquier tecla para salir');
   timer.start;
   WHILE ((aux<leidos) AND NOT(keypressed)) DO
    BEGIN
     valor:= buffer[aux];  (*leo byte del buffer de sonido*)
     IF (valor<(255-volumen)) THEN valor:= valor+volumen; (*Incremento volumen*)
     while (timer.lap<chequeo) DO; (*Compruebo para los 44 Khz*)
     timer.Restart;   (*Reseteo el temporizador para contar de nuevo *)
     PORT[PUERTO]:= valor;  (*Mando el sonido al COVOX SOUND*)
     aux:= aux+1;  (*incremento para buscar mas bytes en el buffer*)
    END;
   PORT[PUERTO]:=0;  (*Limpio el sonido para acabar el programa*)
  END
 ELSE
  BEGIN
   WRITELN('Instrucciones:');
   WRITELN('     covox  fichero.snd');
  END;
END.
