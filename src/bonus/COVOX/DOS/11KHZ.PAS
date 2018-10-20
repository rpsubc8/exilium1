PROGRAM COVOX;
USES Crt,DOS;
CONST
 volumen = 50;        (*Amplifica la se¤al para evitar ruidos*)
 MAX_CONT = 1000000;  (*1 MB para leer archivo de sonido *)
 chequeo = 90;        (*para que muestree a 44 Khz *)
 PUERTO = $378;       (*Direccion del LPT1*)

VAR
 cabTeclado: word ABSOLUTE $0040:$001A;
 colaTeclado: word ABSOLUTE $0040:$001C;
 cabAux,colaAux: word;
 fichero: FILE;
 valor: byte;
 tamanio,aux,leidos: longint;
 buffer: ARRAY[0..MAX_CONT] OF byte;  (*El buffer con el archivo de sonido*)
 OldInt1C: FarPointer;
 error: BOOLEAN;

{----------------------------------------------------}
PROCEDURE TSS_Int1C; Interrupt; ASSEMBLER;
{Metodo optimzado}
ASM
 MOV EBX,aux;
 MOV ESI,offset buffer
 MOV AL,[ESI+EBX]
 CMP AL,205
 JAE @CONTINUAR
 ADD AL,50
 @CONTINUAR: MOV DX,$378
             OUT DX,AL
             ADD EBX,1
             MOV EAX,leidos
             CMP EBX,EAX
             JB @ACABAR
             XOR EBX,EBX
 @ACABAR: MOV aux,EBX
END;

(* ESTE ES EL METODO STANDARD
BEGIN
 valor:= buffer[aux];  {leo byte del buffer de sonido}
 IF (valor<(255-volumen)) THEN valor:= valor+volumen; {Incremento volumen}
 ASM
  MOV DX,puerto
  MOV AL,[valor]
  OUT DX,AL         {Mando el sonido al COVOX SOUND}
 END;
 aux:= aux+1;
 IF (aux=leidos) THEN aux:= 0;
END;*)
{----------------------------------------------------}
PROCEDURE SetTSSInt1C;
BEGIN
  GetIntVec($1C,OldInt1C);
  SetIntVec($1C,@TSS_Int1C);
END;
{----------------------------------------------------}
PROCEDURE RestauraOldInt1C;
BEGIN
  SetIntVec($1C,OldInt1C);
END;
{----------------------------------------------------}
PROCEDURE Set44Khz;
BEGIN
 PORT[$40]:= $1B;
 PORT[$40]:= $0;
END;
{----------------------------------------------------}
PROCEDURE Set22Khz;
BEGIN
 PORT[$40]:= $36;
 PORT[$40]:= $0;
END;
{----------------------------------------------------}
PROCEDURE Set11Khz;
BEGIN
 PORT[$40]:= $6C;
 PORT[$40]:= $0;
END;
{----------------------------------------------------}
PROCEDURE Set8Khz;
BEGIN
 PORT[$40]:= $95;
 PORT[$40]:= $0;
END;
{----------------------------------------------------}
PROCEDURE RestauraTemporizador;
BEGIN
 PORT[$40]:= $0;
 PORT[$40]:= $0;
END;
{----------------------------------------------------}

BEGIN
 IF (PARAMCOUNT>0) THEN
  BEGIN
   ASSIGN (fichero,PARAMSTR(1));
   {$I-}
   RESET (fichero,1);
   {$I+}
   IF (IOResult=0) THEN
    BEGIN
     tamanio:= FILESIZE(fichero);  (*calculo el tamanio del fichero de sonido*)
     IF (tamanio>MAX_CONT) THEN tamanio:= MAX_CONT;
     BLOCKREAD (fichero,buffer,tamanio,leidos); (*leo el fichero de sonido*)
     CLOSE (fichero);
     error:= FALSE;
    END
   ELSE
    error:= TRUE;
   WRITELN ('Bytes leidos: ',leidos);
   aux:= 0;
   Writeln('Pulsa cualquier tecla para salir');

   colaAux:= colaTeclado;

   IF (error=FALSE) THEN
    BEGIN
     SetTSSInt1C;
     IF (PARAMSTR(2)='p8') THEN  Set8Khz;     
     IF (PARAMSTR(2)='p11') THEN  Set11Khz;
     IF (PARAMSTR(2)='p22') THEN  Set22Khz;
     IF (PARAMSTR(2)='p44') THEN  Set44Khz;

     ASM  XOR AX,AX; int 16h  END;
     PORT[PUERTO]:=0;  {Limpio el sonido para acabar el programa}

     RestauraTemporizador;
     RestauraOldInt1C;
    END
   ELSE
    WRITELN('Se ha producido un error en la apertura del fichero');
  END
 ELSE
  BEGIN
   WRITELN('Instrucciones:');
   WRITELN('     covox  fichero.snd lkhz pkhz');
   WRITELN('Opciones:');
   WRITELN('  l --> leer a x khz');
   WRITELN('  p --> reproducir a x khz');
   WRITELN('Ejemplo: covox prueba.snd l44 p44');
  END;
END.
