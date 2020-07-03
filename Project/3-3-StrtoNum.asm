assume cs:code, ds:data, ss:stacksg

data segment
	year dw 0
	keybuf db 0,0,'65535',0dh
data ends

stacksg segment
	dw 16 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 32
		
		call StrtoNum
		
		mov ax, 4c00h
		int 21h
		
	StrtoNum:
		push ax
		push bx
		push cx
		push dx
		
		call len_y
		mov cx, 0
		handle:
			cmp bx, 0
			jz return
			mov ax, 10
			mov dl, keybuf[bx+1]
			sub dl, 30h
			mov dh, 0
			call Power

			mul dx
			add year[0], ax
			dec bx
			inc cx
			jmp handle
		
		return:
			pop dx
			pop cx
			pop bx
			pop ax
		
			ret

		
		
	Power:
		push bx
		push cx
		push dx
		cmp cx, 0
		jnz lp
		mov ax, 1
		pop dx
		pop cx
		pop bx
		ret
		
		lp:
			mov bx, ax
			mov ax, 1
			s:
				mul bx
				loop s
			
			pop dx
			pop cx
			pop bx
			ret
			
	len_y:
		mov bx, -1
		len1:
			inc bx
			cmp keybuf[bx], 0dh
			jnz len1
		sub bx, 2
		
		ret
code ends
end start