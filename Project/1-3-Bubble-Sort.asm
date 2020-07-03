assume cs:code, ds:data, ss:stacksg

data segment
	s db 49, 38, 65, 97, 76, 13, 27, 49
	len dw 8
data ends

stacksg segment stack
	dw 64 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 128
		
		call BublleSort
		
		mov ax, 4c00h
		int 21h
		
	BublleSort:
		push ax
		push bx
		push cx
		
		mov ax, 0
		forB1:
			cmp ax, len
			jae endforB1
			
			mov cx, 0
			mov bx, 0
			forB2:
				push ax
				push bx
				push cx
				mov cx, ax
				mov ax, len
				sub ax, cx
				;inc bx
				cmp bx, ax
				pop cx
				pop bx
				pop ax
				jae endforB2
					
					ifB1:
						push ax
						mov al, s[bx]
						cmp al, s[bx+1]
						pop ax
						jbe endifB1
						
						mov cx, 1
						call Swap
						
						endifB1:
							nop
					
				inc bx
				jmp forB2
				endforB2:
					nop
			
			ifB2:
				cmp cx, 0
				jz endforB1
			
			inc ax
			jmp forB1
			endforB1:
				nop
				
		pop cx
		pop bx
		pop ax
		
		ret
	
	Swap:
		push ax
		push cx
		
		mov al, s[bx]
		mov cl, s[bx+1]
		mov s[bx], cl
		mov s[bx+1], al
		
		pop ax
		pop cx
		
		ret
code ends
end start