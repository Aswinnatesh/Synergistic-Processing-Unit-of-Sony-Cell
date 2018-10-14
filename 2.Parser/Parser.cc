#include <iostream>
#include <cstring>
#include <fstream>
#include <string>
#include <sstream>

using namespace std;

char *DecToBin(string nums, unsigned bit);

int main()
{
    ifstream inFile("Assembly.txt");
    ofstream outFile;
    outFile.open(("Instruction.txt"));
    string line, str_null= "000";
    string str[10];

    while(getline(inFile, line))
    {
        char *token = std::strtok(&line[0], " \t , ");
            int i=0;

            while (token != NULL) 
                {
                    str[i] = token;
                    token = std::strtok(NULL, " \t , "); 
                    i++;
                }
            if(i!=0){ // Not to enter first time
            //if(str[0] == "MUL") {outFile << "Text"<< DecToBin(str[1], 10)<< endl;}
            if(str[0] =="a") {outFile << "00011000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 1 - a - Add Word
            else if(str[0] =="addx") {outFile << "11010000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 2 - addx - Add Extended
            else if(str[0] =="ai") {outFile << "00011100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 3 - ai - Add Word Immediate
            else if(str[0] =="and") {outFile << "00011000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 4 - and - And
            else if(str[0] =="andbi") {outFile << "00010110"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 5 - andbi - And Byte Immediate
            else if(str[0] =="andc") {outFile << "01011000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 6 - andc - And with Complement
            else if(str[0] =="ceq") {outFile << "01111000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 7 - ceq - Compare Equal Word
            else if(str[0] =="ceqb") {outFile << "01111010000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 8 - ceqb - Compare Equal Byte
            else if(str[0] =="ceqbi") {outFile << "01111110"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 9 - ceqbi - Compare Equal Byte Immediate
            else if(str[0] =="ceqi") {outFile << "01111100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 10 - ceqi - Compare Equal Word Immediate
            else if(str[0] =="cgtb") {outFile << "01001010000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 11 - cgtb - Compare Greater Than Byte
            else if(str[0] =="cgtbi") {outFile << "01001110"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 12 - cgtbi - Compare Greater Than Byte Immediate
            else if(str[0] =="cgti") {outFile << "01001100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 13 - cgti - Compare Greater Than Word Immediate
            else if(str[0] =="clgtb") {outFile << "01011010000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 14 - clgtb - Compare Logical Greater Than Byte
            else if(str[0] =="clgtbi") {outFile << "01011110"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 15 - clgtbi - Compare Logical Greater Than Byte Immediate
            else if(str[0] =="il") {outFile << "010000001"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 16 - il - Immediate Load Word
            else if(str[0] =="ila") {outFile << "0100001"<<DecToBin(str[2], 18)<<DecToBin(str[1], 7)<<endl;}  // 17 - ila - Immediate Load Address
            else if(str[0] =="ilh") {outFile << "010000011"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 18 - ilh - Immediate Load Halfword
            else if(str[0] =="nand") {outFile << "00011001001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 19 - nand - Nand
            else if(str[0] =="nor") {outFile << "00001001001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 20 - nor - Nor
            else if(str[0] =="or") {outFile << "00001000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 21 - or - Or
            else if(str[0] =="orc") {outFile << "01011001001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 22 - orc - Or with Complement
            else if(str[0] =="ori") {outFile << "00000100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 23 - ori - Or Word Immediate
            else if(str[0] =="sf") {outFile << "00001000000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 24 - sf - Subtract from Word
            else if(str[0] =="sfi") {outFile << "00001100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 25 - sfi - Subtract from Word Immediate
            else if(str[0] =="sfx") {outFile << "01101000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 26 - sfx - Subtract from Extended
            else if(str[0] =="xor") {outFile << "01001000001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 27 - xor - Exclusive Or
            else if(str[0] =="xorbi") {outFile << "01000110"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 28 - xorbi - Exclusive Or Byte Immediate
            else if(str[0] =="xori") {outFile << "01000100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 29 - xori - Exclusive Or Word Immediate
            else if(str[0] =="xsbh") {outFile << "01010110110"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 30 - xsbh - Extend Sign Byte to Halfword
            else if(str[0] =="xshw") {outFile << "01010101110"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 31 - xshw - Extend Sign Halfword to Word
            else if(str[0] =="xswd") {outFile << "01010100110"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 32 - xswd - Extend Sign Word to Doubleword
            else if(str[0] =="absdb") {outFile << "00001010011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 33 - absdb - Absolute Differences of Bytes
            else if(str[0] =="avgb") {outFile << "00011010011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 34 - avgb - Average Bytes
            else if(str[0] =="cntb") {outFile << "01010110100"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 35 - cntb - Count Ones in Bytes
            else if(str[0] =="sumb") {outFile << "01001010011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 36 - sumb - Sum Bytes into Halfwords
            else if(str[0] =="rot") {outFile << "00001011000"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 37 - rot - Rotate Word
            else if(str[0] =="rotm") {outFile << "00001011001"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 38 - rotm - Rotate and Mask Word
            else if(str[0] =="shl") {outFile << "00001011011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 39 - shl - Shift Left Word
            else if(str[0] =="shli") {outFile << "00001111011"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 40 - shli - Shift Left Word Immediate
            else if(str[0] =="bi") {outFile << "00110101000"<<DecToBin(str_null, 7)<<DecToBin(str[1], 7)<<DecToBin(str_null, 7)<<endl;}  // 41 - bi - Branch Indirect
            else if(str[0] =="bisl") {outFile << "00110101001"<<DecToBin(str_null, 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 42 - bisl - Branch Indirect and Set Link
            else if(str[0] =="br") {outFile << "001100100"<<DecToBin(str[2], 16)<<DecToBin(str_null, 7)<<endl;}  // 43 - br - Branch Relative
            else if(str[0] =="bra") {outFile << "001100000"<<DecToBin(str[2], 16)<<DecToBin(str_null, 7)<<endl;}  // 44 - bra - Branch Absolute
            else if(str[0] =="brasl") {outFile << "001100010"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 45 - brasl - Branch Absolute and Set Link
            else if(str[0] =="brsl") {outFile << "001100110"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 46 - brsl - Branch Relative and Set Link
            else if(str[0] =="rotqby") {outFile << "00111011100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 47 - rotqby - Rotate Quadword by Bytes
            else if(str[0] =="rotqbyi") {outFile << "00111111100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 48 - rotqbyi - Rotate Quadword by Bytes Immediate
            else if(str[0] =="rotqmby") {outFile << "00111011101"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 49 - rotqmby - Rotate and Mask Quadword by Bytes
            else if(str[0] =="rotqmbyi") {outFile << "00111111101"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 50 - rotqmbyi - Rotate and Mask Quadword by Bytes Immediate
            else if(str[0] =="shlqby") {outFile << "00111011111"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 51 - shlqby - Shift Left Quadword by Bytes
            else if(str[0] =="shlqbyi") {outFile << "00111111111"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 52 - shlqbyi - Shift Left Quadword by Bytes Immediate
            else if(str[0] =="fa") {outFile << "01011000100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 53 - fa - Floating Add
            else if(str[0] =="fm") {outFile << "01011000110"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 54 - fm - Floating Multiply
            else if(str[0] =="fma") {outFile << "1110"<<DecToBin(str[1], 7)<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[4], 7)<<endl;}  // 55 - fma - Floating Multiply and Add
            else if(str[0] =="fms") {outFile << "1111"<<DecToBin(str[1], 7)<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[4], 7)<<endl;}  // 56 - fms - Floating Multiply and Subtract
            else if(str[0] =="fs") {outFile << "01011000101"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 57 - fs - Floating Subtract
            else if(str[0] =="lqa") {outFile << "001100001"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 58 - lqa - Load Quadword (a-form)
            else if(str[0] =="lqx") {outFile << "00111000100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 59 - lqx - Load Quadword (x-form)
            else if(str[0] =="stqa") {outFile << "001000001"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 60 - stqa - Store Quadword (a-form)
            else if(str[0] =="stqx") {outFile << "00101000100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 61 - stqx - Store Quadword (x-form)
            else if(str[0] =="mpy") {outFile << "01111000100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 62 - mpy - Multiply
            else if(str[0] =="mpya") {outFile << "1100"<<DecToBin(str[1], 7)<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[4], 7)<<endl;}  // 63 - mpya - Multiply and Add
            else if(str[0] =="mpyi") {outFile << "01110100"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 64 - mpyi - Multiply Immediate
            else if(str[0] =="mpys") {outFile << "01111000111"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 65 - mpys - Multiply and Shift Right
            else if(str[0] =="mpyu") {outFile << "01111001100"<<DecToBin(str[3], 7)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 66 - mpyu - Multiply Unsigned
            else if(str[0] =="mpyui") {outFile << "01110101"<<DecToBin(str[3], 10)<<DecToBin(str[2], 7)<<DecToBin(str[1], 7)<<endl;}  // 67 - mpyui - Multiply Unsigned Immediate
            else if(str[0] =="brnz") {outFile << "001000010"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 68 - brnz - Branch if Not Zero Word
            else if(str[0] =="brz") {outFile << "001000000"<<DecToBin(str[2], 16)<<DecToBin(str[1], 7)<<endl;}  // 69 - brz - Branch if Zero Word
            else if(str[0] =="onop") {outFile << "01000000010"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;}  // 70 - Inop - No Operation (Execute)
            else if(str[0] =="enop") {outFile << "01000000001"<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<DecToBin(str_null, 7)<<endl;}  // 71 - nop - No Operation (Execute)
            else {cout<<str[0]<<" Instruction not Found"<<endl;}}
    }
    outFile.close();
}


//Decimal to Binary
char* DecToBin(string nums, unsigned bit)
{
    int num;
    istringstream (nums) >> num;
    char *binStr = new char (bit + 1);
    int len = bit;

    binStr[bit] = '\0';
    while (bit--)   binStr[bit] = '0';

    if (num == 0)
        return binStr;

    int r;
    while (num && len)
    {
        r = num % 2;
        binStr[--len] = r + '0';
        num /= 2;
    }

    return binStr;
}
