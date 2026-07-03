INCLUDE Irvine32.inc

.data
	
Instuc_Head		byte "INSTRUCTIONs",0
Instuc_Text1	byte "Use W , A , S , D  for movement control",0
Instuc_Text2	byte " - Food ,raises the score by 1.",0
Instuc_Text3	byte " - Special Food increase score by 3 occur after every 10 scorings  ",0
Instuc_Text4	byte "# - barrier ,Do not Struct with it ",0
Instuc_Text5	byte "    Randomly Generate a piece after scoring 5 Point  ",0

ObstacleRow byte 50 Dup(0)
ObstacleCol byte 50 Dup(0)
TotalObstacle Dword 0 
callObstacle byte 0

DificultyLevel dword 175
DificultyText1 byte "Select Dificulty Level",0
DificultyText2 byte "1 . Easy",0
DificultyText3 byte "2 . Medium ",0
DificultyText4 byte "3 . Hard" ,0


callSpecialFood byte 0
SpecialFoodRow byte 0
SpecialFoodCol byte 0

;MainMenu
Text1 db "1 : Start Game     ",0
Text2 db "2 : Dificulty Level",0
Text3 db "3 : QUIT           ",0
Text4 db "Press Key :        ",0

PauseText byte "The Game is Paused Press - P - to UnPause",0

ScoreText Byte "SCORE : ",0
Score dword 0
HighestScore dword 0
HighestScoreText  byte "HIGHEST SCORE : "


Game_Over Byte 0
GameOverText byte  "GameOver : Press ESC to return to MainMenu",0

temp byte ?

prevKey byte 'd',0
KeyPressed Byte ?,0

data byte '0',0
SnakeRow byte 10,0
SnakeCol byte 10,0
Snake_Length DWORd 1

;SnakeBody
BodyRow byte 150 Dup(?)
BodyCol byte 150 Dup(?)

PrevRow byte ?,0
PrevCol byte ?,0


;food section
foodRow byte 5,0
foodCol byte 5,0

.code

Init PROC
mov TotalObstacle,0
mov foodCol,5
mov foodRow,5

mov Game_Over,0

mov SnakeRow,10
mov SnakeCol,10

mov Snake_Length,1

mov PrevKey,'d'

ret
Init ENDP

main PROC 
	
	MainMenu:    ;label h ye 
    call clrscr

	mov eax,11
	call setTextColor

	call PrintLogo
	
	
	;start game
	mov eax,3 ; blue 
	call setTextColor

	mov dh,18
	mov dl,46
	call gotoxy
	mov edx,offset Text1
	call writeString
	mov dh,19
	mov dl,46
	call gotoxy

	mov edx,offset Text2
	call writeString
	mov dh,20
	mov dl,46
	call gotoxy
	mov edx,offset Text3
	call writeString
	mov dh,21
	mov dl,46
	call gotoxy
	mov edx,offset Text4
	call writeString

	call ReadChar

    cmp al,'1'
    je StartGame

	cmp al,'2'
	je SetDificulty

	cmp al,'3'
	je ExitGame

    jmp MainMenu


SetDificulty:
call DificultySelector
jmp MainMenu


EXitGame:
exit

StartGame: 
call clrscr  
call Init
call Gameloop
jmp MainMenu

main ENDP

DificultySelector PROC
	
SettingLevel:
	call clrscr 
	call Printlogo

	mov dh,18
	mov dl,41
	call gotoxy
	mov edx,offset DificultyText1 
	call writeString

	mov dh,19
	mov dl,48
	call gotoxy
	mov edx,offset DificultyText2
	call writeString

	mov dh,20
	mov dl,48
	call gotoxy
	mov edx,offset DificultyText3
	call writeString

	mov dh,21
	mov dl,48
	call gotoxy
	mov edx,offset DificultyText4 
	call writeString

	mov dh,22
	mov dl,48
	call gotoxy
	mov edx,offset Text4 
	call writeString

	call readChar

	cmp al,'1'
	je SetEasy

	cmp al,'2'
	je SetMedium

	cmp al,'3'
	je SetHard

	jmp SettingLevel




SetEasy:
mov DificultyLevel,150
ret

SetMedium:
mov DificultyLevel,100
ret

SetHard:
mov DificultyLevel,40
ret
DificultySelector ENDP



GameLoop Proc

	call Instructions
	call DrawBorder

mainloop:
	call ShowScore
	call DrawSnake
	call Food
	call SpecialFood
	call obstacle
	mov eax,DificultyLevel
	call delay
	call MoveSnake
	call CheckFoodCollision
	call CheckFoodReCollision
	call CheckSnakeCollision
	call CheckSpecialFoodCollision
	call CheckObstacleCollision

    mov al,Game_Over
    cmp al,1
	jne mainloop

ret
GameLoop ENDP

Instructions PROC
	mov eax,15
	call setTextColor


	mov dh,1
	mov dl,52
	call gotoxy
	mov edx,offset Instuc_Head
	call WriteString

	mov dh,3
	mov dl,52
	call gotoxy
	mov edx,offset Instuc_Text1
	call WriteString

	mov dh,5
	mov dl,52
	call gotoxy

	mov eax,12
	call setTextColor
	mov al,'*'
	call writeChar
	mov eax,15
	call setTextColor
	mov edx,offset Instuc_Text2
	call WriteString

	mov dh,7
	mov dl,52
	call gotoxy

	mov eax,9
	call setTextColor
	mov al,'^'
	call writeChar
	mov eax,15
	call setTextColor
	mov edx,offset Instuc_Text3
	call WriteString


	mov dh,9
	mov dl,52
	call gotoxy
	mov edx,offset Instuc_Text4
	call WriteString
		
	mov dh,10
	mov dl,52
	call gotoxy
	mov edx,offset Instuc_Text5
	call WriteString


ret
Instructions ENDP


CheckFoodCollision PROC

	mov al,foodRow
	cmp al,SnakeRow
	jne No_Collision

	mov al, Foodcol
	cmp al, SnakeCol
	jne No_Collision

	add Snake_Length,1
	mov callSpecialFood,1
	mov  callObstacle,1
	mov dh,FoodRow
	mov dl,SnakeCol
	call gotoxy

	mov al,' '
	call writeChar

	call newFood


	No_Collision:
	ret

CheckFoodCollision ENDP

DrawSnake PROC

	mov eax,10
	call setTextColor

    ; Draw the head of the snake
    mov dh, SnakeRow        
    mov dl, SnakeCol       
    call gotoxy            
    mov al, data            
    call WriteChar       

    mov al,PrevRow
    cmp al,BodyRow[0]
    jne Continue

   mov al,PrevCol
   cmp al,BodyCol[0]
   je No_Body


               
Continue:
   
    mov esi, Snake_Length   
    sub esi, 1             
    mov ecx, 0            

BuildBody:
    cmp esi, 0              
    je SetFirstBody         
    mov ah, BodyRow[esi-1]  
    mov al, BodyCol[esi-1]  
    mov BodyRow[esi], ah   
    mov BodyCol[esi], al    
    dec esi                 
    inc ecx                 
    cmp ecx, Snake_Length   
    jl BuildBody            

SetFirstBody:
   
    mov ah, PrevRow         
    mov al, PrevCol         
    mov BodyRow[0], ah    
    mov BodyCol[0], al      

    ; Draw the body of the snake
    mov ecx, 0              
DrawBody:
    mov dh, BodyRow[ecx]    
    mov dl, BodyCol[ecx]   
    call gotoxy             
    mov al, '+'             
    call WriteChar          
    inc ecx                 
    cmp ecx, Snake_Length   
    jl DrawBody            

    
    mov dh,BodyRow[ecx-1]
    mov dl,BodyCol[ecx-1]
    call gotoxy
    mov al,' '
    call writeChar


No_Body:
	mov eax,12
	call setTextColor
    ret
DrawSnake ENDP

Food PROC
	
	mov eax,4
	call setTextColor

	mov dh,foodRow
	mov dl,foodCol
	call gotoxy
	mov al,'*'
	call WriteChar

	mov eax,15
	call setTextColor
	ret
Food ENDP

MoveSnake Proc

	call readKey
	
	mov keypressed,aL

	cmp al,'a'
	je Left


	cmp al,'w'
	je Up

	cmp al ,'s'
	je Down

	cmp al,'d'
	je Right

	cmp al,'p'
	je PauseGame

MovePrevDirection:

	mov al,PrevKey
	mov keypressed,al
	cmp al,'a'
	je Left


	cmp al,'w'
	je Up

	cmp al ,'s'
	je Down

	cmp al,'d'
	je Right



PauseGame:
	mov dh,7
	mov dl,2
	call gotoxy
	mov edx,offset PauseText
	call writeString
	call readChar
	cmp al,'p'
	jne PauseGame
	call clrscr
	call Instructions
	call DrawBorder
ret

Left:
    mov al,PrevKey
    cmp al,'d'
    je MovePrevDirection
    mov al,keypressed
    mov prevKey,al

   mov al,SnakeCol
    mov PrevCol,al
    sub snakeCol,1
    mov al,SnakeRow
    mov PrevRow,al

    ret

Right:
    mov al,PrevKey
    cmp al,'a'
    je MovePrevDirection
    mov al,keypressed
    mov prevKey,al

    mov al,SnakeCol
    mov PrevCol,al
    add snakecol,1
    mov al,SnakeRow
    mov PrevRow,al
    ret

Up:
    mov al,PrevKey
    cmp al,'s'
    je MovePrevDirection
    mov al,keypressed
    mov prevKey,al

	mov al,SnakeRow
	mov PrevRow,al
	sub snakeRow,1
	mov al,SnakeCol
	mov PrevCol,al
    ret

Down:
    mov al,PrevKey
    cmp al,'w'
    je MovePrevDirection
    mov al,keypressed
    mov prevKey,al

	mov al,SnakeRow
	mov PrevRow,al
	add snakeRow,1
	mov al,SnakeCol
	mov PrevCol,al
    ret
    
	NoAction:
	ret

MoveSnake ENDP


SpecialFood PROC

   SpawnSpecialFood:

	cmp Snake_Length,9
	jle No_Spawn

    mov eax, Snake_Length   

    ; Set the divisor (e.g., 5)
    mov ebx, 10           
	 mov edx,0
    div ebx                 
  
    cmp edx, 1            
    jne No_Spawn          

	cmp callSpecialFood,1
	jne No_spawn
   
    call Randomize           
    mov eax, 48              
    call RandomRange
    mov dl, al             

    mov eax, 19            
    call RandomRange
    mov dh, al              

	cmp dh,0
	je SpawnSpecialFood

	cmp dl,0
	je SpawnSpecialFood

	cmp dh,FoodRow
	je SpawnSpecialFood

	cmp dl,FoodCol
	je SpawnSpecialFood

	mov ecx,0
	mov eax,0
	.while(ecx<Snake_Length)
	cmp dh,BodyRow[ecx]
	jne noCollision

	cmp dl,BodyCol[ecx]
	jne noCollision

	mov eax,1

	noCollision:
	inc ecx
	.endw

	cmp eax,1
	je SpawnSpecialFood

	mov ah,SpecialFoodRow
	mov al,SpecialFoodCol

	mov ecx,0
	.while ecx< TotalObstacle
   
   cmp al,ObstacleCol[ecx]
   jne Next

   cmp ah,ObstacleRow[ecx]
   jne Next

   jmp SpawnSpecialFood

   Next:
   inc ecx
	.endw


	mov SpecialFoodRow,dh
	mov SpecialFoodCol,dl

	mov eax,9
	call setTextColor
    mov al, '^'            
    call gotoxy             
    call writeChar        
	mov eax,15
	call setTextColor

	mov callSpecialFood,0
	No_Spawn:
    ret                      
SpecialFood ENDP

CheckSpecialFoodCollision PROC
	mov dh,SpecialFoodRow
	mov dl,SpecialFoodCol

	cmp dh,SnakeRow
	jne NoCollision

	cmp dl,SnakeCol
	jne NoCollision

	add Snake_Length,3

	NoCollision:
	ret
CheckSpecialFoodCollision ENDP

Obstacle PROC
	cmp Snake_Length,5
	jl No_Spawn
    mov eax, Snake_Length   

    ; Set the divisor 
    mov ebx, 5           
	 mov edx,0
    div ebx                 
  
    cmp edx, 1            
    jne No_Spawn

	cmp callObstacle,1
	jne No_Spawn




	CreateObstacle:
	call Randomize

	;Rows
	mov eax,19
	call RandomRange
	cmp al,0
	je CreateObstacle
	mov dh,al

	;col
	mov eax,49
	call RandomRange
	cmp al,0
	je CreateObstacle
	mov dl,al

	mov ecx,0
	.while(ecx<Snake_Length)
	cmp dh,BodyRow[ecx]
	jne Next

	cmp dl,BodyCol[ecx]
	jne Next

	mov eax,1

	Next:
	inc ecx
	.endw
	
	cmp eax,1
	je CreateObstacle

	cmp dh,FoodRow
	jne Continue

	cmp dl,FoodCol
	je CreateObstacle

	Continue:
	mov eax,TotalObstacle
	mov ObstacleRow[eax],dh
	mov ObstacleCol[eax],dl

	inc TotalObstacle

	mov al,'#'
	mov ecx,0
	.while(ecx<TotalObstacle)
	mov dh,ObstacleRow[ecx]
	mov dl,ObstacleCol[ecx]
	call gotoxy
	call writeChar

	inc ecx
	.endw

	mov callObstacle,0
No_Spawn:
ret
Obstacle ENDP

CheckObstacleCollision PROC

	mov dh,SnakeRow
	mov dl,Snakecol

	mov ecx,0
	.while(ecx<totalObstacle)
	cmp dh,ObstacleRow[ecx]
	jne NoCollision

	cmp dl,ObstacleCol[ecx]
	jne NoCollision

	call GameOver

	NoCollision:
	inc ecx
	.endw
ret
CheckObstacleCollision ENDP

ShowScore PROC

	mov dl ,5 ;col
	mov dh,22	;Row

	call gotoxy
	mov edx,offset ScoreText
	call WriteString

	mov eax,Snake_Length
    dec eax
	mov Score,eax
	call writeDec

	mov eax,HighestScore
	cmp eax,Score
	jl ChangeHighScore

	jmp Continue

	ChangeHighScore:
	mov eax,Score
	mov HighestScore,eax

	Continue:
	mov dl ,30 ;col
	mov dh,22	;Row
	mov eax,HighestScore
	call gotoxy
	mov edx,offset HighestScoreText
	call WriteString

	call writeDec


	ret
ShowScore ENDp

CheckFoodReCollision PROC

mov ecx,0
    .while(ecx<Snake_Length)
    mov al,BodyRow[ecx]
    cmp al,FoodRow
    jne NextSegment

    mov al,BodyCol[ecx]
    cmp al,FoodCol
    jne NextSegment

    call newfood

    NextSegment:
    inc ecx
    .endw

    cmp FoodRow,0
    je Recall

    cmp FoodRow,20
     je Recall

    cmp Foodcol,0
     je Recall
    cmp Foodcol,49
    je Recall

	mov ah,FoodRow
	mov al,FoodCol

	mov ecx,0
	.while ecx< TotalObstacle
   
   cmp al,ObstacleCol[ecx]
   jne Next

   cmp ah,ObstacleRow[ecx]
   jne Next

   jmp Recall

   Next:
   inc ecx
	.endw
Do_Nothing:
 ret

 Recall:
 call newFood

 CheckFoodReCollision ENDP

NewFood PROC
 
	call Randomize

	mov eax,19

	call RandomRange
	mov FoodRow,al

	mov eax,49
	call RandomRange
	mov FoodCol,al

	call checkFoodReCollision
	 ret
 NewFood ENDP


 DrawBorder PROC
	 ;Upper Part

	 mov ecx,0
	mov al,0
	 mov temp,al
 .while(ecx<50)
    mov dh,0
    mov dl,temp
    call gotoxy
    mov al,'#'
    call writechar

    add temp,1
    inc ecx
    .endw

;lowerPart
	mov ecx,0
	 mov al,0
	 mov temp,al
 .while(ecx<50)
    mov dh,20
    mov dl,temp
    call gotoxy
    mov al,'#'
    call writechar

    add temp,1
    inc ecx
    .endw

;LeftSide
	mov ecx,0
	 mov al,0
	 mov temp,al
.while(ecx<20)
    mov dh,temp
    mov dl,0
    call gotoxy
    mov al,'#'
    call writechar

    add temp,1
    inc ecx
    .endw


	;RightSide
	mov ecx,0
	 mov al,0
	 mov temp,al
 .while(ecx<20)
    mov dh,temp
    mov dl,49
    call gotoxy
    mov al,'#'
    call writechar

    add temp,1
    inc ecx
    .endw

	 ret
 DrawBorder ENDP

 CheckSnakeCollision Proc
	mov ecx,0
	 mov esi,Snake_Length
	 dec esi
 .while(ecx<esi)

	mov al,SnakeRow
	 cmp al,BodyRow[ecx]
	 jne NoCollision

	 mov al,SnakeCol
	 cmp al,BodyCol[ecx]
	 jne NoCollision

	 call GameOver

	 NoCollision:
	 inc ecx
	 .endw

	 mov al,SnakeRow
	 cmp al,0
	 je Collision

	 mov al,SnakeRow
	 cmp al,20
	 je collision

	 mov al,SnakeCol
	 cmp al,49
	 je collision

	 mov al,SnakeCol
	 cmp al,0
	 jne No_Collision
	
	 Collision:
	 call GameOver
	
	No_Collision:
 ret
 CheckSnakeCollision ENDP


 GameOver PROC
	 mov al,1
	 mov Game_Over ,al
	 mov dh,7
	 mov dl,2
	 call gotoxy
	 mov edx,offset GameOverText
	 call WriteString

	 REDo:
	 call readChar
	 cmp al,27
	 jne REDo
	
	 ret
 GameOver ENDP

 PrintLogo PROC
	call LogoBorder
	call Print_S
	call Print_N
	call Print_A
	call Print_K
	call Print_E
	call Print_Dot
	call Print_I
	call Print_O

	ret
PrintLogo ENDP

Print_S PROC

;Printting S
	mov al,'S'
	mov dh,5
	mov dl,20
	call gotoxy
	call WriteChar

	add dh,1
	call gotoxy
	call WriteChar

	add dh,1
	call gotoxy
	call WriteChar

	add dh,1
	call gotoxy
	call WriteChar

	add dh,1
	call gotoxy
	call WriteChar


	add dh,1
	add dl,1
	call gotoxy
	call WriteChar

	add dl,1
	call gotoxy
	call WriteChar

	add dl,1
	call gotoxy
	call WriteChar

	add dl,1
	call gotoxy
	call WriteChar

	add dl,1
	call gotoxy
	call WriteChar

	mov dh,5
	call gotoxy
	call WriteChar
	sub dl,1
	call gotoxy
	call WriteChar
	sub dl,1
	call gotoxy
	call WriteChar
	sub dl,1
	call gotoxy
	call WriteChar
	sub dl,1
	call gotoxy
	call WriteChar


	mov dh,11
	add dl,5
	call gotoxy
	call WriteChar

	inc dh
	call gotoxy
	call WriteChar
	inc dh
	call gotoxy
	call WriteChar
	inc dh
	call gotoxy
	call WriteChar
	inc dh
	call gotoxy
	call WriteChar
	
	dec dl
	call gotoxy
	call WriteChar

	dec dl
	call gotoxy
	call WriteChar

	dec dl
	call gotoxy
	call WriteChar

	dec dl
	call gotoxy
	call WriteChar

	dec dl
	call gotoxy
	call WriteChar
	
	ret
Print_S ENDP

Print_N PROC
mov al,'N'

mov ecx,0
mov dh,5
mov dl, 29

.while(ecx<11)
call gotoxy 
call WriteChar

inc dh
inc ecx
.endw
	
	mov dh,6
	mov dl,30
	call gotoxy 
	call WriteChar

	inc dh
	call gotoxy 
	call WriteChar

	inc dl
	inc dh
	call gotoxy 
	call WriteChar

	inc dh
	call gotoxy 
	call WriteChar

	inc dl
	inc dh
	call gotoxy 
	call WriteChar

	inc dh
	call gotoxy 
	call WriteChar

	inc dl
	inc dh
	call gotoxy 
	call WriteChar

	inc dh
	call gotoxy 
	call WriteChar

	inc dl
	inc dh
	call gotoxy 
	call WriteChar

	inc dh
	inc dl
	mov ecx,0

	.while( ecx<11)
	call gotoxy 
	call WriteChar
	dec dh

	inc ecx
	.endw

	ret
Print_N ENDP

Print_A PROC


mov al,'A'

mov dh,6
mov dl,38
mov ecx,0
.while(ecx<10)
call gotoxy 
	call WriteChar

inc dh
inc ecx
.endw

mov dh,5
mov dl,39
mov ecx,0
.while(ecx<6)
call gotoxy 
	call WriteChar

inc dl
inc ecx
.endw


mov dh,10
mov dl,39
mov ecx,0
.while(ecx<6)
call gotoxy 
	call WriteChar

inc dl
inc ecx
.endw


mov dh,6
mov ecx,0
.while(ecx<10)
call gotoxy 
	call WriteChar

inc dh
inc ecx
.endw

ret
Print_A ENDP

Print_K PROC


mov al,'K'

mov dh,5
mov dl,48
mov ecx,0
.while(ecx<11)
call gotoxy
call writeChar

inc dh
inc ecx
.endw

mov dl,49

mov dh,9
call gotoxy
call writeChar

inc dh
call gotoxy
call writeChar

inc dh
call gotoxy
call writeChar

inc dl

mov dh,7
call gotoxy
call writeChar

mov dh,8
call gotoxy
call writeChar

mov dh,12
call gotoxy
call writeChar

mov dh,13
call gotoxy
call writeChar

inc dl

mov dh,6
call gotoxy
call writeChar

mov dh,14
call gotoxy
call writeChar

inc dl
mov dh,5
call gotoxy
call writeChar

mov dh,15
call gotoxy
call writeChar

ret
Print_K ENDP


Print_E PROC

mov al,'E'

mov dh,5
mov dl,55

mov ecx,0
.while(ecx<11)

call gotoxy
call writeChar

inc dh
inc ecx
.endw

mov dh,5
mov dl,55
mov ecx,0
.while(ecx<6)
call gotoxy
call writeChar
inc dl
inc ecx
.endw

mov dh,10
mov dl,55
mov ecx,0
.while(ecx<6)
call gotoxy
call writeChar
inc dl
inc ecx
.endw


mov dh,15
mov dl,55
mov ecx,0
.while(ecx<6)
call gotoxy
call writeChar
inc dl
inc ecx
.endw

ret
Print_E ENDP

Print_Dot PROC

mov al,'0'
mov dh,13
mov dl,63
call gotoxy
call writeChar

mov dh,14
call gotoxy
call writeChar

mov dh,15
call gotoxy
call writeChar


mov dh,13
mov dl,64
call gotoxy
call writeChar

mov dh,13
mov dl,65
call gotoxy
call writeChar

mov dh,14
mov dl,64
call gotoxy
call writeChar

mov dh,14
mov dl,65
call gotoxy
call writeChar

mov dh,15
mov dl,64
call gotoxy
call writeChar

mov dh,15
mov dl,65
call gotoxy
call writeChar

ret
Print_Dot ENDP

;68
Print_I PROC

mov al,'I'

mov dh,5
mov dl,68
mov ecx,0
.while(ecx<7)
call gotoxy
call WriteChar
inc dl
inc ecx
.endw

mov dl,71
mov ecx,0
.while(ecx<11)
call gotoxy
call WriteChar
inc dh
inc ecx
.endw

mov dh,15
mov dl,68
mov ecx,0
.while(ecx<7)
call gotoxy
call WriteChar
inc dl
inc ecx
.endw

ret
Print_I ENDP

;77
Print_O PROC
mov al,'O'
mov dh,5
mov dl,78
mov ecx,0

.while(ecx<7)
call gotoxy
call WriteChar
inc dl
inc ecx
.endw

mov dl,77
mov dh,6
mov ecx,0
.while(ecx<9)
call gotoxy
call WriteChar
inc dh
inc ecx
.endw


mov dh,15
mov dl,78
mov ecx,0

.while(ecx<7)
call gotoxy
call WriteChar
inc dl
inc ecx
.endw

mov dl,85
mov dh,6
mov ecx,0
.while(ecx<9)
call gotoxy
call WriteChar
inc dh
inc ecx
.endw

ret
Print_O ENDP

LogoBorder PROC

;top border

mov al,'-'

mov dh,4
mov dl,20
mov ecx,0
.while(ecx<66)
call gotoxy
call WriteChar
inc dl
inc ecx
.endw

;left border

mov  al,'|'
mov dh,5
mov dl,19
mov ecx,0
.while(ecx<11)
call gotoxy
call WriteChar
inc dh
inc ecx
.endw


;right border

mov dh,5
mov dl,86
mov ecx,0
.while(ecx<11)
call gotoxy
call WriteChar
inc dh
inc ecx
.endw

;bottom border

mov al,'-'

mov dh,16
mov dl,20
mov ecx,0
.while(ecx<66)
call gotoxy
call WriteChar
inc dl
inc ecx
.endw

ret
LogoBorder ENDP
END main