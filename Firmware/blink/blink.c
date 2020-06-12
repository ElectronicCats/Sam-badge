/* The "Hello world!" of microcontrollers. Blink LED on/off */
#include <stdint.h>
#include "stm8.h"


/* Build in LED is in pin B5 (STM8S103 board) or D3 (STM8S003F3 board) */

/*
LEDs pinout 

R1 = PA1
G1 = PA2
B1 = PD6

R2 = PC3
G2 = PC4
B2 = PC5

R3 = PD3
G3 = PD2
B3 = PC7

R4 = PC6
G4 = PD5
B4 = PD4
*/


#define LED_PORT    PA
#define LED_PIN     PIN2


/* Simple busy loop delay */
void delay(unsigned long count) {
    while (count--)
        nop();
}

int main(void)
{
    /* Set clock to full speed (16 Mhz) */
    CLK_CKDIVR = 4;

    /* GPIO setup All outputs*/
    PA_DDR = 0xF7; //PA3 not an output
    PC_DDR = 0xFF;
    PD_DDR = 0xFD; //PD1 not an output

    PA_CR1 = 0xFF;
    PC_CR1 = 0xFF;
    PD_CR1 = 0xFF;

    PA_ODR = 0x00;
    PC_ODR = 0x00;
    PD_ODR = 0x00;
    // Set pin data direction as output
    // PORT(LED_PORT, DDR)  |= LED_PIN; // i.e. PB_DDR |= (1 << 5);
    // Set pin as "Push-pull"
    // PORT(LED_PORT, CR1)  |= LED_PIN; // i.e. PB_CR1 |= (1 << 5);

	while(1) {
        // LED on
        
        
        //PORT(LED_PORT, ODR) |= LED_PIN; // PB_ODR |= (1 << 5);
        PA_ODR = 0xFF;
        PD_ODR = 0x00;
        PC_ODR = 0xAA;
        delay(10000L);
        // LED off
        //PORT(LED_PORT, ODR) &= ~LED_PIN; // PB_ODR &= ~(1 << 5);
        PA_ODR = 0x00;
        PD_ODR = 0x8A;
        PC_ODR = 0x55;
        delay(10000L);

        PA_ODR = 0xAA;
        PD_ODR = 0x56;
        PC_ODR = 0xAA;
        delay(10000L);

        PA_ODR = 0x55;
        PD_ODR = 0x00 ;
        PC_ODR = 0x5A;
        delay(10000L);
        
    }
}
