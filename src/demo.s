	.file	"demo.c"
gcc2_compiled.:
___gnu_compiled_c:
.globl __gfx_driver_list
.data
	.p2align 2
__gfx_driver_list:
	.long 1447183667
	.long _gfx_vesa_3
	.long -1
	.long 1447178828
	.long _gfx_vesa_2l
	.long -1
	.long 1447178818
	.long _gfx_vesa_2b
	.long -1
	.long 0
	.long 0
	.long 0
.globl __vtable_list
	.p2align 2
__vtable_list:
	.long 8
	.long ___linear_vtable8
	.long 16
	.long ___linear_vtable16
	.long 0
	.long 0
.globl _sonido
	.p2align 2
_sonido:
	.long 1
.globl _fondo
	.p2align 2
_fondo:
	.long 0
.globl _letras
	.p2align 2
_letras:
	.long 0
.globl _videoTemporal
	.p2align 2
_videoTemporal:
	.long 0
.globl _auxBitmap
	.p2align 2
_auxBitmap:
	.long 0
.text
LC6:
	.ascii "datos.dat\0"
LC7:
	.ascii "sliders1.dat\0"
LC8:
	.ascii "config1.dat\0"
LC9:
	.ascii "8\0"
LC10:
	.ascii "16\0"
LC11:
	.ascii "%d \0"
	.p2align 5
LC12:
	.ascii "\12Numero de fotos totales: %d\12Argumentos: %d\12\0"
	.p2align 5
LC13:
	.ascii "Numero filas: %d \12Fila actual: %d\0"
	.p2align 2
.globl _main
_main:
	pushl %ebp
	movl %esp,%ebp
	subl $12,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 12(%ebp),%ebx
	call _allegro_init
	call _install_keyboard
	call _install_mouse
	call _install_timer
	addl $-8,%esp
	pushl $_datafile
	pushl $LC6
	call _LeerArchivoDatos
	addl $-8,%esp
	pushl $_revista
	pushl $LC7
	call _LeerArchivoDatos
	addl $32,%esp
	addl $-8,%esp
	pushl $_configuracion
	pushl $LC8
	call _LeerArchivoDatos
	addl $-12,%esp
	pushl $0
	call _set_color_conversion
	addl $32,%esp
	cmpl $1,8(%ebp)
	jle L119
	movl 4(%ebx),%edi
	movl $LC9,%esi
	movl $2,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L120
	addl $-12,%esp
	pushl $8
	call _set_color_depth
	movl $-1,_grises
	addl $16,%esp
L120:
	movl 4(%ebx),%edi
	movl $LC10,%esi
	movl $3,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L122
	addl $-12,%esp
	pushl $16
	call _set_color_depth
	movl $0,_grises
	jmp L136
	.p2align 4,,7
L119:
	addl $-12,%esp
	pushl $16
	call _set_color_depth
L136:
	addl $16,%esp
L122:
	addl $-8,%esp
	pushl $480
	pushl $640
	call _create_bitmap
	movl %eax,_letras
	addl $-8,%esp
	pushl $480
	pushl $640
	call _create_bitmap
	movl %eax,_auxBitmap
	addl $32,%esp
	addl $-8,%esp
	pushl $480
	pushl $640
	call _create_bitmap
	movl _letras,%ecx
	movl %eax,_videoTemporal
	addl $16,%esp
	movl 28(%ecx),%edx
	addl $-8,%esp
	movl 8(%edx),%eax
	pushl %eax
	pushl %ecx
	movl 120(%edx),%eax
	call *%eax
	addl $16,%esp
	addl $-12,%esp
	pushl $0
	pushl $0
	pushl $480
	pushl $640
	pushl $0
	call _set_gfx_mode
	addl $32,%esp
	cmpl $0,_grises
	je L125
	movl $0,_i
	movl $_paletaGris,%ebx
	movl $_paletaGris+1,%edi
	movl $_paletaGris+2,%esi
	.p2align 4,,7
L129:
	movl _i,%ecx
	leal 0(,%ecx,4),%edx
	movl %ecx,%eax
	sarl $2,%eax
	movb %al,(%esi,%edx)
	movb %al,(%edi,%edx)
	movb %al,(%edx,%ebx)
	leal 1(%ecx),%eax
	movl %eax,_i
	movl %eax,%ecx
	cmpl $254,%ecx
	jle L129
	addl $-12,%esp
	pushl $_paletaGris
	call _set_pallete
	addl $16,%esp
L125:
	call _GeneraColores
	movl _screen,%eax
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	movl _configuracion,%eax
	addl $-12,%esp
	movl 32(%eax),%eax
	movl %eax,_fondo
	pushl $_losArticulos
	call _InicializarLosArticulos
	addl $32,%esp
	addl $-12,%esp
	pushl $_losArticulos
	call _LeerArticulos
	call _InicializarArticulo
	movl _losArticulos+4,%eax
	addl $-12,%esp
	pushl %eax
	call _MostrarArticulo
	addl $32,%esp
	call _ControlaEventos
	addl $-12,%esp
	pushl $0
	pushl $0
	pushl $25
	pushl $80
	pushl $-1
	call _set_gfx_mode
	movl $0,_i
	addl $32,%esp
	.p2align 4,,7
L134:
	movl _i,%eax
	sall $3,%eax
	subl _i,%eax
	addl $-8,%esp
	movl _elArticulo+12(,%eax,4),%eax
	pushl %eax
	pushl $LC11
	call _printf
	movl _i,%eax
	addl $16,%esp
	leal 1(%eax),%edx
	movl %edx,_i
	movl %edx,%eax
	cmpl $9,%eax
	jle L134
	movl 8(%ebp),%eax
	addl $-4,%esp
	pushl %eax
	xorl %eax,%eax
	movb _elArticulo,%al
	pushl %eax
	pushl $LC12
	call _printf
	call _EliminarArticulo
	addl $-12,%esp
	pushl $_losArticulos
	call _EliminarLosArticulos
	movl _configuracion,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _unload_datafile
	movl _revista,%eax
	addl $-12,%esp
	pushl %eax
	call _unload_datafile
	movl _datafile,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _unload_datafile
	movl _auxBitmap,%eax
	addl $-12,%esp
	pushl %eax
	call _destroy_bitmap
	movl _letras,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _destroy_bitmap
	movl _videoTemporal,%eax
	addl $-12,%esp
	pushl %eax
	call _destroy_bitmap
	addl $32,%esp
	addl $-12,%esp
	pushl $0
	call _show_mouse
	call _remove_mouse
	call _remove_keyboard
	call _allegro_exit
	movl _elArticulo+8,%eax
	addl $-4,%esp
	pushl %eax
	movl _elArticulo+4,%eax
	pushl %eax
	pushl $LC13
	call _printf
	leal -24(%ebp),%esp
	xorl %eax,%eax
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _ScrollArriba
_ScrollArriba:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl $0,-8(%ebp)
	movl _elArticulo+4,%eax
	cmpl %eax,_elArticulo+8
	jg L138
	cmpl $0,_grises
	jne L139
	movl _configuracion,%eax
	addl $-12,%esp
	movl 112(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L139:
	pushl $320
	pushl $640
	pushl $80
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _fondo,%eax
	pushl %eax
	call _blit
	movl _videoTemporal,%eax
	addl $32,%esp
	addl $-8,%esp
	movl 28(%eax),%edx
	pushl $0
	pushl $400
	pushl $460
	pushl $400
	pushl $0
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	addl $32,%esp
	pushl $260
	pushl $640
	pushl $90
	pushl $0
	pushl $140
	pushl $0
	movl _letras,%eax
	pushl %eax
	pushl %eax
	call _blit
	movl _letras,%ecx
	addl $32,%esp
	movl 28(%ecx),%edx
	addl $-8,%esp
	movl 8(%edx),%eax
	pushl %eax
	pushl $400
	pushl $639
	pushl $350
	pushl $0
	pushl %ecx
	movl 40(%edx),%eax
	call *%eax
	movl _elArticulo+8,%eax
	addl $32,%esp
	leal -3(%eax),%edx
	movl %edx,-4(%ebp)
	addl $6,%eax
	cmpl %eax,%edx
	jge L144
	movl $300,-12(%ebp)
	movl %edx,%eax
	sall $3,%eax
	subl %edx,%eax
	leal 0(,%eax,4),%esi
	leal _elArticulo+36(%esi),%ebx
	.p2align 4,,7
L146:
	movl (%ebx),%edx
	testl %edx,%edx
	je L145
	movl -16(%ebx),%eax
	cmpl $1,%eax
	je L151
	jb L152
	cmpl $2,%eax
	je L150
	cmpl $3,%eax
	jne L148
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 300(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	pushl $4
	pushl %edx
	movl _datafile,%edx
	movl -20(%ebx),%eax
	jmp L160
	.p2align 4,,7
L150:
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 300(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	pushl $319
	pushl %edx
	movl _datafile,%edx
	movl -20(%ebx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _textout_centre
	jmp L161
	.p2align 4,,7
L151:
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 300(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	pushl $4
	pushl %edx
	movl _datafile,%edx
	movl -20(%ebx),%eax
	jmp L160
	.p2align 4,,7
L152:
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 300(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	movl _elArticulo+16(%esi),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edx
	call _JustificacionDerecha
	addl $16,%esp
	movl %eax,%edx
	movl $635,%eax
	subl %edx,%eax
	pushl %eax
	movl (%ebx),%eax
	pushl %eax
	movl _datafile,%edx
	movl _elArticulo+16(%esi),%eax
L160:
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _textout
L161:
	addl $32,%esp
L148:
	movl $_elArticulo+32,%edi
	movl (%esi,%edi),%eax
	testl %eax,%eax
	je L145
	cmpl $0,_grises
	jne L156
	movl _elArticulo+86892(,%eax,4),%eax
	addl $-12,%esp
	pushl %eax
	call _select_pallete
	addl $16,%esp
L156:
	pushl $10
	movl (%esi,%edi),%eax
	sall $2,%eax
	movl _elArticulo+86812(%eax),%edx
	movl (%edx),%eax
	pushl %eax
	movl -12(%ebp),%eax
	pushl %eax
	xorl %eax,%eax
	movb _elArticulo+24(%esi),%al
	sall $3,%eax
	addl $4,%eax
	pushl %eax
	movl _elArticulo+28(%esi),%eax
	pushl %eax
	pushl $0
	movl _letras,%eax
	pushl %eax
	pushl %edx
	call _blit
	addl $32,%esp
L145:
	incl -4(%ebp)
	addl $10,-12(%ebp)
	incl -8(%ebp)
	movl _elArticulo+8,%eax
	addl $28,%esi
	addl $28,%ebx
	addl $6,%eax
	cmpl %eax,-4(%ebp)
	jl L146
L144:
	addl $5,_elArticulo+8
	pushl $480
	pushl $640
	pushl $0
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _masked_blit
	movl _letras,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _MostrarInfoArticulo
	movl _mouse_x,%eax
	addl $16,%esp
	testl %eax,%eax
	jl L158
	movl _mouse_x,%eax
	cmpl $639,%eax
	jg L158
	movl _mouse_y,%eax
	cmpl $49,%eax
	jle L158
	movl _mouse_y,%eax
	cmpl $399,%eax
	jg L158
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	jmp L138
	.p2align 4,,7
L158:
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
L138:
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _ScrollAbajo
_ScrollAbajo:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl $0,-8(%ebp)
	cmpl $29,_elArticulo+8
	jle L163
	movl _auxBitmap,%edx
	movl 28(%edx),%ecx
	addl $-8,%esp
	movl 8(%ecx),%eax
	pushl %eax
	pushl %edx
	movl 120(%ecx),%eax
	call *%eax
	addl $16,%esp
	cmpl $0,_grises
	jne L166
	movl _configuracion,%eax
	addl $-12,%esp
	movl 112(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L166:
	pushl $320
	pushl $640
	pushl $80
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _fondo,%eax
	pushl %eax
	call _blit
	movl _videoTemporal,%eax
	addl $32,%esp
	addl $-8,%esp
	movl 28(%eax),%edx
	pushl $0
	pushl $400
	pushl $460
	pushl $400
	pushl $0
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	addl $32,%esp
	pushl $250
	pushl $640
	pushl $140
	pushl $0
	pushl $90
	pushl $0
	movl _auxBitmap,%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _blit
	movl _elArticulo+8,%eax
	addl $-29,%eax
	movl %eax,-4(%ebp)
	subl $5,-4(%ebp)
	addl $32,%esp
	cmpl %eax,-4(%ebp)
	jge L169
	movl -4(%ebp),%eax
	movl $90,-12(%ebp)
	sall $3,%eax
	subl -4(%ebp),%eax
	leal 0(,%eax,4),%esi
	leal _elArticulo+36(%esi),%ebx
	.p2align 4,,7
L171:
	movl (%ebx),%edx
	testl %edx,%edx
	je L170
	movl -16(%ebx),%eax
	cmpl $1,%eax
	je L176
	jb L177
	cmpl $2,%eax
	je L175
	cmpl $3,%eax
	jne L173
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 90(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	pushl $4
	pushl %edx
	movl _datafile,%edx
	movl -20(%ebx),%eax
	jmp L185
	.p2align 4,,7
L175:
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 90(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	pushl $319
	pushl %edx
	movl _datafile,%edx
	movl -20(%ebx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _auxBitmap,%eax
	pushl %eax
	call _textout_centre
	jmp L186
	.p2align 4,,7
L176:
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 90(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	pushl $4
	pushl %edx
	movl _datafile,%edx
	movl -20(%ebx),%eax
	jmp L185
	.p2align 4,,7
L177:
	movl -24(%ebx),%eax
	addl $-8,%esp
	pushl %eax
	movl -8(%ebp),%ecx
	leal 90(,%ecx,2),%eax
	leal (%eax,%ecx,8),%eax
	pushl %eax
	movl _elArticulo+16(%esi),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edx
	call _JustificacionDerecha
	addl $16,%esp
	movl %eax,%edx
	movl $635,%eax
	subl %edx,%eax
	pushl %eax
	movl (%ebx),%eax
	pushl %eax
	movl _datafile,%edx
	movl _elArticulo+16(%esi),%eax
L185:
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _auxBitmap,%eax
	pushl %eax
	call _textout
L186:
	addl $32,%esp
L173:
	movl $_elArticulo+32,%edi
	movl (%esi,%edi),%eax
	testl %eax,%eax
	je L170
	cmpl $0,_grises
	jne L181
	movl _elArticulo+86892(,%eax,4),%eax
	addl $-12,%esp
	pushl %eax
	call _select_pallete
	addl $16,%esp
L181:
	pushl $10
	movl (%esi,%edi),%eax
	sall $2,%eax
	movl _elArticulo+86812(%eax),%edx
	movl (%edx),%eax
	pushl %eax
	movl -12(%ebp),%eax
	pushl %eax
	xorl %eax,%eax
	movb _elArticulo+24(%esi),%al
	sall $3,%eax
	addl $4,%eax
	pushl %eax
	movl _elArticulo+28(%esi),%eax
	pushl %eax
	pushl $0
	movl _auxBitmap,%eax
	pushl %eax
	pushl %edx
	call _blit
	addl $32,%esp
L170:
	incl -4(%ebp)
	addl $10,-12(%ebp)
	incl -8(%ebp)
	movl _elArticulo+8,%eax
	addl $28,%esi
	addl $28,%ebx
	addl $-29,%eax
	cmpl %eax,-4(%ebp)
	jl L171
L169:
	addl $-5,_elArticulo+8
	pushl $480
	pushl $640
	pushl $0
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _auxBitmap,%eax
	pushl %eax
	call _masked_blit
	movl _auxBitmap,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _MostrarInfoArticulo
	movl _mouse_x,%eax
	addl $16,%esp
	testl %eax,%eax
	jl L183
	movl _mouse_x,%eax
	cmpl $639,%eax
	jg L183
	movl _mouse_y,%eax
	cmpl $49,%eax
	jle L183
	movl _mouse_y,%eax
	cmpl $399,%eax
	jg L183
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	addl $16,%esp
	jmp L184
	.p2align 4,,7
L183:
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	addl $32,%esp
L184:
	pushl $320
	pushl $640
	pushl $80
	pushl $0
	pushl $80
	pushl $0
	movl _letras,%eax
	pushl %eax
	movl _auxBitmap,%eax
	pushl %eax
	call _blit
L163:
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 5
LC14:
	.ascii "Error leyendo el archivo de datos\12\0"
LC15:
	.ascii "ROJO\0"
LC16:
	.ascii "VERDE\0"
LC17:
	.ascii "AZUL\0"
LC18:
	.ascii "NEGRO\0"
LC19:
	.ascii "BLANCO\0"
LC20:
	.ascii "MARRON\0"
LC21:
	.ascii "AMARILLO\0"
LC22:
	.ascii "VIOLETA\0"
LC23:
	.ascii "VERDEFOSFORITO\0"
LC24:
	.ascii "AZULCLARO\0"
LC25:
	.ascii "NARANJA\0"
LC26:
	.ascii "GRIS\0"
LC27:
	.ascii "GRISCLARO\0"
LC28:
	.ascii "GRANDE\0"
LC29:
	.ascii "NORMAL\0"
LC30:
	.ascii "PC\0"
LC31:
	.ascii "PCT\0"
LC32:
	.ascii "XM\0"
LC33:
	.ascii "XMB\0"
LC34:
	.ascii "XMI\0"
LC35:
	.ascii "CHAR11\0"
LC36:
	.ascii "CHAR11B\0"
LC37:
	.ascii "CHAR11I\0"
LC38:
	.ascii "CHAR11BI\0"
LC39:
	.ascii "CHAR14\0"
LC40:
	.ascii "CHAR14B\0"
LC41:
	.ascii "CHAR14I\0"
LC42:
	.ascii "CHAR14BI\0"
LC43:
	.ascii "NO\0"
LC44:
	.ascii "DERECHA\0"
LC45:
	.ascii "IZQUIERDA\0"
LC46:
	.ascii "CENTRO\0"
	.p2align 2
.globl _BuscarItem
_BuscarItem:
	pushl %ebp
	movl %esp,%ebp
	subl $10092,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ecx
	movl 12(%ebp),%ebx
	movl $0,-10008(%ebp)
	movl $0,-10012(%ebp)
	movl %ecx,%eax
	movl %ecx,%edx
	andl $3,%edx
	je L235
	jp L240
	cmpl $2,%edx
	je L241
	cmpb %dh,(%eax)
	je L239
	incl %eax
L241:
	cmpb %dh,(%eax)
	je L239
	incl %eax
L240:
	cmpb %dh,(%eax)
	je L239
	incl %eax
L235:
	movl (%eax),%edx
	testb %dh,%dl
	jne L236
	testb %dl,%dl
	je L239
	testb %dh,%dh
	je L238
L236:
	testl $16711680,%edx
	je L237
	addl $4,%eax
	testl $-16777216,%edx
	jne L235
	subl $3,%eax
L237:
	incl %eax
L238:
	incl %eax
L239:
	subl %ecx,%eax
	movl $0,-10004(%ebp)
	cmpl $-1,%eax
	je L191
	leal -10000(%ebp),%esi
	movl $0,-10076(%ebp)
	xorl %edi,%edi
	.p2align 4,,7
L193:
	movl -10004(%ebp),%eax
	movb (%eax,%ecx),%dl
	testb %dl,%dl
	je L195
	cmpb $32,%dl
	jne L194
L195:
	movl -10012(%ebp),%eax
	addl %edi,%eax
	movb $0,(%eax,%esi)
	movl $0,-10012(%ebp)
	addl $100,-10076(%ebp)
	addl $100,%edi
	incl -10008(%ebp)
	jmp L192
	.p2align 4,,7
L194:
	movl -10012(%ebp),%eax
	addl -10076(%ebp),%eax
	movb %dl,(%eax,%esi)
	incl -10012(%ebp)
L192:
	incl -10004(%ebp)
	movl %ecx,%eax
	movl %ecx,%edx
	andl $3,%edx
	je L242
	jp L247
	cmpl $2,%edx
	je L248
	cmpb %dh,(%eax)
	je L246
	incl %eax
L248:
	cmpb %dh,(%eax)
	je L246
	incl %eax
L247:
	cmpb %dh,(%eax)
	je L246
	incl %eax
L242:
	movl (%eax),%edx
	testb %dh,%dl
	jne L243
	testb %dl,%dl
	je L246
	testb %dh,%dh
	je L245
L243:
	testl $16711680,%edx
	je L244
	addl $4,%eax
	testl $-16777216,%edx
	jne L242
	subl $3,%eax
L244:
	incl %eax
L245:
	incl %eax
L246:
	subl %ecx,%eax
	incl %eax
	cmpl %eax,-10004(%ebp)
	jb L193
L191:
	cmpl $0,-10008(%ebp)
	jle L199
	movl _color_rojo,%ecx
	movl %ecx,-10020(%ebp)
	movl _color_verde,%eax
	movl %eax,-10024(%ebp)
	movl _color_azul,%ecx
	movl %ecx,-10028(%ebp)
	movl _color_negro,%eax
	movl %eax,-10032(%ebp)
	movl _color_blanco,%ecx
	movl %ecx,-10036(%ebp)
	movl _color_marron,%eax
	movl %eax,-10040(%ebp)
	movl _color_amarillo,%ecx
	movl %ecx,-10044(%ebp)
	movl _color_violeta,%eax
	movl %eax,-10048(%ebp)
	movl _color_verdeFosforito,%ecx
	movl %ecx,-10052(%ebp)
	movl _color_azulClaro,%eax
	movl %eax,-10056(%ebp)
	movl _color_naranja,%ecx
	movl %ecx,-10060(%ebp)
	movl _color_gris,%eax
	movl %eax,-10064(%ebp)
	movl _color_grisClaro,%ecx
	movl -10008(%ebp),%eax
	movl %ecx,-10068(%ebp)
	movl %ebp,-10072(%ebp)
	leal -10000(%ebp),%edx
	movl %eax,-10004(%ebp)
	.p2align 4,,7
L201:
	movl $LC15,%esi
	movl %edx,%edi
	movl $5,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L202
	movl -10020(%ebp),%ecx
	movl %ecx,(%ebx)
L202:
	movl $LC16,%esi
	movl %edx,%edi
	movl $6,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L203
	movl -10024(%ebp),%eax
	movl %eax,(%ebx)
L203:
	movl $LC17,%esi
	movl %edx,%edi
	movl $5,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L204
	movl -10028(%ebp),%ecx
	movl %ecx,(%ebx)
L204:
	movl $LC18,%esi
	movl %edx,%edi
	movl $6,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L205
	movl -10032(%ebp),%eax
	movl %eax,(%ebx)
L205:
	movl $LC19,%esi
	movl %edx,%edi
	movl $7,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L206
	movl -10036(%ebp),%ecx
	movl %ecx,(%ebx)
L206:
	movl $LC20,%esi
	movl %edx,%edi
	movl $7,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L207
	movl -10040(%ebp),%eax
	movl %eax,(%ebx)
L207:
	movl $LC21,%esi
	movl %edx,%edi
	movl $9,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L208
	movl -10044(%ebp),%ecx
	movl %ecx,(%ebx)
L208:
	movl $LC22,%esi
	movl %edx,%edi
	movl $8,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L209
	movl -10048(%ebp),%eax
	movl %eax,(%ebx)
L209:
	movl $LC23,%esi
	movl %edx,%edi
	movl $15,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L210
	movl -10052(%ebp),%ecx
	movl %ecx,(%ebx)
L210:
	movl $LC24,%esi
	movl %edx,%edi
	movl $10,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L211
	movl -10056(%ebp),%eax
	movl %eax,(%ebx)
L211:
	movl $LC25,%esi
	movl %edx,%edi
	movl $8,%ecx
	cld
	xorl %eax,%eax
	repe
	cmpsb
	je L249
	sbbl %eax,%eax
	orb $1,%al
L249:
	movl -10072(%ebp),%ecx
	movl %ecx,-10016(%ebp)
	testl %eax,%eax
	jne L212
	movl -10060(%ebp),%eax
	movl %eax,(%ebx)
L212:
	movl $LC26,%esi
	movl %edx,%edi
	movl $5,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L213
	movl -10064(%ebp),%ecx
	movl %ecx,(%ebx)
L213:
	movl $LC27,%esi
	movl %edx,%edi
	movl $10,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L214
	movl -10068(%ebp),%eax
	movl %eax,(%ebx)
L214:
	movl %edx,%esi
	movl $LC28,%edi
	movl $7,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L215
	movl $8,4(%ebx)
L215:
	movl %edx,%esi
	movl $LC29,%edi
	movl $7,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L216
	movl $9,4(%ebx)
L216:
	movl %edx,%esi
	movl $LC30,%edi
	movl $3,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L217
	movl $10,4(%ebx)
L217:
	movl %edx,%esi
	movl $LC31,%edi
	movl $4,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L218
	movl $11,4(%ebx)
L218:
	movl %edx,%esi
	movl $LC32,%edi
	movl $3,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L219
	movl $12,4(%ebx)
L219:
	movl %edx,%esi
	movl $LC33,%edi
	movl $4,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L220
	movl $13,4(%ebx)
L220:
	movl %edx,%esi
	movl $LC34,%edi
	movl $4,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L221
	movl $14,4(%ebx)
L221:
	movl -10016(%ebp),%eax
	addl $-10000,%eax
	movl %eax,%esi
	movl $LC35,%edi
	movl $7,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L222
	movl $0,4(%ebx)
L222:
	movl %eax,%esi
	movl $LC36,%edi
	movl $8,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L223
	movl $1,4(%ebx)
L223:
	movl %eax,%esi
	movl $LC37,%edi
	movl $8,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L224
	movl $3,4(%ebx)
L224:
	movl %eax,%esi
	movl $LC38,%edi
	movl $9,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L225
	movl $2,4(%ebx)
L225:
	movl %eax,%esi
	movl $LC39,%edi
	movl $7,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L226
	movl $4,4(%ebx)
L226:
	movl %eax,%esi
	movl $LC40,%edi
	movl $8,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L227
	movl $5,4(%ebx)
L227:
	movl %eax,%esi
	movl $LC41,%edi
	movl $8,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L228
	movl $7,4(%ebx)
L228:
	movl %eax,%esi
	movl $LC42,%edi
	movl $9,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L229
	movl $6,4(%ebx)
L229:
	movl %eax,%esi
	movl $LC43,%edi
	movl $3,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L230
	movl $3,8(%ebx)
L230:
	movl %eax,%esi
	movl $LC44,%edi
	movl $8,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L231
	movl $0,8(%ebx)
L231:
	movl -10016(%ebp),%eax
	addl $-10000,%eax
	movl %eax,%esi
	movl $LC45,%edi
	movl $10,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L232
	movl $1,8(%ebx)
L232:
	movl %eax,%esi
	movl $LC46,%edi
	movl $7,%ecx
	cld
	testb $0,%al
	repe
	cmpsb
	jne L200
	movl $2,8(%ebx)
L200:
	addl $100,-10072(%ebp)
	addl $100,%edx
	decl -10004(%ebp)
	jnz L201
L199:
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _MostrarArticulo
_MostrarArticulo:
	pushl %ebp
	movl %esp,%ebp
	subl $1148,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl _letras,%eax
	movl 8(%ebp),%esi
	movl 28(%eax),%eax
	addl $-12,%esp
	movl 8(%eax),%eax
	pushl %eax
	call _text_mode
	movl _color_blanco,%eax
	movl %eax,-24(%ebp)
	movl $10,-20(%ebp)
	movl $2,-16(%ebp)
	movl $0,_elArticulo+4
	movl $0,-1060(%ebp)
	movl $7,-1068(%ebp)
	movb $0,-524(%ebp)
	movl _revista,%eax
	movl %esi,%edx
	sall $4,%edx
	addl $16,%esp
	movl (%eax,%edx),%eax
	leal -1036(%ebp),%ecx
	movb 7(%eax),%bl
	leal -524(%ebp),%eax
	movl %eax,-1104(%ebp)
	movl %ecx,-1080(%ebp)
	cmpb $93,%bl
	je L253
	movl %edx,-1088(%ebp)
	cmpb $10,%bl
	je L253
	movl %eax,%ecx
	.p2align 4,,7
L254:
	cmpb $13,%bl
	je L256
	movl -1060(%ebp),%edi
	movb %bl,(%edi,%ecx)
	incl %edi
	movl %edi,-1060(%ebp)
L256:
	incl -1068(%ebp)
	movl _revista,%eax
	movl -1068(%ebp),%edi
	movl (%eax,%edx),%eax
	movb (%edi,%eax),%bl
	cmpb $93,%bl
	je L253
	cmpb $10,%bl
	jne L254
L253:
	movl -1104(%ebp),%eax
	movl -1060(%ebp),%edx
	movb $0,(%edx,%eax)
	movl -1080(%ebp),%ecx
	addl $-8,%esp
	pushl %ecx
	pushl %eax
	call _strtod
	fstl -1056(%ebp)
	fnstcw -1026(%ebp)
	movw -1026(%ebp),%bx
	orw $3072,%bx
	movw %bx,-1028(%ebp)
	fldcw -1028(%ebp)
	fistpl -1032(%ebp)
	movl -1032(%ebp),%eax
	fldcw -1026(%ebp)
	movl %esi,%edx
	sall $4,%edx
	addl $16,%esp
	movb %al,_elArticulo
	movb $0,-524(%ebp)
	movl _revista,%eax
	movl -1068(%ebp),%esi
	movl (%eax,%edx),%eax
	movl %edx,-1088(%ebp)
	cmpb $10,(%esi,%eax)
	je L259
	.p2align 4,,7
L260:
	incl -1068(%ebp)
	movl -1068(%ebp),%edi
	cmpb $10,(%edi,%eax)
	jne L260
L259:
	fld1
	incl -1068(%ebp)
	movl $1,-1060(%ebp)
	fcompl -1056(%ebp)
	fnstsw %ax
	andb $69,%ah
	decb %ah
	cmpb $64,%ah
	jae L263
	movl -1104(%ebp),%edi
	.p2align 4,,7
L265:
	movl -1060(%ebp),%ecx
	movl -1060(%ebp),%ebx
	incl %ecx
	movl %ecx,-1084(%ebp)
	movl -1088(%ebp),%ecx
	xorl %edx,%edx
	sall $2,%ebx
	movl %ebx,-1100(%ebp)
	.p2align 4,,7
L268:
	movl _revista,%eax
	movl -1068(%ebp),%esi
	movl (%eax,%ecx),%eax
	movb (%esi,%eax),%bl
	cmpb $13,%bl
	je L269
	movb %bl,(%edx,%edi)
	incl %edx
L269:
	incl -1068(%ebp)
	cmpb $32,%bl
	jne L268
	movb $0,(%edx,%edi)
	movl -1080(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edi
	call _strtod
	fnstcw -1026(%ebp)
	movw -1026(%ebp),%dx
	orw $3072,%dx
	movw %dx,-1028(%ebp)
	fldcw -1028(%ebp)
	fistpl -1040(%ebp)
	fldcw -1026(%ebp)
	movl -1088(%ebp),%ecx
	movl %ecx,-1124(%ebp)
	movl -1104(%ebp),%ecx
	addl $16,%esp
	xorl %edx,%edx
	.p2align 4,,7
L273:
	movl _revista,%eax
	movl -1124(%ebp),%ebx
	movl -1068(%ebp),%esi
	movl (%eax,%ebx),%eax
	movb (%esi,%eax),%bl
	cmpb $13,%bl
	je L274
	movb %bl,(%edx,%ecx)
	incl %edx
L274:
	incl -1068(%ebp)
	cmpb $32,%bl
	jne L273
	movb $0,(%edx,%edi)
	movl -1080(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edi
	call _strtod
	fnstcw -1026(%ebp)
	movw -1026(%ebp),%dx
	orw $3072,%dx
	movw %dx,-1028(%ebp)
	fldcw -1028(%ebp)
	fistpl -1044(%ebp)
	fldcw -1026(%ebp)
	movl -1040(%ebp),%ecx
	movl -1088(%ebp),%ebx
	sall $4,%ecx
	movl %ecx,-1092(%ebp)
	movl -1104(%ebp),%ecx
	addl $16,%esp
	movl %ebx,-1124(%ebp)
	xorl %edx,%edx
	.p2align 4,,7
L278:
	movl _revista,%eax
	movl -1124(%ebp),%esi
	movl (%eax,%esi),%eax
	movl -1068(%ebp),%esi
	movb (%esi,%eax),%bl
	cmpb $13,%bl
	je L279
	movb %bl,(%edx,%ecx)
	incl %edx
L279:
	incl -1068(%ebp)
	cmpb $32,%bl
	jne L278
	movb $0,(%edx,%edi)
	movl -1080(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edi
	call _strtod
	fnstcw -1026(%ebp)
	movw -1026(%ebp),%dx
	orw $3072,%dx
	movw %dx,-1028(%ebp)
	fldcw -1028(%ebp)
	fistpl -1048(%ebp)
	fldcw -1026(%ebp)
	movl -1044(%ebp),%ecx
	movl -1088(%ebp),%ebx
	sall $4,%ecx
	movl %ecx,-1096(%ebp)
	movl -1104(%ebp),%ecx
	addl $16,%esp
	movl %ebx,-1124(%ebp)
	xorl %edx,%edx
	.p2align 4,,7
L283:
	movl _revista,%eax
	movl -1124(%ebp),%esi
	movl (%eax,%esi),%eax
	movl -1068(%ebp),%esi
	movb (%esi,%eax),%bl
	cmpb $13,%bl
	je L284
	movb %bl,(%edx,%ecx)
	incl %edx
L284:
	incl -1068(%ebp)
	cmpb $10,%bl
	jne L283
	movb $0,(%edx,%edi)
	movl -1080(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edi
	call _strtod
	fnstcw -1026(%ebp)
	movw -1026(%ebp),%dx
	orw $3072,%dx
	movw %dx,-1028(%ebp)
	fldcw -1028(%ebp)
	fistpl -1032(%ebp)
	movl -1032(%ebp),%esi
	fldcw -1026(%ebp)
	movl -1096(%ebp),%ecx
	movl _revista,%edx
	movl $_elArticulo+86892,%ebx
	movl (%edx,%ecx),%eax
	movl -1100(%ebp),%ecx
	movl %eax,(%ecx,%ebx)
	movl -1092(%ebp),%ebx
	movl (%edx,%ebx),%eax
	movl $_elArticulo+86812,%edx
	movl %eax,(%ecx,%edx)
	movl 4(%eax),%ebx
	movl $1717986919,%eax
	imull %ebx
	addl $16,%esp
	movl %edx,%ecx
	sarl $2,%ecx
	movl %ebx,%eax
	sarl $31,%eax
	subl %eax,%ecx
	leal (%ecx,%ecx,4),%eax
	addl %eax,%eax
	subl %eax,%ebx
	testl %ebx,%ebx
	jle L286
	movl $1,%ebx
L286:
	movl $0,-1064(%ebp)
	leal (%ebx,%ecx),%eax
	cmpl %eax,-1064(%ebp)
	jge L264
	leal 0(,%esi,8),%eax
	subl %esi,%eax
	leal _elArticulo+32(,%eax,4),%ecx
	xorl %esi,%esi
	.p2align 4,,7
L290:
	movb -1048(%ebp),%al
	movb %al,-8(%ecx)
	movl %esi,-4(%ecx)
	movl -1060(%ebp),%edx
	movl %edx,(%ecx)
	movl -1100(%ebp),%edx
	movl $_elArticulo+86812,%eax
	incl -1064(%ebp)
	movl (%edx,%eax),%eax
	movl 4(%eax),%edx
	movl %edx,-1128(%ebp)
	movl $1717986919,%eax
	imull %edx
	addl $28,%ecx
	addl $10,%esi
	sarl $31,-1128(%ebp)
	sarl $2,%edx
	subl -1128(%ebp),%edx
	leal (%ebx,%edx),%eax
	cmpl %eax,-1064(%ebp)
	jl L290
L264:
	movl -1084(%ebp),%edx
	movl %edx,-1060(%ebp)
	fildl -1060(%ebp)
	fcompl -1056(%ebp)
	fnstsw %ax
	andb $69,%ah
	decb %ah
	cmpb $64,%ah
	jb L265
L263:
	movb $0,-524(%ebp)
	movl $0,-1060(%ebp)
	movl _revista,%edx
	movl -1088(%ebp),%eax
	movl -1068(%ebp),%ecx
	cmpl 8(%edx,%eax),%ecx
	jge L294
	movl $_elArticulo+32,-1116(%ebp)
	movl $0,-1120(%ebp)
	.p2align 4,,7
L295:
	movl (%edx,%eax),%ecx
	movl -1068(%ebp),%esi
	movb (%esi,%ecx),%bl
	cmpb $13,%bl
	je L296
	cmpb $91,%bl
	jne L297
	incl %esi
	movl %esi,-1068(%ebp)
	cmpl 8(%edx,%eax),%esi
	jge L296
	movb (%esi,%ecx),%bl
	cmpb $91,%bl
	jne L299
	movl -1104(%ebp),%edi
	movl -1060(%ebp),%eax
	movb $91,(%eax,%edi)
	incl %eax
	movl %eax,-1060(%ebp)
	jmp L296
	.p2align 4,,7
L299:
	xorl %esi,%esi
	leal -1024(%ebp),%edx
	leal -24(%ebp),%ecx
	cmpb $93,%bl
	je L303
	cmpb $10,%bl
	je L303
	movl -1088(%ebp),%edi
	movl %edi,-1132(%ebp)
	.p2align 4,,7
L304:
	cmpb $13,%bl
	je L306
	movb %bl,-1024(%esi,%ebp)
	incl %esi
L306:
	incl -1068(%ebp)
	movl _revista,%eax
	movl -1132(%ebp),%ebx
	movl -1068(%ebp),%edi
	movl (%eax,%ebx),%eax
	movb (%edi,%eax),%bl
	cmpb $93,%bl
	je L303
	cmpb $10,%bl
	jne L304
L303:
	movb $0,(%esi,%edx)
	addl $-8,%esp
	pushl %ecx
	pushl %edx
	call _BuscarItem
	addl $16,%esp
	jmp L296
	.p2align 4,,7
L297:
	cmpb $10,%bl
	je L334
	cmpb $13,%bl
	je L296
	movl -1104(%ebp),%eax
	movl -1060(%ebp),%edx
	movb %bl,(%edx,%eax)
	incl %edx
	movl %edx,-1060(%ebp)
L296:
	cmpb $10,%bl
	jne L311
L334:
	movl -1104(%ebp),%ecx
	movl -1060(%ebp),%ebx
	movb $0,(%ebx,%ecx)
	movl -1116(%ebp),%esi
	movl $_elArticulo,%edx
	movb -8(%esi),%al
	movb %al,-12(%ebp)
	movl -4(%esi),%eax
	movl %eax,-8(%ebp)
	movl (%esi),%eax
	movl %eax,-4(%ebp)
	movl -1120(%ebp),%eax
	leal 12(%edx,%eax),%edi
	leal -24(%ebp),%esi
	cld
	movl $6,%ecx
	rep
	movsl
	movl -1104(%ebp),%eax
	movl -1072(%ebp),%ebx
L337:
	movl (%eax),%ebx
	testb %bh,%bl
	jne L338
	testb %bl,%bl
	je L341
	testb %bh,%bh
	je L340
L338:
	testl $16711680,%ebx
	je L339
	addl $4,%eax
	testl $-16777216,%ebx
	jne L337
	subl $3,%eax
L339:
	incl %eax
L340:
	incl %eax
L341:
	subl -1104(%ebp),%eax
	cmpl $79,%eax
	jbe L312
	movb $0,-445(%ebp)
L312:
	movl -16(%ebp),%eax
	addl $-4,%esp
	pushl %eax
	movl -20(%ebp),%eax
	pushl %eax
	movl -1104(%ebp),%esi
	pushl %esi
	call _HacerJustificacion
	movl -1104(%ebp),%eax
	movl -1076(%ebp),%edx
	addl $-12,%esp
L342:
	movl (%eax),%edx
	testb %dh,%dl
	jne L343
	testb %dl,%dl
	je L346
	testb %dh,%dh
	je L345
L343:
	testl $16711680,%edx
	je L344
	addl $4,%eax
	testl $-16777216,%edx
	jne L342
	subl $3,%eax
L344:
	incl %eax
L345:
	incl %eax
L346:
	subl %esi,%eax
	incl %eax
	pushl %eax
	call _malloc
	movl -1120(%ebp),%ebx
	movl $_elArticulo+36,%ecx
	movl %eax,(%ebx,%ecx)
	addl $32,%esp
	addl $-8,%esp
	pushl %esi
	pushl %eax
	call _strcpy
	addl $28,-1116(%ebp)
	addl $28,%ebx
	movl %ebx,-1120(%ebp)
	incl _elArticulo+4
	movl $0,-1060(%ebp)
	addl $16,%esp
L311:
	incl -1068(%ebp)
	movl _revista,%edx
	movl -1088(%ebp),%eax
	movl -1068(%ebp),%esi
	cmpl 8(%edx,%eax),%esi
	jl L295
L294:
	movl _letras,%edx
	movl 28(%edx),%ecx
	addl $-8,%esp
	movl 8(%ecx),%eax
	pushl %eax
	pushl $479
	pushl $639
	pushl $0
	pushl $0
	pushl %edx
	movl 40(%ecx),%eax
	call *%eax
	addl $32,%esp
	movl $0,-1064(%ebp)
	movl $90,-1108(%ebp)
	xorl %edi,%edi
	movl $_elArticulo+16,%esi
	movl $0,-1112(%ebp)
	.p2align 4,,7
L319:
	movl _elArticulo+36(%edi),%edx
	testl %edx,%edx
	je L318
	movl 4(%esi),%eax
	cmpl $1,%eax
	je L324
	jb L325
	cmpl $2,%eax
	jne L323
	movl -4(%esi),%eax
	addl $-8,%esp
	pushl %eax
	movl -1064(%ebp),%ecx
	movl -1112(%ebp),%ebx
	leal 90(%ebx,%ecx,2),%eax
	pushl %eax
	pushl $319
	pushl %edx
	movl _datafile,%edx
	movl (%esi),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _textout_centre
	jmp L336
	.p2align 4,,7
L323:
	cmpl $3,%eax
	jne L321
	.p2align 4,,7
L324:
	movl -4(%esi),%eax
	addl $-8,%esp
	pushl %eax
	movl -1064(%ebp),%ecx
	movl -1112(%ebp),%ebx
	leal 90(%ebx,%ecx,2),%eax
	pushl %eax
	pushl $4
	pushl %edx
	jmp L335
	.p2align 4,,7
L325:
	movl -4(%esi),%eax
	addl $-8,%esp
	pushl %eax
	movl -1064(%ebp),%ecx
	movl -1112(%ebp),%ebx
	leal 90(%ebx,%ecx,2),%eax
	pushl %eax
	movl (%esi),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edx
	call _JustificacionDerecha
	addl $16,%esp
	movl %eax,%edx
	movl $635,%eax
	subl %edx,%eax
	pushl %eax
	movl _elArticulo+36(%edi),%eax
	pushl %eax
L335:
	movl _datafile,%edx
	movl (%esi),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _textout
L336:
	addl $32,%esp
L321:
	movl $_elArticulo+32,%ebx
	movl (%edi,%ebx),%eax
	testl %eax,%eax
	je L318
	cmpl $0,_grises
	jne L329
	movl _elArticulo+86892(,%eax,4),%eax
	addl $-12,%esp
	pushl %eax
	call _select_pallete
	addl $16,%esp
L329:
	pushl $10
	movl (%edi,%ebx),%eax
	sall $2,%eax
	movl _elArticulo+86812(%eax),%edx
	movl (%edx),%eax
	pushl %eax
	movl -1108(%ebp),%eax
	pushl %eax
	xorl %eax,%eax
	movb _elArticulo+24(%edi),%al
	sall $3,%eax
	addl $4,%eax
	pushl %eax
	movl _elArticulo+28(%edi),%eax
	pushl %eax
	pushl $0
	movl _letras,%eax
	pushl %eax
	pushl %edx
	call _blit
	addl $32,%esp
L318:
	addl $10,-1108(%ebp)
	addl $28,%edi
	addl $28,%esi
	addl $8,-1112(%ebp)
	incl -1064(%ebp)
	cmpl $29,-1064(%ebp)
	jle L319
	movl $29,_elArticulo+8
	cmpl $0,_grises
	jne L331
	movl _configuracion,%eax
	addl $-12,%esp
	movl 112(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L331:
	pushl $321
	pushl $640
	pushl $80
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _fondo,%eax
	pushl %eax
	call _blit
	movl _videoTemporal,%eax
	addl $32,%esp
	addl $-8,%esp
	movl 28(%eax),%edx
	pushl $0
	pushl $400
	pushl $460
	pushl $400
	pushl $0
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	addl $32,%esp
	call _MostrarBotones
	movl _letras,%eax
	addl $-8,%esp
	pushl %eax
	pushl $_losArticulos
	call _MostrarArticulosPantalla
	pushl $480
	pushl $640
	pushl $0
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _masked_blit
	addl $48,%esp
	cmpl $0,_grises
	jne L333
	movl _configuracion,%eax
	addl $-12,%esp
	movl 128(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L333:
	pushl $80
	pushl $640
	pushl $0
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl 48(%eax),%eax
	pushl %eax
	call _blit
	movl _letras,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _MostrarTitulo
	movl _letras,%eax
	addl $-12,%esp
	pushl %eax
	call _MostrarInfoArticulo
	addl $32,%esp
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $480
	pushl $640
	pushl $0
	pushl $0
	pushl $0
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	leal -1160(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _LeerArticulos
_LeerArticulos:
	pushl %ebp
	movl %esp,%ebp
	subl $556,%esp
	xorl %ecx,%ecx
	leal -500(%ebp),%edx
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%esi
	movl _configuracion,%eax
	movb $0,-500(%ebp)
	movl 160(%eax),%eax
	movl $11,%ebx
	movb 11(%eax),%al
	movl %edx,-540(%ebp)
	leal -512(%ebp),%edx
	movl %edx,-524(%ebp)
	cmpb $93,%al
	je L366
	cmpb $10,%al
	je L366
	movl -540(%ebp),%edx
	.p2align 4,,7
L367:
	cmpb $13,%al
	je L369
	movb %al,(%ecx,%edx)
	incl %ecx
L369:
	movl _configuracion,%eax
	incl %ebx
	movl 160(%eax),%eax
	movb (%ebx,%eax),%al
	cmpb $93,%al
	je L366
	cmpb $10,%al
	jne L367
L366:
	movl -540(%ebp),%eax
	movb $0,(%ecx,%eax)
	movl -524(%ebp),%edx
	addl $-8,%esp
	pushl %edx
	pushl %eax
	call _strtod
	fnstcw -502(%ebp)
	movw -502(%ebp),%ax
	orw $3072,%ax
	movw %ax,-504(%ebp)
	fldcw -504(%ebp)
	fistpl -516(%ebp)
	fldcw -502(%ebp)
	movb -516(%ebp),%dl
	movb %dl,(%esi)
	movb $0,-500(%ebp)
	movl _configuracion,%eax
	movl 160(%eax),%eax
	addl $16,%esp
	cmpb $10,(%ebx,%eax)
	je L372
	.p2align 4,,7
L373:
	incl %ebx
	cmpb $10,(%ebx,%eax)
	jne L373
L372:
	incl %ebx
	movl $1,%ecx
	cmpl -516(%ebp),%ecx
	jg L376
	leal 4(%esi),%eax
	movl %eax,-536(%ebp)
	leal 604(%esi),%edx
	leal 204(%esi),%eax
	addl $404,%esi
	movl %esi,-520(%ebp)
	movl -540(%ebp),%esi
	movl %edx,-528(%ebp)
	movl %eax,-544(%ebp)
	.p2align 4,,7
L378:
	xorl %edx,%edx
	leal 1(%ecx),%eax
	movl %eax,-532(%ebp)
	leal -1(%ecx),%edi
	.p2align 4,,7
L381:
	movl _configuracion,%eax
	movl 160(%eax),%eax
	movb (%ebx,%eax),%al
	cmpb $13,%al
	je L382
	movb %al,(%edx,%esi)
	incl %edx
L382:
	incl %ebx
	cmpb $32,%al
	jne L381
	movb $0,(%edx,%esi)
	movl -524(%ebp),%edx
	addl $-8,%esp
	pushl %edx
	pushl %esi
	call _strtod
	fnstcw -502(%ebp)
	movw -502(%ebp),%dx
	orw $3072,%dx
	movw %dx,-504(%ebp)
	fldcw -504(%ebp)
	fistpl -508(%ebp)
	movl -508(%ebp),%eax
	fldcw -502(%ebp)
	addl $16,%esp
	movl -536(%ebp),%edx
	movl %eax,(%edx,%edi,4)
	movl -540(%ebp),%ecx
	movb $0,-500(%ebp)
	xorl %edx,%edx
	.p2align 4,,7
L386:
	movl _configuracion,%eax
	movl 160(%eax),%eax
	movb (%ebx,%eax),%al
	cmpb $13,%al
	je L387
	movb %al,(%edx,%ecx)
	incl %edx
L387:
	incl %ebx
	cmpb $10,%al
	jne L386
	movb $0,(%edx,%esi)
	addl $-12,%esp
	leal 1(%edx),%eax
	pushl %eax
	call _malloc
	movl -528(%ebp),%edx
	movl %eax,(%edx,%edi,4)
	addl $-8,%esp
	pushl %esi
	pushl %eax
	call _strcpy
	movl -540(%ebp),%ecx
	movb $0,-500(%ebp)
	xorl %edx,%edx
	addl $32,%esp
	.p2align 4,,7
L391:
	movl _configuracion,%eax
	movl 160(%eax),%eax
	movb (%ebx,%eax),%al
	cmpb $13,%al
	je L392
	movb %al,(%edx,%ecx)
	incl %edx
L392:
	incl %ebx
	cmpb $10,%al
	jne L391
	movb $0,(%edx,%esi)
	addl $-12,%esp
	leal 1(%edx),%eax
	pushl %eax
	call _malloc
	movl -544(%ebp),%edx
	movl %eax,(%edx,%edi,4)
	addl $-8,%esp
	pushl %esi
	pushl %eax
	call _strcpy
	movl -540(%ebp),%ecx
	movb $0,-500(%ebp)
	xorl %edx,%edx
	addl $32,%esp
	.p2align 4,,7
L396:
	movl _configuracion,%eax
	movl 160(%eax),%eax
	movb (%ebx,%eax),%al
	cmpb $13,%al
	je L397
	movb %al,(%edx,%ecx)
	incl %edx
L397:
	incl %ebx
	cmpb $10,%al
	jne L396
	movb $0,(%edx,%esi)
	addl $-12,%esp
	leal 1(%edx),%eax
	pushl %eax
	call _malloc
	movl -520(%ebp),%edx
	movl %eax,(%edx,%edi,4)
	addl $-8,%esp
	pushl %esi
	pushl %eax
	call _strcpy
	movl -532(%ebp),%ecx
	movb $0,-500(%ebp)
	addl $32,%esp
	cmpl -516(%ebp),%ecx
	jle L378
L376:
	leal -568(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _ScrollArribaArticulos
_ScrollArribaArticulos:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	movb 1(%ebx),%al
	testb %al,%al
	je L408
	decb %al
	movb %al,1(%ebx)
	movl 12(%ebp),%eax
	movl 28(%eax),%edx
	addl $-8,%esp
	movl 8(%edx),%eax
	pushl %eax
	pushl $470
	pushl $520
	pushl $400
	pushl $120
	movl 12(%ebp),%eax
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	addl $32,%esp
	addl $-4,%esp
	pushl $255
	pushl $255
	pushl $255
	call _makecol
	movl %eax,%esi
	addl $-4,%esp
	pushl $40
	pushl $240
	pushl $226
	call _makecol
	movl %eax,-4(%ebp)
	xorl %edx,%edx
	movb (%ebx),%dl
	movl %edx,-8(%ebp)
	xorl %eax,%eax
	movb 1(%ebx),%al
	movl %eax,-12(%ebp)
	addl $32,%esp
	addl $-8,%esp
	pushl %esi
	pushl $410
	movl %eax,%esi
	sall $2,%esi
	addl $604,%ebx
	pushl $319
	movl (%esi,%ebx),%eax
	pushl %eax
	movl _datafile,%eax
	movl 160(%eax),%eax
	pushl %eax
	movl 12(%ebp),%edx
	pushl %edx
	call _textout_centre
	movl $1,%edi
	addl $32,%esp
	leal 4(%ebx,%esi),%ebx
	movl $420,%esi
	.p2align 4,,7
L413:
	movl -12(%ebp),%edx
	leal (%edx,%edi),%eax
	cmpl -8(%ebp),%eax
	jge L415
	movl -4(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	pushl %esi
	pushl $319
	movl (%ebx),%eax
	pushl %eax
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	movl 12(%ebp),%edx
	pushl %edx
	call _textout_centre
	addl $32,%esp
L415:
	addl $4,%ebx
	addl $10,%esi
	incl %edi
	cmpl $5,%edi
	jle L413
	cmpl $0,_grises
	jne L418
	movl _configuracion,%eax
	addl $-12,%esp
	movl 80(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L418:
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $0
	pushl $120
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl (%eax),%eax
	pushl %eax
	call _blit
	addl $32,%esp
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $401
	pushl $120
	movl _videoTemporal,%eax
	pushl %eax
	movl 12(%ebp),%eax
	pushl %eax
	call _masked_blit
	movl _mouse_x,%eax
	addl $32,%esp
	cmpl $119,%eax
	jle L419
	movl _mouse_x,%eax
	cmpl $519,%eax
	jg L419
	movl _mouse_y,%eax
	cmpl $400,%eax
	jle L419
	movl _mouse_y,%eax
	cmpl $470,%eax
	jg L419
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $401
	pushl $120
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	jmp L408
	.p2align 4,,7
L419:
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $401
	pushl $120
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
L408:
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _ScrollAbajoArticulos
_ScrollAbajoArticulos:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	xorl %edx,%edx
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	xorl %eax,%eax
	movb 1(%ebx),%dl
	movb (%ebx),%al
	decl %eax
	cmpl %eax,%edx
	jge L422
	incb 1(%ebx)
	movl 12(%ebp),%eax
	movl 28(%eax),%edx
	addl $-8,%esp
	movl 8(%edx),%eax
	pushl %eax
	pushl $470
	pushl $520
	pushl $400
	pushl $120
	movl 12(%ebp),%eax
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	addl $32,%esp
	addl $-4,%esp
	pushl $255
	pushl $255
	pushl $255
	call _makecol
	movl %eax,%esi
	addl $-4,%esp
	pushl $40
	pushl $240
	pushl $226
	call _makecol
	movl %eax,-4(%ebp)
	xorl %edx,%edx
	movb (%ebx),%dl
	movl %edx,-8(%ebp)
	xorl %eax,%eax
	movb 1(%ebx),%al
	movl %eax,-12(%ebp)
	addl $32,%esp
	addl $-8,%esp
	pushl %esi
	pushl $410
	movl %eax,%esi
	sall $2,%esi
	addl $604,%ebx
	pushl $319
	movl (%esi,%ebx),%eax
	pushl %eax
	movl _datafile,%eax
	movl 160(%eax),%eax
	pushl %eax
	movl 12(%ebp),%edx
	pushl %edx
	call _textout_centre
	movl $1,%edi
	addl $32,%esp
	leal 4(%ebx,%esi),%ebx
	movl $420,%esi
	.p2align 4,,7
L427:
	movl -12(%ebp),%edx
	leal (%edx,%edi),%eax
	cmpl -8(%ebp),%eax
	jge L429
	movl -4(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	pushl %esi
	pushl $319
	movl (%ebx),%eax
	pushl %eax
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	movl 12(%ebp),%edx
	pushl %edx
	call _textout_centre
	addl $32,%esp
L429:
	addl $4,%ebx
	addl $10,%esi
	incl %edi
	cmpl $5,%edi
	jle L427
	cmpl $0,_grises
	jne L432
	movl _configuracion,%eax
	addl $-12,%esp
	movl 80(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L432:
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $0
	pushl $120
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl (%eax),%eax
	pushl %eax
	call _blit
	addl $32,%esp
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $401
	pushl $120
	movl _videoTemporal,%eax
	pushl %eax
	movl 12(%ebp),%eax
	pushl %eax
	call _masked_blit
	movl _mouse_x,%eax
	addl $32,%esp
	cmpl $119,%eax
	jle L433
	movl _mouse_x,%eax
	cmpl $519,%eax
	jg L433
	movl _mouse_y,%eax
	cmpl $400,%eax
	jle L433
	movl _mouse_y,%eax
	cmpl $470,%eax
	jg L433
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $401
	pushl $120
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	jmp L422
	.p2align 4,,7
L433:
	pushl $70
	pushl $400
	pushl $401
	pushl $120
	pushl $401
	pushl $120
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
L422:
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
LC47:
	.ascii "screen.pcx\0"
	.p2align 2
.globl _ControlaEventos
_ControlaEventos:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	leal -4(%ebp),%eax
	pushl %edi
	pushl %esi
	pushl %ebx
	movl $0,-12(%ebp)
	movl $0,-8(%ebp)
	movl $0,-4(%ebp)
	movl %eax,-20(%ebp)
	leal -8(%ebp),%eax
	movl %eax,-16(%ebp)
	.p2align 4,,7
L450:
	call _keypressed
	testl %eax,%eax
	je L451
	call _readkey
	movl %eax,%edi
	sarl $8,%edi
	cmpl $1,%edi
	jne L452
	movl $1,-12(%ebp)
L452:
	cmpl $28,%edi
	jne L453
	movl $_elArticulo,%ebx
	addl $36,%ebx
	movl $3099,%esi
	.p2align 4,,7
L456:
	movl (%ebx),%eax
	addl $-12,%esp
	pushl %eax
	call _free
	addl $16,%esp
	addl $28,%ebx
	decl %esi
	jns L456
	movl _color_blanco,%edx
	movb $0,_elArticulo
	movl $_elArticulo,%eax
	addl $32,%eax
	movl $3099,%ecx
	.p2align 4,,7
L462:
	movl $0,4(%eax)
	movl %edx,-20(%eax)
	movl $10,-16(%eax)
	movl $2,-12(%eax)
	movl $0,(%eax)
	addl $28,%eax
	decl %ecx
	jns L462
	movb $0,_elArticulo
	movl $19,%ecx
	movl $_elArticulo,%eax
	addl $86888,%eax
	.p2align 4,,7
L467:
	movl $0,(%eax)
	addl $-4,%eax
	decl %ecx
	jns L467
	xorl %eax,%eax
	movb _losArticulos+1,%al
	movl _losArticulos+4(,%eax,4),%eax
	addl $-12,%esp
	pushl %eax
	call _MostrarArticulo
	addl $16,%esp
L453:
	cmpl $72,%edi
	jne L471
	call _ScrollAbajo
L471:
	cmpl $80,%edi
	jne L472
	call _ScrollArriba
L472:
	cmpl $73,%edi
	jne L473
	call _ScrollAbajo30Lineas
L473:
	cmpl $81,%edi
	jne L474
	call _ScrollArriba30Lineas
L474:
	cmpl $75,%edi
	jne L475
	movl _letras,%eax
	addl $-8,%esp
	pushl %eax
	pushl $_losArticulos
	call _ScrollArribaArticulos
	addl $16,%esp
L475:
	cmpl $77,%edi
	jne L476
	movl _letras,%eax
	addl $-8,%esp
	pushl %eax
	pushl $_losArticulos
	call _ScrollAbajoArticulos
	addl $16,%esp
L476:
	cmpl $88,%edi
	je L478
	cmpl $68,%edi
	jne L451
L478:
	addl $-4,%esp
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	pushl $LC47
	call _save_pcx
	addl $16,%esp
L451:
	movl -20(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	movl -16(%ebp),%eax
	pushl %eax
	call _get_mouse_mickeys
	movl -4(%ebp),%eax
	addl $16,%esp
	testl %eax,%eax
	je L479
	jle L480
	call _ScrollArriba
L480:
	cmpl $0,-4(%ebp)
	jge L479
	call _ScrollAbajo
L479:
	movl -8(%ebp),%eax
	testl %eax,%eax
	je L482
	jle L483
	movl _letras,%eax
	addl $-8,%esp
	pushl %eax
	pushl $_losArticulos
	call _ScrollAbajoArticulos
	addl $16,%esp
L483:
	cmpl $0,-8(%ebp)
	jge L482
	movl _letras,%eax
	addl $-8,%esp
	pushl %eax
	pushl $_losArticulos
	call _ScrollArribaArticulos
	addl $16,%esp
L482:
	movl _mouse_b,%eax
	testl $1,%eax
	je L448
	movl _mouse_y,%eax
	cmpl $400,%eax
	jle L486
	movl _mouse_y,%eax
	cmpl $479,%eax
	jg L486
	movl _mouse_x,%eax
	testl %eax,%eax
	jl L486
	movl _mouse_x,%eax
	cmpl $79,%eax
	jg L486
	call _AccionSonido
	jmp L448
	.p2align 4,,7
L486:
	movl _mouse_y,%eax
	cmpl $400,%eax
	jle L488
	movl _mouse_y,%eax
	cmpl $479,%eax
	jg L488
	movl _mouse_x,%eax
	cmpl $560,%eax
	jle L488
	movl _mouse_x,%eax
	cmpl $639,%eax
	jg L488
	.p2align 4,,7
L491:
	movl _mouse_b,%eax
	testl %eax,%eax
	jne L491
	jmp L449
	.p2align 4,,7
L488:
	movl $_elArticulo,%ebx
	addl $36,%ebx
	movl $3099,%esi
	.p2align 4,,7
L495:
	movl (%ebx),%eax
	addl $-12,%esp
	pushl %eax
	call _free
	addl $16,%esp
	addl $28,%ebx
	decl %esi
	jns L495
	movl _color_blanco,%edx
	movb $0,_elArticulo
	movl $_elArticulo,%eax
	addl $32,%eax
	movl $3099,%ecx
	.p2align 4,,7
L501:
	movl $0,4(%eax)
	movl %edx,-20(%eax)
	movl $10,-16(%eax)
	movl $2,-12(%eax)
	movl $0,(%eax)
	addl $28,%eax
	decl %ecx
	jns L501
	movb $0,_elArticulo
	movl $19,%ecx
	movl $_elArticulo,%eax
	addl $86888,%eax
	.p2align 4,,7
L506:
	movl $0,(%eax)
	addl $-4,%eax
	decl %ecx
	jns L506
	xorl %eax,%eax
	movb _losArticulos+1,%al
	movl _losArticulos+4(,%eax,4),%eax
	addl $-12,%esp
	pushl %eax
	call _MostrarArticulo
	addl $16,%esp
L448:
	cmpl $0,-12(%ebp)
	je L450
L449:
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
LC48:
	.ascii "Seccion\0"
LC49:
	.ascii "Titulo\0"
LC50:
	.ascii "Autor\0"
	.p2align 2
.globl _MostrarTitulo
_MostrarTitulo:
	pushl %ebp
	movl %esp,%ebp
	subl $12,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	addl $-4,%esp
	pushl $255
	pushl $255
	pushl $128
	call _makecol
	movl %eax,%esi
	addl $-4,%esp
	pushl $255
	pushl $255
	pushl $255
	call _makecol
	movl %eax,%edi
	addl $32,%esp
	movl 28(%ebx),%edx
	addl $-8,%esp
	movl 8(%edx),%eax
	pushl %eax
	pushl $80
	pushl $463
	pushl $60
	pushl $0
	pushl %ebx
	movl 40(%edx),%eax
	call *%eax
	addl $32,%esp
	addl $-8,%esp
	pushl %esi
	pushl $50
	pushl $0
	pushl $LC48
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	pushl %ebx
	call _textout
	addl $32,%esp
	addl $-8,%esp
	pushl %edi
	pushl $50
	pushl $64
	xorl %eax,%eax
	movb _losArticulos+1,%al
	movl _losArticulos+204(,%eax,4),%eax
	pushl %eax
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	pushl %ebx
	call _textout
	addl $32,%esp
	addl $-8,%esp
	pushl %esi
	pushl $60
	pushl $0
	pushl $LC49
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	pushl %ebx
	call _textout
	addl $32,%esp
	addl $-8,%esp
	pushl %edi
	pushl $60
	pushl $64
	xorl %eax,%eax
	movb _losArticulos+1,%al
	movl _losArticulos+604(,%eax,4),%eax
	pushl %eax
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	pushl %ebx
	call _textout
	addl $32,%esp
	addl $-8,%esp
	pushl %esi
	pushl $70
	pushl $0
	pushl $LC50
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	pushl %ebx
	call _textout
	addl $32,%esp
	addl $-8,%esp
	pushl %edi
	pushl $70
	pushl $64
	xorl %eax,%eax
	movb _losArticulos+1,%al
	movl _losArticulos+404(,%eax,4),%eax
	pushl %eax
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	pushl %ebx
	call _textout
	addl $32,%esp
	cmpl $0,_grises
	jne L515
	movl _configuracion,%eax
	addl $-12,%esp
	movl 128(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L515:
	pushl $30
	pushl $464
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl 48(%eax),%eax
	pushl %eax
	call _blit
	addl $32,%esp
	pushl $30
	pushl $464
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	pushl %ebx
	call _masked_blit
	leal -24(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
LC51:
	.ascii "/\0"
LC52:
	.ascii " pag\0"
	.p2align 2
.globl _MostrarInfoArticulo
_MostrarInfoArticulo:
	pushl %ebp
	movl %esp,%ebp
	subl $172,%esp
	movl $-2004318071,%ecx
	pushl %edi
	pushl %esi
	pushl %ebx
	movl _elArticulo+8,%esi
	movl %esi,%eax
	imull %ecx
	movl _elArticulo+4,%edi
	leal (%esi,%edx),%eax
	sarl $4,%eax
	movl %esi,%edx
	sarl $31,%edx
	movl %eax,%esi
	subl %edx,%esi
	movl %edi,%eax
	imull %ecx
	leal (%edi,%edx),%eax
	sarl $4,%eax
	movl %edi,%edx
	sarl $31,%edx
	movl %eax,%edi
	subl %edx,%edi
	movl %edi,%eax
	imull %ecx
	addl %edi,%edx
	sarl $4,%edx
	movl %edi,%eax
	sarl $31,%eax
	subl %eax,%edx
	movl %edx,%eax
	sall $4,%eax
	subl %edx,%eax
	addl %eax,%eax
	cmpl %eax,%edi
	jne L518
	cmpl $29,%edi
	jg L517
L518:
	incl %edi
L517:
	movl $-2004318071,%edx
	movl %edx,%eax
	imull %esi
	addl %esi,%edx
	sarl $4,%edx
	movl %esi,%eax
	sarl $31,%eax
	subl %eax,%edx
	movl %edx,%eax
	sall $4,%eax
	subl %edx,%eax
	addl %eax,%eax
	cmpl %eax,%esi
	jne L520
	cmpl $29,%esi
	jg L519
L520:
	incl %esi
L519:
	addl $-4,%esp
	pushl $10
	leal -36(%ebp),%ebx
	pushl %ebx
	pushl %esi
	call _itoa
	addl $-8,%esp
	pushl %ebx
	leal -164(%ebp),%esi
	pushl %esi
	call _strcpy
	addl $32,%esp
	addl $-8,%esp
	pushl $LC51
	pushl %esi
	call _strcat
	addl $-4,%esp
	pushl $10
	pushl %ebx
	pushl %edi
	call _itoa
	addl $32,%esp
	addl $-8,%esp
	pushl %ebx
	pushl %esi
	call _strcat
	addl $-8,%esp
	pushl $LC52
	pushl %esi
	call _strcat
	movl 8(%ebp),%eax
	addl $32,%esp
	movl 28(%eax),%edx
	addl $-8,%esp
	movl 8(%edx),%eax
	pushl %eax
	pushl $75
	pushl $639
	pushl $45
	pushl $540
	movl 8(%ebp),%eax
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	addl $32,%esp
	addl $-8,%esp
	addl $-4,%esp
	pushl $255
	pushl $255
	pushl $255
	call _makecol
	pushl %eax
	pushl $45
	pushl $540
	pushl %esi
	movl _datafile,%eax
	movl 128(%eax),%eax
	pushl %eax
	movl 8(%ebp),%eax
	pushl %eax
	call _textout
	addl $48,%esp
	cmpl $0,_grises
	jne L523
	movl _configuracion,%eax
	addl $-12,%esp
	movl 128(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L523:
	pushl $30
	pushl $100
	pushl $45
	pushl $540
	pushl $45
	pushl $540
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl 48(%eax),%eax
	pushl %eax
	call _blit
	addl $32,%esp
	pushl $30
	pushl $100
	pushl $45
	pushl $540
	pushl $45
	pushl $540
	movl _videoTemporal,%eax
	pushl %eax
	movl 8(%ebp),%eax
	pushl %eax
	call _masked_blit
	leal -184(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _MostrarBotones
_MostrarBotones:
	pushl %ebp
	movl %esp,%ebp
	subl $12,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	cmpl $0,_grises
	jne L525
	movl _configuracion,%eax
	addl $-12,%esp
	movl 80(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L525:
	pushl $79
	pushl $640
	pushl $401
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl (%eax),%eax
	pushl %eax
	call _blit
	addl $32,%esp
	cmpl $0,_sonido
	jne L526
	xorl %edi,%edi
	.p2align 4,,7
L530:
	addl $-4,%esp
	pushl $0
	pushl $0
	pushl $255
	call _makecol
	movl _videoTemporal,%edx
	movl %eax,%ecx
	leal 16(%edi),%esi
	leal 56(%edi),%ebx
	addl $16,%esp
	addl $-8,%esp
	movl 28(%edx),%eax
	pushl %ecx
	pushl $460
	pushl %ebx
	pushl $422
	pushl %esi
	pushl %edx
	movl 36(%eax),%eax
	call *%eax
	addl $32,%esp
	addl $-4,%esp
	pushl $0
	pushl $0
	pushl $255
	call _makecol
	movl %eax,%ecx
	movl _videoTemporal,%eax
	addl $16,%esp
	addl $-8,%esp
	movl 28(%eax),%edx
	pushl %ecx
	pushl $422
	pushl %ebx
	pushl $460
	pushl %esi
	pushl %eax
	movl 36(%edx),%eax
	call *%eax
	addl $32,%esp
	incl %edi
	cmpl $5,%edi
	jle L530
L526:
	leal -24(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _ScrollArriba30Lineas
_ScrollArriba30Lineas:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl $0,-4(%ebp)
	movl _elArticulo+4,%eax
	cmpl %eax,_elArticulo+8
	jge L546
	cmpl $0,_grises
	jne L547
	movl _configuracion,%eax
	addl $-12,%esp
	movl 112(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L547:
	pushl $320
	pushl $640
	pushl $80
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _fondo,%eax
	pushl %eax
	call _blit
	movl _videoTemporal,%eax
	addl $32,%esp
	addl $-8,%esp
	movl 28(%eax),%edx
	pushl $0
	pushl $400
	pushl $460
	pushl $400
	pushl $0
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	movl _letras,%edx
	addl $32,%esp
	movl 28(%edx),%ecx
	addl $-8,%esp
	movl 8(%ecx),%eax
	pushl %eax
	pushl $400
	pushl $639
	pushl $90
	pushl $0
	pushl %edx
	movl 40(%ecx),%eax
	call *%eax
	movl _elArticulo+8,%eax
	addl $32,%esp
	leal 1(%eax),%esi
	jmp L578
	.p2align 4,,7
L554:
	leal 0(,%esi,8),%edx
	movl %edx,%eax
	subl %esi,%eax
	leal 0(,%eax,4),%ecx
	leal 1(%esi),%eax
	movl _elArticulo+36(%ecx),%ebx
	movl %edx,-20(%ebp)
	movl -4(%ebp),%edx
	movl %eax,-12(%ebp)
	incl %edx
	movl %edx,-16(%ebp)
	testl %ebx,%ebx
	je L553
	movl _elArticulo+20(%ecx),%eax
	cmpl $1,%eax
	je L559
	jb L560
	cmpl $2,%eax
	je L558
	cmpl $3,%eax
	jne L556
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	pushl $4
	pushl %ebx
	movl _datafile,%edx
	movl _elArticulo+16(%ecx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	jmp L579
	.p2align 4,,7
L558:
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	pushl $319
	pushl %ebx
	movl _datafile,%edx
	movl _elArticulo+16(%ecx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _textout_centre
	jmp L580
	.p2align 4,,7
L559:
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	pushl $4
	pushl %ebx
	movl _datafile,%edx
	movl _elArticulo+16(%ecx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	jmp L579
	.p2align 4,,7
L560:
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	movl _elArticulo+16(%ecx),%ecx
	movl %ebx,%edx
	movl %ebx,%eax
	andl $3,%eax
	je L581
	jp L586
	cmpl $2,%eax
	je L587
	cmpb %ah,(%edx)
	je L585
	incl %edx
L587:
	cmpb %ah,(%edx)
	je L585
	incl %edx
L586:
	cmpb %ah,(%edx)
	je L585
	incl %edx
L581:
	movl (%edx),%eax
	testb %ah,%al
	jne L582
	testb %al,%al
	je L585
	testb %ah,%ah
	je L584
L582:
	testl $16711680,%eax
	je L583
	addl $4,%edx
	testl $-16777216,%eax
	jne L581
	subl $3,%edx
L583:
	incl %edx
L584:
	incl %edx
L585:
	movl _letras,%eax
	movl %eax,-8(%ebp)
	movl _datafile,%edi
	subl %ebx,%edx
	testl %edx,%edx
	jle L561
	cmpb $32,(%edx,%ebx)
	jne L561
	.p2align 4,,7
L564:
	decl %edx
	cmpb $32,(%edx,%ebx)
	jne L561
	testl %edx,%edx
	jge L564
L561:
	cmpl $8,%ecx
	jne L568
	leal (%edx,%edx),%eax
	leal (%eax,%edx,8),%edx
	jmp L569
	.p2align 4,,7
L568:
	sall $3,%edx
L569:
	movl $635,%eax
	subl %edx,%eax
	pushl %eax
	movl -20(%ebp),%eax
	subl %esi,%eax
	sall $2,%eax
	movl _elArticulo+36(%eax),%edx
	pushl %edx
	movl _elArticulo+16(%eax),%eax
	sall $4,%eax
	movl (%edi,%eax),%eax
	pushl %eax
	movl -8(%ebp),%edx
	pushl %edx
L579:
	call _textout
L580:
	addl $32,%esp
L556:
	subl %esi,-20(%ebp)
	movl -20(%ebp),%ebx
	sall $2,%ebx
	movl _elArticulo+32(%ebx),%eax
	testl %eax,%eax
	je L553
	cmpl $0,_grises
	jne L574
	movl _elArticulo+86892(,%eax,4),%eax
	addl $-12,%esp
	pushl %eax
	call _select_pallete
	addl $16,%esp
L574:
	pushl $10
	movl _elArticulo+32(%ebx),%eax
	sall $2,%eax
	movl _elArticulo+86812(%eax),%edx
	movl (%edx),%eax
	pushl %eax
	movl -4(%ebp),%ecx
	leal (%ecx,%ecx,4),%eax
	leal 90(,%eax,2),%eax
	pushl %eax
	xorl %eax,%eax
	movb _elArticulo+24(%ebx),%al
	sall $3,%eax
	addl $4,%eax
	pushl %eax
	movl _elArticulo+28(%ebx),%eax
	pushl %eax
	pushl $0
	movl _letras,%eax
	pushl %eax
	pushl %edx
	call _blit
	addl $32,%esp
L553:
	movl -12(%ebp),%esi
	movl -16(%ebp),%eax
	movl %eax,-4(%ebp)
	movl _elArticulo+8,%eax
L578:
	addl $31,%eax
	cmpl %eax,%esi
	jl L554
	addl $30,_elArticulo+8
	pushl $480
	pushl $640
	pushl $0
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _masked_blit
	movl _letras,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _MostrarInfoArticulo
	movl _mouse_x,%eax
	addl $16,%esp
	testl %eax,%eax
	jl L576
	movl _mouse_x,%eax
	cmpl $639,%eax
	jg L576
	movl _mouse_y,%eax
	cmpl $49,%eax
	jle L576
	movl _mouse_y,%eax
	cmpl $399,%eax
	jg L576
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	jmp L546
	.p2align 4,,7
L576:
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
L546:
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _ScrollAbajo30Lineas
_ScrollAbajo30Lineas:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl $0,-4(%ebp)
	movl _elArticulo+8,%eax
	cmpl $29,%eax
	jle L589
	cmpl $59,%eax
	jg L590
	movl $0,_elArticulo+8
	jmp L591
	.p2align 4,,7
L590:
	addl $-59,%eax
	movl %eax,_elArticulo+8
L591:
	cmpl $0,_grises
	jne L592
	movl _configuracion,%eax
	addl $-12,%esp
	movl 112(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L592:
	pushl $320
	pushl $640
	pushl $80
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _fondo,%eax
	pushl %eax
	call _blit
	movl _videoTemporal,%eax
	addl $32,%esp
	addl $-8,%esp
	movl 28(%eax),%edx
	pushl $0
	pushl $400
	pushl $460
	pushl $400
	pushl $0
	pushl %eax
	movl 40(%edx),%eax
	call *%eax
	movl _letras,%edx
	addl $32,%esp
	movl 28(%edx),%ecx
	addl $-8,%esp
	movl 8(%ecx),%eax
	pushl %eax
	pushl $400
	pushl $639
	pushl $90
	pushl $0
	pushl %edx
	movl 40(%ecx),%eax
	call *%eax
	movl _elArticulo+8,%esi
	addl $32,%esp
	leal 30(%esi),%eax
	cmpl %eax,%esi
	jge L597
	.p2align 4,,7
L599:
	leal 0(,%esi,8),%edx
	movl %edx,%eax
	subl %esi,%eax
	leal 0(,%eax,4),%ecx
	leal 1(%esi),%eax
	movl _elArticulo+36(%ecx),%ebx
	movl %edx,-20(%ebp)
	movl -4(%ebp),%edx
	movl %eax,-12(%ebp)
	incl %edx
	movl %edx,-16(%ebp)
	testl %ebx,%ebx
	je L598
	movl _elArticulo+20(%ecx),%eax
	cmpl $1,%eax
	je L604
	jb L605
	cmpl $2,%eax
	je L603
	cmpl $3,%eax
	jne L601
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	pushl $4
	pushl %ebx
	movl _datafile,%edx
	movl _elArticulo+16(%ecx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	jmp L623
	.p2align 4,,7
L603:
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	pushl $319
	pushl %ebx
	movl _datafile,%edx
	movl _elArticulo+16(%ecx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _textout_centre
	jmp L624
	.p2align 4,,7
L604:
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	pushl $4
	pushl %ebx
	movl _datafile,%edx
	movl _elArticulo+16(%ecx),%eax
	sall $4,%eax
	movl (%edx,%eax),%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	jmp L623
	.p2align 4,,7
L605:
	movl _elArticulo+12(%ecx),%eax
	addl $-8,%esp
	pushl %eax
	movl -4(%ebp),%edx
	leal 90(,%edx,2),%eax
	leal (%eax,%edx,8),%eax
	pushl %eax
	movl _elArticulo+16(%ecx),%ecx
	movl %ebx,%edx
	movl %ebx,%eax
	andl $3,%eax
	je L625
	jp L630
	cmpl $2,%eax
	je L631
	cmpb %ah,(%edx)
	je L629
	incl %edx
L631:
	cmpb %ah,(%edx)
	je L629
	incl %edx
L630:
	cmpb %ah,(%edx)
	je L629
	incl %edx
L625:
	movl (%edx),%eax
	testb %ah,%al
	jne L626
	testb %al,%al
	je L629
	testb %ah,%ah
	je L628
L626:
	testl $16711680,%eax
	je L627
	addl $4,%edx
	testl $-16777216,%eax
	jne L625
	subl $3,%edx
L627:
	incl %edx
L628:
	incl %edx
L629:
	movl _letras,%eax
	movl %eax,-8(%ebp)
	movl _datafile,%edi
	subl %ebx,%edx
	testl %edx,%edx
	jle L606
	cmpb $32,(%edx,%ebx)
	jne L606
	.p2align 4,,7
L609:
	decl %edx
	cmpb $32,(%edx,%ebx)
	jne L606
	testl %edx,%edx
	jge L609
L606:
	cmpl $8,%ecx
	jne L613
	leal (%edx,%edx),%eax
	leal (%eax,%edx,8),%edx
	jmp L614
	.p2align 4,,7
L613:
	sall $3,%edx
L614:
	movl $635,%eax
	subl %edx,%eax
	pushl %eax
	movl -20(%ebp),%eax
	subl %esi,%eax
	sall $2,%eax
	movl _elArticulo+36(%eax),%edx
	pushl %edx
	movl _elArticulo+16(%eax),%eax
	sall $4,%eax
	movl (%edi,%eax),%eax
	pushl %eax
	movl -8(%ebp),%edx
	pushl %edx
L623:
	call _textout
L624:
	addl $32,%esp
L601:
	subl %esi,-20(%ebp)
	movl -20(%ebp),%ebx
	sall $2,%ebx
	movl _elArticulo+32(%ebx),%eax
	testl %eax,%eax
	je L598
	cmpl $0,_grises
	jne L619
	movl _elArticulo+86892(,%eax,4),%eax
	addl $-12,%esp
	pushl %eax
	call _select_pallete
	addl $16,%esp
L619:
	pushl $10
	movl _elArticulo+32(%ebx),%eax
	sall $2,%eax
	movl _elArticulo+86812(%eax),%edx
	movl (%edx),%eax
	pushl %eax
	movl -4(%ebp),%ecx
	leal (%ecx,%ecx,4),%eax
	leal 90(,%eax,2),%eax
	pushl %eax
	xorl %eax,%eax
	movb _elArticulo+24(%ebx),%al
	sall $3,%eax
	addl $4,%eax
	pushl %eax
	movl _elArticulo+28(%ebx),%eax
	pushl %eax
	pushl $0
	movl _letras,%eax
	pushl %eax
	pushl %edx
	call _blit
	addl $32,%esp
L598:
	movl -12(%ebp),%esi
	movl -16(%ebp),%eax
	movl %eax,-4(%ebp)
	movl _elArticulo+8,%eax
	addl $30,%eax
	cmpl %eax,%esi
	jl L599
L597:
	addl $29,_elArticulo+8
	pushl $480
	pushl $640
	pushl $0
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _letras,%eax
	pushl %eax
	call _masked_blit
	movl _letras,%eax
	addl $32,%esp
	addl $-12,%esp
	pushl %eax
	call _MostrarInfoArticulo
	movl _mouse_x,%eax
	addl $16,%esp
	testl %eax,%eax
	jl L621
	movl _mouse_x,%eax
	cmpl $639,%eax
	jg L621
	movl _mouse_y,%eax
	cmpl $49,%eax
	jle L621
	movl _mouse_y,%eax
	cmpl $399,%eax
	jg L621
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	jmp L589
	.p2align 4,,7
L621:
	pushl $350
	pushl $640
	pushl $50
	pushl $0
	pushl $50
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
L589:
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _AccionSonido
_AccionSonido:
	pushl %ebp
	movl %esp,%ebp
	subl $12,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	.p2align 4,,7
L635:
	movl _mouse_b,%eax
	testl %eax,%eax
	jne L635
	cmpl $0,_sonido
	je L636
	movl $0,_sonido
	cmpl $0,_grises
	jne L637
	movl _configuracion,%eax
	addl $-12,%esp
	movl 80(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L637:
	pushl $79
	pushl $79
	pushl $401
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl (%eax),%eax
	pushl %eax
	call _blit
	xorl %edi,%edi
	addl $32,%esp
	.p2align 4,,7
L641:
	addl $-4,%esp
	pushl $0
	pushl $0
	pushl $255
	call _makecol
	movl _videoTemporal,%edx
	movl %eax,%ecx
	leal 16(%edi),%esi
	leal 56(%edi),%ebx
	addl $16,%esp
	addl $-8,%esp
	movl 28(%edx),%eax
	pushl %ecx
	pushl $460
	pushl %ebx
	pushl $422
	pushl %esi
	pushl %edx
	movl 36(%eax),%eax
	call *%eax
	addl $32,%esp
	addl $-4,%esp
	pushl $0
	pushl $0
	pushl $255
	call _makecol
	movl %eax,%ecx
	movl _videoTemporal,%eax
	addl $16,%esp
	addl $-8,%esp
	movl 28(%eax),%edx
	pushl %ecx
	pushl $422
	pushl %ebx
	pushl $460
	pushl %esi
	pushl %eax
	movl 36(%edx),%eax
	call *%eax
	addl $32,%esp
	incl %edi
	cmpl $5,%edi
	jle L641
	jmp L645
	.p2align 4,,7
L636:
	movl $1,_sonido
	cmpl $0,_grises
	jne L646
	movl _configuracion,%eax
	addl $-12,%esp
	movl 80(%eax),%eax
	pushl %eax
	call _select_pallete
	addl $16,%esp
L646:
	pushl $79
	pushl $79
	pushl $401
	pushl $0
	pushl $0
	pushl $0
	movl _videoTemporal,%eax
	pushl %eax
	movl _configuracion,%eax
	movl (%eax),%eax
	pushl %eax
	call _blit
	addl $32,%esp
L645:
	movl _mouse_y,%eax
	cmpl $400,%eax
	jle L647
	movl _mouse_y,%eax
	cmpl $479,%eax
	jg L647
	movl _mouse_x,%eax
	testl %eax,%eax
	jl L647
	movl _mouse_x,%eax
	cmpl $79,%eax
	jg L647
	addl $-12,%esp
	pushl $0
	call _show_mouse
	pushl $79
	pushl $79
	pushl $401
	pushl $0
	pushl $401
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
	movl _screen,%eax
	addl $48,%esp
	addl $-12,%esp
	pushl %eax
	call _show_mouse
	jmp L648
	.p2align 4,,7
L647:
	pushl $79
	pushl $79
	pushl $401
	pushl $0
	pushl $401
	pushl $0
	movl _screen,%eax
	pushl %eax
	movl _videoTemporal,%eax
	pushl %eax
	call _blit
L648:
	leal -24(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _HacerJustificacion
_HacerJustificacion:
	pushl %ebp
	movl %esp,%ebp
	subl $1036,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%eax
	xorl %esi,%esi
	movl $0,-1004(%ebp)
	xorl %edi,%edi
	movl %eax,%edx
	addl $-8,%esp
	leal -500(%ebp),%ebx
	andl $3,%eax
	je L699
	jp L704
	cmpl $2,%eax
	je L705
	cmpb %ah,(%edx)
	je L703
	incl %edx
L705:
	cmpb %ah,(%edx)
	je L703
	incl %edx
L704:
	cmpb %ah,(%edx)
	je L703
	incl %edx
L699:
	movl (%edx),%eax
	testb %ah,%al
	jne L700
	testb %al,%al
	je L703
	testb %ah,%ah
	je L702
L700:
	testl $16711680,%eax
	je L701
	addl $4,%edx
	testl $-16777216,%eax
	jne L699
	subl $3,%edx
L701:
	incl %edx
L702:
	incl %edx
L703:
	movl 8(%ebp),%eax
	subl %eax,%edx
	movl %edx,-1016(%ebp)
	pushl %eax
	pushl %ebx
	call _strcpy
	cmpl $0,-1016(%ebp)
	jle L650
	cmpb $32,-500(%ebp)
	jne L652
	cmpl -1016(%ebp),%edi
	jge L652
	movl %ebx,%eax
	.p2align 4,,7
L653:
	incl %esi
	cmpb $32,(%esi,%eax)
	jne L652
	cmpl -1016(%ebp),%esi
	jl L653
L652:
	movl %esi,-1008(%ebp)
	cmpl -1016(%ebp),%esi
	jge L657
	leal -500(%ebp),%eax
	.p2align 4,,7
L658:
	cmpb $32,(%esi,%eax)
	jne L659
	incl -1004(%ebp)
L659:
	incl %esi
	cmpl -1016(%ebp),%esi
	jl L658
L657:
	cmpl $1,16(%ebp)
	jne L650
	movl $79,%eax
	cmpl $8,12(%ebp)
	jne L664
	movl $64,%eax
L664:
	movl %eax,%esi
	subl -1016(%ebp),%esi
	cmpl $0,-1004(%ebp)
	jne L666
	movl $0,-1012(%ebp)
	xorl %ebx,%ebx
	jmp L667
	.p2align 4,,7
L666:
	movl %esi,%eax
	cltd
	idivl -1004(%ebp)
	movl %eax,-1012(%ebp)
	movl %edx,%ebx
L667:
	movl -1008(%ebp),%edi
	xorl %ecx,%ecx
	cmpl -1004(%ebp),%esi
	jge L668
	movl %edi,%esi
	cmpl -1016(%ebp),%edi
	jge L670
	leal -500(%ebp),%eax
	movl %eax,-1020(%ebp)
	.p2align 4,,7
L672:
	movl -1020(%ebp),%edx
	cmpb $32,(%esi,%edx)
	jne L673
	cmpl %ebx,%ecx
	jge L673
	movl 8(%ebp),%eax
	movb $32,(%edi,%eax)
	movb $32,1(%eax,%edi)
	incl %edi
	incl %ecx
	jmp L671
	.p2align 4,,7
L673:
	movl -1020(%ebp),%edx
	movl 8(%ebp),%eax
	movb (%esi,%edx),%dl
	movb %dl,(%edi,%eax)
L671:
	incl %esi
	incl %edi
	cmpl -1016(%ebp),%esi
	jl L672
L670:
	movl 8(%ebp),%edx
	movb $0,(%edi,%edx)
	jmp L650
	.p2align 4,,7
L668:
	xorl %esi,%esi
	cmpl -1004(%ebp),%esi
	jge L678
	leal -1000(%ebp),%edx
	movb -1012(%ebp),%al
	incb %al
	.p2align 4,,7
L680:
	movb %al,(%esi,%edx)
	incl %esi
	cmpl -1004(%ebp),%esi
	jl L680
L678:
	xorl %esi,%esi
	cmpl %ebx,%esi
	jge L683
	leal -1000(%ebp),%eax
	.p2align 4,,7
L685:
	incb (%esi,%eax)
	incl %esi
	cmpl %ebx,%esi
	jl L685
L683:
	movl -1008(%ebp),%esi
	cmpl -1016(%ebp),%esi
	jge L688
	leal -500(%ebp),%ebx
	.p2align 4,,7
L690:
	movb (%esi,%ebx),%al
	cmpb $32,%al
	jne L691
	xorl %eax,%eax
	movb -1000(%ecx,%ebp),%al
	leal 1(%esi),%edx
	incl %ecx
	testl %eax,%eax
	je L693
	.p2align 4,,7
L695:
	movl 8(%ebp),%esi
	movb $32,(%edi,%esi)
	incl %edi
	decl %eax
	jnz L695
L693:
	decl %edi
	jmp L689
	.p2align 4,,7
L691:
	movl 8(%ebp),%edx
	movb %al,(%edi,%edx)
	leal 1(%esi),%edx
L689:
	movl %edx,%esi
	incl %edi
	cmpl -1016(%ebp),%esi
	jl L690
L688:
	movl 8(%ebp),%esi
	movb $0,(%edi,%esi)
L650:
	leal -1048(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _GeneraColores
_GeneraColores:
	pushl %ebp
	movl %esp,%ebp
	subl $8,%esp
	addl $-4,%esp
	pushl $0
	pushl $0
	pushl $255
	call _makecol
	movl %eax,_color_rojo
	addl $-4,%esp
	pushl $0
	pushl $180
	pushl $0
	call _makecol
	movl %eax,_color_verde
	addl $32,%esp
	addl $-4,%esp
	pushl $255
	pushl $0
	pushl $0
	call _makecol
	movl %eax,_color_azul
	addl $-4,%esp
	pushl $0
	pushl $0
	pushl $0
	call _makecol
	movl %eax,_color_negro
	addl $32,%esp
	addl $-4,%esp
	pushl $255
	pushl $255
	pushl $255
	call _makecol
	movl %eax,_color_blanco
	addl $-4,%esp
	pushl $4
	pushl $139
	pushl $178
	call _makecol
	movl %eax,_color_marron
	addl $32,%esp
	addl $-4,%esp
	pushl $17
	pushl $255
	pushl $252
	call _makecol
	movl %eax,_color_amarillo
	addl $-4,%esp
	pushl $246
	pushl $128
	pushl $211
	call _makecol
	movl %eax,_color_violeta
	addl $32,%esp
	addl $-4,%esp
	pushl $66
	pushl $255
	pushl $80
	call _makecol
	movl %eax,_color_verdeFosforito
	addl $-4,%esp
	pushl $255
	pushl $226
	pushl $29
	call _makecol
	movl %eax,_color_azulClaro
	addl $32,%esp
	addl $-4,%esp
	pushl $29
	pushl $125
	pushl $255
	call _makecol
	movl %eax,_color_naranja
	addl $-4,%esp
	pushl $152
	pushl $148
	pushl $136
	call _makecol
	movl %eax,_color_gris
	addl $32,%esp
	addl $-4,%esp
	pushl $231
	pushl $230
	pushl $222
	call _makecol
	movl %eax,_color_grisClaro
	movl %ebp,%esp
	popl %ebp
	ret
.comm _i,4
.comm _paletaGris,1024
.comm _elArticulo,86972
.comm _datafile,4
.comm _revista,4
.comm _configuracion,4
.comm _losArticulos,804
.comm _grises,4
.comm _color_rojo,4
.comm _color_verde,4
.comm _color_azul,4
.comm _color_negro,4
.comm _color_blanco,4
.comm _color_marron,4
.comm _color_amarillo,4
.comm _color_violeta,4
.comm _color_verdeFosforito,4
.comm _color_azulClaro,4
.comm _color_naranja,4
.comm _color_gris,4
.comm _color_grisClaro,4
	.p2align 2
.globl _LeerArchivoDatos
_LeerArchivoDatos:
	pushl %ebp
	movl %esp,%ebp
	subl $20,%esp
	pushl %ebx
	movl 8(%ebp),%eax
	movl 12(%ebp),%ebx
	addl $-12,%esp
	pushl %eax
	call _load_datafile
	movl %eax,(%ebx)
	addl $16,%esp
	testl %ebx,%ebx
	jne L188
	call _allegro_exit
	addl $-12,%esp
	pushl $LC14
	call _printf
L188:
	movl -24(%ebp),%ebx
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _InicializarArticulo
_InicializarArticulo:
	pushl %ebp
	movl %esp,%ebp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl _color_blanco,%edx
	movl $_elArticulo+16,%edi
	movl $_elArticulo+20,%esi
	movl $_elArticulo+32,%ebx
	xorl %eax,%eax
	movl $3099,%ecx
	.p2align 4,,7
L351:
	movl $0,_elArticulo+36(%eax)
	movl %edx,_elArticulo+12(%eax)
	movl $10,(%edi,%eax)
	movl $2,(%esi,%eax)
	movl $0,(%ebx,%eax)
	addl $28,%eax
	decl %ecx
	jns L351
	movb $0,_elArticulo
	movl $19,%ecx
	movl $_elArticulo+86888,%eax
	.p2align 4,,7
L356:
	movl $0,(%eax)
	addl $-4,%eax
	decl %ecx
	jns L356
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _EliminarArticulo
_EliminarArticulo:
	pushl %ebp
	movl %esp,%ebp
	subl $16,%esp
	pushl %esi
	pushl %ebx
	movl $_elArticulo+36,%esi
	movl $3099,%ebx
	.p2align 4,,7
L362:
	movl (%esi),%eax
	addl $-12,%esp
	pushl %eax
	call _free
	addl $16,%esp
	addl $28,%esi
	decl %ebx
	jns L362
	leal -24(%ebp),%esp
	movb $0,_elArticulo
	popl %ebx
	popl %esi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _InicializarLosArticulos
_InicializarLosArticulos:
	pushl %ebp
	movl %esp,%ebp
	pushl %edi
	pushl %esi
	pushl %ebx
	movb $0,%dl
	movl 8(%ebp),%eax
	movb $0,(%eax)
	movb $0,1(%eax)
	leal 4(%eax),%edi
	leal 604(%eax),%esi
	leal 204(%eax),%ebx
	leal 404(%eax),%ecx
	.p2align 4,,7
L439:
	xorl %eax,%eax
	movb %dl,%al
	sall $2,%eax
	movl $0,(%eax,%edi)
	movl $0,(%eax,%esi)
	movl $0,(%eax,%ebx)
	movl $0,(%eax,%ecx)
	incb %dl
	cmpb $49,%dl
	jbe L439
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _EliminarLosArticulos
_EliminarLosArticulos:
	pushl %ebp
	movl %esp,%ebp
	subl $12,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	movb $0,(%ebx)
	movb $0,1(%ebx)
	movl $0,_i
	leal 604(%ebx),%eax
	movl %eax,-4(%ebp)
	leal 204(%ebx),%edi
	leal 404(%ebx),%esi
	.p2align 4,,7
L445:
	movl _i,%eax
	sall $2,%eax
	movl $0,4(%eax,%ebx)
	movl -4(%ebp),%edx
	addl $-12,%esp
	movl (%eax,%edx),%eax
	pushl %eax
	call _free
	movl _i,%eax
	sall $2,%eax
	addl $-12,%esp
	movl (%eax,%edi),%eax
	pushl %eax
	call _free
	movl _i,%eax
	addl $32,%esp
	sall $2,%eax
	addl $-12,%esp
	movl (%eax,%esi),%eax
	pushl %eax
	call _free
	movl _i,%edx
	movl -4(%ebp),%ecx
	leal 0(,%edx,4),%eax
	movl $0,(%eax,%ecx)
	movl $0,(%eax,%edi)
	movl $0,(%eax,%esi)
	addl $16,%esp
	leal 1(%edx),%eax
	movl %eax,_i
	movl %eax,%edx
	cmpl $49,%edx
	jle L445
	leal -24(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _MostrarArticulosPantalla
_MostrarArticulosPantalla:
	pushl %ebp
	movl %esp,%ebp
	subl $28,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	addl $-4,%esp
	pushl $255
	pushl $255
	pushl $255
	call _makecol
	movl %eax,%ebx
	addl $-4,%esp
	pushl $40
	pushl $240
	pushl $226
	call _makecol
	movl 8(%ebp),%edx
	movl %eax,-12(%ebp)
	xorl %eax,%eax
	addl $32,%esp
	addl $-8,%esp
	movb (%edx),%al
	movl %eax,-4(%ebp)
	xorl %eax,%eax
	movb 1(%edx),%al
	movl %eax,-8(%ebp)
	pushl %ebx
	pushl $410
	movl %eax,%ebx
	sall $2,%ebx
	pushl $319
	movl 604(%ebx,%edx),%eax
	pushl %eax
	movl _datafile,%eax
	movl 160(%eax),%eax
	pushl %eax
	movl 12(%ebp),%edx
	pushl %edx
	call _textout_centre
	movl $1,%esi
	addl $32,%esp
	addl $4,%ebx
	movl $420,%edi
	.p2align 4,,7
L404:
	movl -8(%ebp),%edx
	leal (%edx,%esi),%eax
	cmpl -4(%ebp),%eax
	jge L403
	movl -12(%ebp),%eax
	addl $-8,%esp
	pushl %eax
	pushl %edi
	pushl $319
	movl 8(%ebp),%edx
	movl 604(%ebx,%edx),%eax
	pushl %eax
	movl _datafile,%eax
	movl 192(%eax),%eax
	pushl %eax
	movl 12(%ebp),%eax
	pushl %eax
	call _textout_centre
	addl $32,%esp
L403:
	addl $4,%ebx
	addl $10,%edi
	incl %esi
	cmpl $5,%esi
	jle L404
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	movl %ebp,%esp
	popl %ebp
	ret
	.p2align 2
.globl _JustificacionDerecha
_JustificacionDerecha:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%ecx
	movl %ecx,%edx
	movl %ecx,%eax
	andl $3,%eax
	je L707
	jp L712
	cmpl $2,%eax
	je L713
	cmpb %ah,(%edx)
	je L711
	incl %edx
L713:
	cmpb %ah,(%edx)
	je L711
	incl %edx
L712:
	cmpb %ah,(%edx)
	je L711
	incl %edx
L707:
	movl (%edx),%eax
	testb %ah,%al
	jne L708
	testb %al,%al
	je L711
	testb %ah,%ah
	je L710
L708:
	testl $16711680,%eax
	je L709
	addl $4,%edx
	testl $-16777216,%eax
	jne L707
	subl $3,%edx
L709:
	incl %edx
L710:
	incl %edx
L711:
	subl %ecx,%edx
	testl %edx,%edx
	jle L535
	cmpb $32,(%edx,%ecx)
	jne L535
	.p2align 4,,7
L538:
	decl %edx
	cmpb $32,(%edx,%ecx)
	jne L535
	testl %edx,%edx
	jge L538
L535:
	cmpl $8,12(%ebp)
	jne L543
	leal (%edx,%edx),%eax
	leal (%eax,%edx,8),%edx
	jmp L541
	.p2align 4,,7
L543:
	sall $3,%edx
L541:
	movl %edx,%eax
	movl %ebp,%esp
	popl %ebp
	ret
