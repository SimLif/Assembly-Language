assume cs:code 
data segment
	a dw 71d2h
	d dw 5df1h
data ends

code segment
	start: 
		mov ax, data
		mov ds, ax
		
		mov ax, a
		mov dx, d
		; shrd ax, dx, 4
		mov cx, 2
		sr:
			shr dx, 1
			rcr ax, 1
			loop sr
		
		; shld dx, ax, 2
		mov dx, d
		mov bx, ax
		mov cx, 4
		sl:
			shl ax, 1
			rcl dx, 1
			loop sl
		
		mov ax, bx
		
		mov ax, 4c00h
		int 21h
code ends

end start