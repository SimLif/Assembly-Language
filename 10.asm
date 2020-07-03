assume cs:code, ds:data, ss:stacksg

data segment
	a dw 256 dup(1)
	b dw 10
data ends

stacksg segment
	dw 256 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov ax, stacksg
		mov ss, ax
		mov sp, 512
		
		mov bx, 7
		call fibo1
		
		mov ax, 4c00h
		int 21h
	; input: si == 2
	; output: a
	fibo:
		mov ax, a[si-2]
		add ax, a[si]
		mov a[si+2], ax
		inc si
		inc si
		cmp si, b
		ja endf
		call fibo
		
		endf:
			ret
	fibo1:
		cmp bx, 1
		jz rt1
		cmp bx, 2
		jz rt1
		
		push bx
		sub bx, 1
		call fibo1
		pop bx
		mov dx, ax
		
		push bx
		push dx
		sub bx, 2
		call fibo1
		pop dx
		pop bx
		add ax, dx
		jmp rt2
		
		rt1:
			mov ax, 1
		rt2:			
			ret
		
		
		
code ends

end start