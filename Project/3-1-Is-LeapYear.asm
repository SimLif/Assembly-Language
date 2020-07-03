assume cs:code, ds:data, ss:stacksg

data segment
	year dw 0
	constant dw 100, 4, 400
	keybuf db 20, 20 dup(0)
	y db 'Yes$'
	n db 'No$'
data ends

stacksg segment stack
	dw 32 dup(0)
stacksg ends

code segment
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 64
		
		call Input
		call StrtoNum
		call LeapYear
		call Output
		
		mov ax, 4c00h
		int 21h
		
	Input:
		push ax
		push dx
		
		mov dx, offset keybuf
		mov ax, 0a00h
		int 21h
		
		pop dx
		pop ax
		
		ret
		
	StrtoNum:
		push ax
		push bx
		push cx
		push dx
		
		call len_y
		mov cx, 0
		handle:
			cmp bx, 0
			jz returnS
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
		
		returnS:
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

	
	LeapYear:
		push dx
		
		mov dx, 0
		mov ax, year	
		div constant[0]
		cmp dx, 0
		jz com400
		
		mov dx, 0
		mov ax, year
		div constant[2]
		cmp dx, 0
		jz isLeap
		jmp notLeap
		
		com400:
			mov dx, 0
			mov ax, year
			div constant[4]
			cmp dx, 0
			jz isLeap
			jmp notLeap
		
		isLeap:
			mov ax, 1
			jmp returnL
		
		notLeap:
			mov ax, 0
		
		returnL:
			pop dx
			ret
			
	Output:
		push ax
		push dx
		
		
		cmp ax, 1
		jz yes
		mov dx, offset n
		jmp returnO
		
		yes:
			mov dx, offset y
		
		returnO:
			mov ax, 0900h
			int 21h
			pop dx
			pop ax
		
			ret
		
code ends
end start