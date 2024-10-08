/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/27/2022
Author  : Herlambang
Company : Anugrah
Comments: 


Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

/*Library Header*/
#include <mega16a.h>
#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

/*Inisialisasi Parameter*/
#define ADC_VREF_TYPE 0x40
#define Returning 100
#define ACInput 232
#define DCRef 4.96
#define MaxSpeed 200
#define ditekan 0

#define ADC_SCALE 1023.0
#define VREF 5.0
#define DEFAULT_FREQUENCY 50
int zero = 512;
float sensitivity = 0.066;
    
/*Inisialisasi Pinout*/
#define ZeroCross PINB.2
#define startt PINC.3

/*Inisialisasi Variabel */
char temp;
volatile unsigned long millis_value; /*Inisialisasi untuk counter tik untuk millis*/
char keyupdate = '0', lastkeyupdate = '0';/*Inisialisasi variabel keypad*/
bool tekan = false;
float Kp = 0.0, Ki = 0.0;
int Arus = 0;  /*Inisialisasi PI Parameters*/
unsigned char countpwm = 0;

/*fungsi untuk cek interrupt zero crossing*/
void Cek_Interrupt() {
    char i;
         
    /*Filter untuk memastikan bukan noise*/
    for (temp = 0;temp < 5;) { /*pengecekan 5x*/
            if(!ZeroCross)
            { temp++; }
            else { temp = Returning; }          
    }
   
    if(temp != Returning) {
        /*Proses ketika zero crossing, PWM dikeluarkan*/
        OCR2 = countpwm; /*PWM diaktifkan*/
        for(i=0x2F;i>0;i--); /*PWM dijeda*/
        OCR2 = 0;/*PWM di nol kan*/
      }
}

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

/*Interrupt untuk tik millis*/
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
// Place your code here
    millis_value++;
}

/*Interrupt untuk cek zero crossing*/
interrupt [EXT_INT2] void ext_int2_isr(void)
{
// Place your code here
//    Cek_Interrupt();
}

// Declare your global variables here
/*Inisialisasi Variabel millis*/
volatile unsigned long lastmillis_value;

/*Fungsi untuk variabel millis*/
unsigned long millis() {
    unsigned long m;
    #asm("cli")
    m = millis_value;
    #asm("sei")
    return m;
}

/*Inisialisasi Variabel Keypad*/
unsigned long lastDebounceTime = 0;
#define debounceDelay  100
#define aktif    0
#define nonaktif 1
/*Fungsi cek penekanan keypad*/
char keypad() {    
    char out = '\0';

    if((millis() - lastDebounceTime) > debounceDelay) { // Jika ada penekanan keypad
        lastDebounceTime = millis();

        PORTA.7=aktif;
        PORTA.6=nonaktif;
        PORTA.5=nonaktif;
        PORTA.4=nonaktif;
        delay_ms(20);
        if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '1'; }
        if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '2'; }
        if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '3'; }
            
        PORTA.7=nonaktif;
        PORTA.6=aktif;
        PORTA.5=nonaktif;
        PORTA.4=nonaktif;
        delay_ms(20);
        if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '4'; }
        if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '5'; }
        if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '6'; }
                 
        PORTA.7=nonaktif;
        PORTA.6=nonaktif;
        PORTA.5=aktif;
        PORTA.4=nonaktif;
        delay_ms(20);
        if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '7'; }
        if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '8'; }
        if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '9'; }
                 
        PORTA.7=nonaktif;
        PORTA.6=nonaktif;
        PORTA.5=nonaktif;
        PORTA.4=aktif;
        delay_ms(20);
        if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '*'; }
        if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '0'; }
        if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '#'; }
                 
        PORTA.6=nonaktif;
        PORTA.5=nonaktif;
        PORTA.4=nonaktif;
        PORTA.7=nonaktif;
        delay_ms(20);

//        tekan = true;
        return out;
     }
}

/*Fungsi untuk menghitung watt*/
float CalcWatt(float input) {
    float watt;
    watt = ACInput * input;
    return watt;   
}

int calibrate() {
	int acc = 0;           
    int i = 0;
	for (i = 0; i < 10; i++) {
		acc += read_adc(0);
	}
	zero = acc / 10;
	return zero;
}

/*Inisialisasi Variabel Sensor arus*/
int acscount = 0;
#define maxacscount 20

/*Fungsi untuk membaca sensor arus ACS*/
float readACS() {
    float adc_volt;
//    float amp = 0;
//    float temps;

	int acc = 0;
    int i = 0;
	for (i = 0; i < 10; i++) {
		acc += read_adc(0) - zero;
	}
	adc_volt = (float)acc / 10.0 / ADC_SCALE * VREF / sensitivity;

//    for (acscount = 0; acscount < maxacscount; acscount++) { amp += read_adc(0); } // Sampling pembacaan sensor sebanyak 20x
//    amp /= maxacscount;
//    temps = amp *(DCRef/1023);
//    adc_volt = fabs(temps-(DCRef/2))/0.066; //0.066 di dapat dari data sheet
        
    return adc_volt;
}

/*Inisialisasi Variabel Sensor arus*/
float arus1, vout1;
int adc1, count, dataMin, dataMax;

/*Fungsi membaca sensor arus ACS dengan nilai tertinggi saja*/
unsigned char readACSMAX() {
    for ( count = 0; count <= 1000; count++) { // sampling pembacaan sensor arus sebanyak 1000x
        adc1 = read_adc(0);
        if ( adc1 >= dataMax ) dataMax = adc1;
        if ( adc1 <= dataMin ) dataMin = adc1;
        delay_ms(1);
    }
    vout1 = dataMax*(DCRef/1023);
    arus1 = fabs(vout1-(DCRef/2))/0.066;

    return arus1;
}

int prev_res=0, prev_err_1=0, prev_err_2=0, total_err=0;  // PI Control Variables
/*Fungsi untuk perhitungan PI*/
void PIControl(unsigned int sensor_val) {
//    unsigned char data[16];
    int motor_res,err_func;
    float KonstP;
    long KonstI;
    long cont_res;
    err_func = Arus - sensor_val; //  Get the Error Function
    KonstP = Kp * (err_func); //Kp;
    KonstI = Ki * (err_func + total_err); //Ki;
    // Menghitung output dari nilai KP dan KI      
    
    cont_res=(float)(prev_res + KonstP + KonstI);

    // Membatasi output kecepatan motor
    motor_res=(int)cont_res;
    if (motor_res > MaxSpeed) motor_res = MaxSpeed;
    if (motor_res < 0) motor_res = 0;


    // Menyimpan nilai error function terbaru
    prev_res=motor_res;
    prev_err_2=prev_err_1;
    prev_err_1=err_func;
    total_err+=err_func;
    countpwm-=motor_res;

//    lcd_gotoxy(0,0); lcd_puts("         ");
//    lcd_gotoxy(0,0); sprintf(data, "R: %d", motor_res); lcd_puts(data);
//    lcd_gotoxy(0,1); lcd_puts("         ");
//    lcd_gotoxy(0,1); sprintf(data, "A: %d", sensor_val); lcd_puts(data);
}

/*Inisialisasi Variabel untuk update nilai parameter*/
int buttonstate = 0;
int lastbuttonstate = 0;
int pos = 0;
bool pressed = false;
bool blink = false;
bool koma = false;
char savedkey = '0';
unsigned char data[16];
volatile unsigned long millis_cek;
char Kp_Temp[];
char Ki_Temp[];
char Arus_Temp[5];
/*Fungsi untuk set parameter*/
void SetParameter() {
/*Update nilai arus*/
    lcd_clear();
    memset(Arus_Temp, 0, sizeof(Arus_Temp));
    lcd_gotoxy(0,0); lcd_putsf("SET I  :      mA");
    lcd_gotoxy(0,1); lcd_putsf("*:,"); lcd_gotoxy(11,1); lcd_putsf("#:Clr");
    lastkeyupdate = '\0';
    keyupdate = '\0';
    pos = 9;
    // looping set nilai arus motor
    do {
        if(millis() - millis_cek >= 50) {   
            millis_cek = millis();
            keyupdate = keypad();        
            if(tekan == true) { // Jika ada penekanan keypad
                if(pos < 13) {
                    if((keyupdate >= 48) && (keyupdate <= 57)) {
                        lastkeyupdate = keyupdate;
                        savedkey = keyupdate;
                        lcd_gotoxy(pos,0); lcd_putchar(savedkey);
                        Arus_Temp[pos-9] = savedkey;
//                        if(keyupdate == '*') { lcd_gotoxy(pos,0); lcd_putchar(','); }
                        pos++;
                    }
                }
                if(keyupdate == '#') {
                    memset(Arus_Temp, 0, sizeof(Arus_Temp));
                    lcd_gotoxy(9,0); lcd_puts("     mA");
                    pos = 9;
                }
                tekan = false;           
            }
        }
            
        if(millis() - lastmillis_value >= 500) { // Untuk membuat kursor '_' berkedip
            lastmillis_value = millis();
            if(pos < 13) {
                if(blink) { lcd_gotoxy(pos,0); lcd_putchar(' '); }
                else { lcd_gotoxy(pos,0); lcd_putchar('_'); }
                blink = !blink;
            }            
        }
                               
        buttonstate = startt;
        if (buttonstate != lastbuttonstate) { // Jika yang ditekan tombol start, maka keluar dari loop
            if (startt == ditekan) { pressed = true; }
        } 
        lastbuttonstate = buttonstate;
    } while(pressed == false);
    pressed = false;
    Arus = atoi(Arus_Temp);
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("ARUS = ");
    lcd_gotoxy(8,0); sprintf(data, "%d mA", Arus); lcd_puts(data);
    memset(Arus_Temp, 0, sizeof(Arus_Temp));
    delay_ms(2000);

/*Update nilai Kp*/
    koma = false;
    memset(Kp_Temp, 0, sizeof(Kp_Temp));
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("SET Kp : ");
    lcd_gotoxy(0,1); lcd_putsf("*:,"); lcd_gotoxy(11,1); lcd_putsf("#:Clr");
    lastkeyupdate = '\0';
    keyupdate = '\0';
    savedkey = '0'; 
    pos = 9;
// looping set nilai Kp
    do {        
        if(millis() - millis_cek >= 50) {   
            millis_cek = millis();
            keyupdate = keypad();        
            if(tekan == true) { // Jika ada penekanan keypad
                if(pos < 13) {
                    if((keyupdate >= 48) && (keyupdate <= 57)) {
                        lastkeyupdate = keyupdate;
                        savedkey = keyupdate;
                    }
                    else if((keyupdate == '*') && (koma == false)) {
                        koma = true;
                        savedkey = '.';
                    }
                    lcd_gotoxy(pos,0); lcd_putchar(savedkey);
                    Kp_Temp[pos-9] = savedkey;
                    pos++;
                }
                
                if(keyupdate == '#') {
                    memset(Kp_Temp, 0, sizeof(Kp_Temp));
                    koma = false;
                    lcd_gotoxy(9,0); lcd_puts("       ");
                    pos = 9;
                }                     
                tekan = false;           
            }
        }
            
        if(millis() - lastmillis_value >= 500) { // Untuk membuat kursor '_' berkedip
            lastmillis_value = millis();
            if(pos < 13) {
                if(blink) { lcd_gotoxy(pos,0); lcd_putchar(' '); }
                else { lcd_gotoxy(pos,0); lcd_putchar('_'); }
                blink = !blink;
            }            
        }
                               
        buttonstate = startt;
        if (buttonstate != lastbuttonstate) { // Jika yang ditekan tombol start, maka keluar dari loop
            if (startt == ditekan) {
                pressed = true;
            }
        } 
        lastbuttonstate = buttonstate;
    } while(pressed == false);
    pressed = false;
    Kp = atof(Kp_Temp);
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("  Kp = ");
    lcd_gotoxy(8,0); sprintf(data, "%0.2f", Kp); lcd_puts(data);
    lcd_gotoxy(8,1); lcd_puts(Kp_Temp);
    memset(Kp_Temp, 0, sizeof(Kp_Temp));
    delay_ms(2000);
    
/*Update nilai Ki*/
    koma = false;
    memset(Ki_Temp, 0, sizeof(Ki_Temp));
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("SET Ki : ");
    lcd_gotoxy(0,1); lcd_putsf("*:,"); lcd_gotoxy(11,1); lcd_putsf("#:Clr");
    lastkeyupdate = '\0';
    keyupdate = '\0';
    pos = 9;
// looping set nilai Kp
    do {
        if(millis() - millis_cek >= 250) {   
            millis_cek = millis();
            keyupdate = keypad();        
            if(tekan == true) { // Jika ada penekanan keypad
                if(pos < 14) {
                    if((keyupdate >= 48) && (keyupdate <= 57)) {
                        lastkeyupdate = keyupdate;
                        savedkey = keyupdate;
                        lcd_gotoxy(pos,0); lcd_putchar(savedkey);
                    }
                    else if((keyupdate == '*') && (koma == false)) {
                        koma = true;
                        savedkey = '.';
                        lcd_gotoxy(pos,0); lcd_putchar(savedkey);
                    }
                    Ki_Temp[pos-9] = savedkey;
                    pos++;
                }
                
                if(keyupdate == '#') {
                    koma = false;
                    memset(Ki_Temp, 0, sizeof(Ki_Temp));
                    lcd_gotoxy(9,0); lcd_puts("       ");
                    pos = 9;
                }                     
                tekan = false;           
            }
        }
            
        if(millis() - lastmillis_value >= 500) { // Untuk membuat kursor '_' berkedip
            lastmillis_value = millis();
            if(pos < 13) {
                if(blink) { lcd_gotoxy(pos,0); lcd_putchar(' '); }
                else { lcd_gotoxy(pos,0); lcd_putchar('_'); }
                blink = !blink;
            }            
        }
                               
        buttonstate = startt;
        if (buttonstate != lastbuttonstate) { // Jika yang ditekan tombol start, maka keluar dari loop
            if (startt == ditekan) {
                pressed = true;
            }
        } 
        lastbuttonstate = buttonstate;
    } while(pressed == false);
    pressed = false;
    Ki = atof(Ki_Temp);
    lcd_clear();
    lcd_gotoxy(0,0); lcd_putsf("  Ki = ");
    lcd_gotoxy(8,0); sprintf(data, "%0.2f", Ki); lcd_puts(data);
    lcd_gotoxy(8,1); lcd_puts(Ki_Temp);
    memset(Ki_Temp, 0, sizeof(Ki_Temp));
    delay_ms(2000);
}

/*Fungsi untuk kirim data via serial*/
void UART_TxChar(char ch) {
	while (! (UCSRA & (1<<UDRE)));	/* Menunggu buffer transmit kosong*/
	UDR = ch ;
}

void UART_SendString(char *str) {
	unsigned char j=0;	
	while (str[j]!=0) { /*Kirim data*/
		UART_TxChar(str[j]);	
		j++;
	}
}

/*Fungsi utama*/
void main(void)
{
// Declare your local variables here
    unsigned char data[16];
    float ACSVal = 0;
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
//PORTA=0x00;
//DDRA=0x00;

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=P State2=P State1=P State0=T 
PORTA=0x0E;
DDRA=0xF0;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=P State1=T State0=T 
PORTB=0x04;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=P State1=P State0=P 
PORTD=0x07;
DDRD=0xF8;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 172.800 kHz
// Mode: CTC top=OCR0
// OC0 output: Disconnected
TCCR0=0x0B;
TCNT0=0x00;
OCR0=0xAC;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 11059.200 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x69;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: On
// INT2 Mode: Rising Edge
GICR|=0x20;
MCUCR=0x00;
MCUCSR=0x40;
GIFR=0x20;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x02;

// USART initialization
// USART disabled
//UCSRB=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x47;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

/* Enable global interrupt */
    #asm("sei")
    
// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);
lcd_gotoxy(0,0); lcd_putsf("  SOFT STARTER  ");
lcd_gotoxy(0,1); lcd_putsf("  MOTOR 1 FASA  ");
delay_ms(2000);
calibrate();
lcd_clear();
countpwm = 200;
lcd_clear();
lcd_gotoxy(0,0); lcd_puts("ARUS : ");
lcd_gotoxy(0,1); lcd_puts("PWM  : ");
while (1)
      {
      // Place your code here                  
          Cek_Interrupt(); // Memanggil fungsi Cek_Interrupt() 
          if(millis() - lastmillis_value >= 1000) { // Update LCD, kirim data serial dan Fungsi PIControl() setiap 1 detik
            lastmillis_value = millis();
            if(countpwm >= 250) count++;
            else countpwm = countpwm + 10;
            //OCR2 = countpwm;
            ACSVal = readACS();
            if(count > 3 ) { countpwm = 0; count = 0; }
            lcd_gotoxy(7,0); lcd_puts("        "); lcd_gotoxy(7,1); lcd_puts("        ");
            lcd_gotoxy(7,0); sprintf(data, "%d", ACSVal); lcd_puts(data);
            lcd_gotoxy(7,1); sprintf(data, "%d", countpwm); lcd_puts(data);
            sprintf(data, "Sens ACS %0.1f|PWM %d", ACSVal, countpwm); UART_SendString(data); UART_SendString("\r\n"); // Kirim data via serial untuk monitoring
          }           
      }
}