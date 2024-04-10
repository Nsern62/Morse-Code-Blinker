#include <xc.h>
    
.data
string: .asciz "EVERY"
stackLength = 0x10
stackArea: .space stackLength
        
/***************************************************************
* Port address declarations.                                   *
***************************************************************/
PORT_REGS =  0x41008000
DIR = 0x00
DIRCLR = 0x04
DIRSET = 0x08
OUT = 0x10
IN = 0x20
OUTCLR = 0x14
OUTSET = 0x18
IN = 0x20
PINCFG = 0x40
        
dotDelayTime = 0x2DC6C00/4
dashDelayTime = 0x2DC6C00/2

.text
.align
/*********************************************************
* Subroutine to turn the LED on and off. 
* If R0 contains a 0 the LED is turned off.
* If R0 <> 1 the led is turned on. 
 *********************************************************/        
 LED:
   cmp    R0,#0
   beq    LED1
           
   mov  R0, #0x01   // R0 <= #0x4000
   lsl  R0, #14

   mov R2, #OUTSET  // Set individual bit register.
   str R0, [R1,R2]
   bal LEDDone
 
LED1:          
   mov  R0, #0x01   // R0 <= #0x4000
   lsl  R0, #14
   mov R2, #OUTCLR 
   str R0, [R1,R2]  // Clear the individual bit register.

LEDDone:           
   mov PC,LR
 
/*************************************************************
* This subroutine returns the value on the pin connected to
* the push button.
* A 1 in R0 means the push button is up.
* A 0 in R0 means that the push button is down.
*************************************************************/
getPushButton:
   mov R2, #IN      // Input register offest.
   ldr R0, [R1,R2]  // Get bit value.
   
   mov R2, #0       // Create a bit mask: 0x0FFFFFFF.
   sub R2,R2,#1
   lsr R2, R2, #4       
   
   and R0, R2       // AND the mask with R0.
   mov PC, LR       // Return.
   
  
// *****************************************************************************
// *****************************************************************************
// Section: Main Entry Point
// *****************************************************************************
// *****************************************************************************  
   
/********************************************************************
R0 Value to be written / read.
R1 Base pointer value.
R2 Offset pointer.
    R1 + R2 == the effective address.
********************************************************************/    
.global asmFunction
asmFunction:  

/* Initialization section                                */
    mov R8, LR // Save the link register.

   ldr  R1, = #PORT_REGS
  
   ldr	R0, = #0x00     // Set the pin configuration for the LED pin.
   mov R2, #PINCFG
   add R2, R2, #14
   str R0, [R1,R2]
   
   ldr	R0, = #0x06     // Set the pin configuration for the Push button pin.
   mov R2, #PINCFG
   add R2, R2, #15
   str R0, [R1,R2]
           
   mov  R0, #0x01   // R0 <= #0x4000
   lsl  R0, #14                    
   mov R2, #DIRSET
   str R0, [R1,R2]
   
   mov  R0, #0x01   // R0 <= #0x8000
   lsl  R0, #15  
   mov R2, #OUTSET
   str R0, [R1,R2]  // Drive the pullup.
 
/* Start of main working loop. */    
// Your code goes here.
   
ldrb r5, =#string //Gets the string
mov r6, #0 //Establishes a bumber
   
//Sets up the stack
ldr r3, =stackArea
   add r3,r3,#stackLength 
   mov sp,r3

getMorse:
//Dots are 1, #49, and dashes are 2, #50,. The order of them in the stack is the order of dots and dashes
ldrb r7,[r5,r6] //Gets the value in the string
letterA: //Morse for letter A, Dot-Dash
    cmp r7,#65 //Compares to letter A
    bne letterB //If not A, then goes to B.
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    b checks
letterB:
    cmp r7,#66
    bne letterC
    mov r3,#49
    push {r3}
    push {r3}
    push {r3}
    mov r3,#50
    push {r3}
    b checks 
letterC:
    cmp r7,#67
    bne letterD
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    b checks
letterD:
    cmp r7,#68
    bne letterE
    mov r3, #49
    push {r3}
    push {r3}
    mov r3, #50
    push {r3}
    b checks   
letterE:
    cmp r7,#69
    bne letterF
    mov r3, #49
    push {r3}
    b checks
letterF:
    cmp r7,#70
    bne letterG
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    push {r3}
    b checks
letterG: 
    cmp r7,#71
    bne letterH
    mov r3,#49
    push {r3}
    mov r3, #50
    push {r3}
    push {r3}
    b checks
letterH:
    cmp r7,#72
    bne letterI
    mov r3, #49
    push {r3}
    push {r3}
    push {r3}
    push {r3}
    b checks   
letterI:
    cmp r7,#73
    bne letterJ
    mov r3, #49 
    push {r3}
    push {r3}
    b checks
letterJ:
    cmp r7,#74
    bne letterK
    mov r3, #50
    push {r3}
    push {r3}
    push {r3}
    mov r3, #49
    push {r3}
    b checks  
letterK:
    cmp r7,#75
    bne letterL
    mov r3,#50
    push {r3}
    mov r3, #49
    push {r3}
    mov r3,#50
    push {r3}
    b checks
letterL:
    cmp r7,#76
    bne letterM
    mov r3, #49
    push {r3}
    push {r3}
    mov r3, #50
    push {r3}
    mov r3,#49
    push {r3}
    b checks
letterM:
    cmp r7,#77
    bne letterN
    mov r3, #50
    push {r3}
    push {r3}
    b checks
letterN:
    cmp r7,#78
    bne letterO
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    b checks
letterO:
    cmp r7,#79
    bne letterP
    mov r3, #50
    push {r3}
    push {r3}
    push {r3}
    b checks
letterP:
    cmp r7,#80
    bne letterQ
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    push {r3}
    mov r3, #49
    push {r3}
    b checks  
letterQ:
    cmp r7,#81
    bne letterR
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    push {r3}
    b checks    
letterR:
    cmp r7,#82
    bne letterS
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    b checks
letterS:
    cmp r7,#83
    bne letterT
    mov r3, #49
    push {r3}
    push {r3}
    push {r3}
    b checks 
letterT: 
    cmp r7,#84
    bne letterU
    mov r3, #50
    push {r3}
    b checks
letterU:
    cmp r7,#85
    bne letterV
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    push {r3}
    b checks 
letterV:
    cmp r7,#86
    bne letterW
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    push {r3}
    push {r3}
    b checks
letterW:
    cmp r7,#87
    bne letterX
    mov r3, #50
    push {r3}
    push {r3}
    mov r3, #49
    push {r3}
    b checks
letterX:
    cmp r7,#88
    bne letterY
    mov r3, #50
    push {r3}
    mov r3, #49
    push {r3}
    push {r3}
    mov r3, #50
    push {r3}
    b checks
letterY:
    cmp r7,#89
    bne letterZ
    mov r3, #50
    push {r3}
    push {r3}
    mov r3, #49
    push {r3}
    mov r3, #50
    push {r3}
    b checks
letterZ:
    cmp r4,#90
    bne endOfString
    mov r3, #49
    push {r3}
    push {r3}
    mov r3, #50
    push {r3}
    push {r3}
    b checks

endOfString: //Loops the light off so you know the morse is done
mov r0,#1 //Begins the process to turn on the LED by setting r0 to 1
    bl LED //Turns on the LED using the value in r0
b endOfString
    
checks: //Will check if it is dash or dot
    checkDots: //Checks for dots
	pop {r3} //pops top of stack
	cmp r3,#49 //Checks for 1
	beq dots //Goes to light blink for dots
    checkDash: //Checks for dashes
	cmp r3,#50 //Checks for 2
	beq dashes //Goes to light blink for dashes
    moreMorse: //Updates the bumber
	add r6,#1
	b getMorse
 
dots:
    mov r0,#1 //Begins the process to turn on the LED by setting r0 to 1
    bl LED //Turns on the LED using the value in r0
    bl dotDelay //Starts the delay
    mov r0,#0 //Begins the process to turn off the LED by setting r0 to 0
    bl LED //Turns off the LED using the value in r0
    bl dotDelay //Starts the delay
    b checks
    
dashes:
    mov r0,#1
    bl LED
    bl dashDelay
    mov r0,#0
    bl LED
    bl dashDelay
    b checks //Goes to the process where it checks if the button is pressed
  
dotDelay: //Start of delay process
    ldr r4,=$dotDelayTime //Sets a counter to the dot delay time
    dotLoop: //Sets a delay loop
    sub r4, r4, #1 //Counts down
    bne dotLoop //Loops until a second has passed
    mov pc,lr //Return to calling routine
    
dashDelay:
    ldr r4,=$dashDelayTime //Sets a counter to the dash delay time
    dashLoop: //Sets a delay loop
    sub r4, r4, #1 //Counts down
    bne dashLoop //Loops until a second has passed
    
mov pc,lr //Return to calling routine
    
mov pc, R8   // Return to calling routine.
    
.end asmFunction
   
/**********************************************************************/   
.end
           
