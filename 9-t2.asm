assume cs:code, ds:data, ss:stacksg
data segment
	table dw charpush, charpop, charshow
	top dw 0
	
	s db 30 dup(0)
	t db 30 dup(0)
	i db 0
	j db 0
	len_s dw 0
	len_t dw 0
	next dw 51 dup(0)
	result db 6 dup(0)
data ends

stacksg segment stack
	dw 20 dup(0)
stacksg ends
 
code segment 
	start:
		mov ax, data
		mov ds, ax
		mov ax, stacksg
		mov ss, ax
		mov sp, 40
		
		mov si, offset s	
		call getstr
		
		mov ax, 0
		mov top, ax
		mov si, offset t
		call getstr
		
		call kmp
		
		; mov ax, 30
		call shownum
		
		int 16h
		mov ax, 4c00h
		int 21h
	
	len:
		push bx
		
		mov bx, -1
		len1:
			inc bx
			cmp s[bx], '$'
			jnz len1
		mov len_s, bx
		
		mov bx, -1
		len2:
			inc bx
			cmp t[bx],'$'
			jnz len2
		mov len_t, bx
		
		pop bx
		ret

	cnext:
		push si
		push bx
		push ax
		
		mov si, 1
		mov bx, 0
		mov byte ptr next[1], 0
		cn1:
			cmp si, len_t
			jnb cn1end
			
			cmp bx, 0
			jz cn11
			mov al, t[si-1]
			cmp al, t[bx-1]
			jz cn11
			mov bl, byte ptr next[bx]
			jmp cn1
			cn11:
				inc si
				inc bx
				mov byte ptr next[si], bl
				jmp cn1
		cn1end: nop
		
		pop ax
		pop bx
		pop si
		
		ret
	
	kmp:
		push si
		push bx
		
		call len
		call cnext
		
		mov si, 1
		mov bx, 1
		
		kmp1:
			cmp si, len_s
			jg kmp1end
			cmp bx, len_t
			jg kmp1end
			
			cmp bx, 0
			jz kmp11
			mov al, s[si-1]
			cmp al, t[bx-1]
			jz kmp11
			mov bl, byte ptr next[bx]
			jmp kmp1
			kmp11:
				inc si
				inc bx
				jmp kmp1
		kmp1end: nop	
		
		cmp bx, len_t
		jna kmp2
		
		mov ax, si
		sub ax, len_t
		
		pop bx
		pop si
		
		ret
		
		kmp2: nop
		mov ax, 0
		
		pop bx
		pop si
		
		ret
	
	charstack:
		charstart:
			push bx
			push dx
			push di
			push es
			
			cmp ah, 2
			ja sret
			mov bl, ah
			mov bh, 0
			add bx, bx
			jmp word ptr table[bx]
		
		charpush:
			mov bx,top
			mov [si][bx], al
			inc top
			jmp sret
		
		charpop:
			cmp top, 0
			je sret
			dec top
			mov bx, top
			mov al, [si][bx]
			jmp sret
			
		charshow:
			mov bx, 0b800h
			mov es, bx
			mov al, 160
			mov ah, 0
			mul dh
			mov di, ax
			add dl, dl
			mov dh, 0
			add di, dx
			
			mov bx, 0
		
			charshows:
				cmp bx, top
				jne noempty
				mov byte ptr es:[di], ' '
				jmp sret
			noempty:
				mov al, [si][bx]
				mov es:[di], al
				mov byte ptr es:[di+2], ' '
				inc bx
				add di, 2
				jmp charshows
		
		sret: 
			pop es
			pop di
			pop dx
			pop bx
			
			ret
		
	getstr:
		push ax
		
		getstrs:
			mov ah, 0
			int 16h
			cmp al, 20h
			jb	nochar
			mov ah, 0
			call charstack
			mov ah, 2
			call charstack
			jmp getstrs
		
		nochar:
			cmp ah, 0eh
			je backspace
			cmp ah, 1ch
			je enter
			jmp getstrs
		
		backspace:
			mov ah, 1
			call charstack
			mov ah, 2
			call charstack
			jmp getstrs
			
		enter:
			mov al, '$'
			mov ah, 0
			call charstack
			mov ah, 2
			call charstack
			
		pop ax
		
		ret

	shownum:
		push bx
		push cx
		push dx
		push es
		push di
		
		mov dx, 0
		dtoc:
			mov cl, 10
			div cl
			cmp ah, 0
			jnz dtoc1
			cmp al, 0
			jnz dtoc1
			jmp dtocend
			
			dtoc1:
				inc dx
				mov bx, 0
				mov bl, ah
				push bx
				cmp al, 0
				jz dtocend
				
				mov ah, 0
				
				jmp dtoc
		dtocend: nop
		
		cmp dx, 0
		jnz sh
		mov ax, 0
		inc dx
		push ax
		sh:
		mov bx, 0
		add dx, dx
		mov ax, 0b800h
		mov es, ax
		mov di, 160*12+10
		show_str:
			pop ax
			add ax, 30h
			mov byte ptr es:[bx+di], al
			inc bx
			inc bx
			cmp bx, dx
			jnz show_str
		
		pop di
		pop es
		pop dx
		pop cx
		pop bx
		ret


code ends

end start