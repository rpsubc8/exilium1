(********************************************************)
(* Autor: Jaime Jose Gavin Sierra           Alias: J.J. *)
(********************************************************)
PROGRAM Dibuja;

PROCEDURE RellenaPantalla(color: byte);
 VAR
  i: word;
 BEGIN
  FOR i:=0 TO 63999 DO
   MEM[$A000:i]:= color;
 END;

PROCEDURE RellenaPantallaRapido(color: byte);
 BEGIN
  ASM
   MOV AX,$A000
   MOV ES,AX
   XOR DI,DI
   MOV AL,[color]
   MOV CX,64000
   REP STOSB
  END;
 END;

PROCEDURE Modo13;
 BEGIN
  ASM
   MOV AX,13h
   INT 10h
  END;
 END;

PROCEDURE Modo3;
 BEGIN
  ASM MOV AX,3h; INT 10h; END;
 END;

PROCEDURE PonerPunto(x, y: word; color: byte);
 VAR
  desplazamiento: word;
 BEGIN
  desplazamiento:= (y*320)+x;
  MEM[$A000:desplazamiento]:= 15;
 END;

BEGIN
 Modo13;
 PonerPunto(160,100,15); (* Dibuja un punto blanco en x = 160 y = 100 *)
 ASM XOR AX,AX; INT 16h; END; (* Espera a pulsar tecla *)
 RellenaPantalla(15);    (* Rellena la pantalla de blanco *)
 ASM XOR AX,AX; INT 16h; END; (* Espera a pulsar tecla *)
 Modo3;                  (* Vuelve al modo texto 3 = 80 x 25 *)
END.
