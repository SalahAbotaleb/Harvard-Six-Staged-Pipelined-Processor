#include <bits/stdc++.h>

using namespace std;
#define ll long long int

string hex2bin (char x) {
    switch (x) {
        case '0':
            return "0000";
        case '1':
            return "0001";
        case '2':
            return "0010";
        case '3':
            return "0011";
        case '4':
            return "0100";
        case '5':
            return "0101";
        case '6':
            return "0110";
        case '7':
            return "0111";
        case '8':
            return "1000";
        case '9':
            return "1001";
        case 'A':
            return "1010";
        case 'B':
            return "1011";
        case 'C':
            return "1100";
        case 'D':
            return "1101";
        case 'E':
            return "1110";
        case 'F':
            return "1111";
    }
    return {};
}

int main (int argc, char *argv[]) {
    ifstream fin(R"(C:\Users\moaaz\Downloads\Testcases_PhaseOne.asm)");
    ofstream fout(R"(Testcases_PhaseOne.mem)");
    char s;
    string op, reg;
    while (fin >> noskipws >> s) {
        if (s == '#' || s == '.') {
            while (fin >> noskipws >> s && s != '\n');
        } else if (s != '\n' && s != ' ' && s != '\t') {
            op = "";
            reg = "";
            op += s;
            while (fin >> noskipws >> s && s != ' ' && s != '\t' && s != '\n') {
                op += s;
            }
            while (fin >> noskipws >> s && s != '\n' && s != ' ' && s != '\t') {
                reg += s;
            }
            cout << op << " " << reg << endl;
            if (op == "NOP") {
                fout << "0000000000000000" << endl;
            } else if (op == "SETC") {
                fout << "0000100000000000" << endl;
            } else if (op == "CLRC") {
                fout << "0001000000000000" << endl;
            } else if (op == "NOT") {
                fout << "00011" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string() << "00000"
                     << endl;
            } else if (op == "INC") {
                fout << "00100" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string() << "00000"
                     << endl;
            } else if (op == "DEC") {
                fout << "00101" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string() << "00000"
                     << endl;
            } else if (op == "OUT") {
                fout << "00110000" << bitset<3>(reg[1] - '0').to_string() << "00000" << endl;
            } else if (op == "IN") {
                fout << "00111" << bitset<3>(reg[1] - '0').to_string() << "00000000" << endl;
            } else if (op == "MOV") {
                fout << "01000" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string() << "00000"
                     << endl;
            } else if (op == "ADD") {
                fout << "01001" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string()
                     << bitset<3>(reg[7] - '0').to_string() << "00" << endl;
            } else if (op == "SUB") {
                fout << "01010" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string()
                     << bitset<3>(reg[7] - '0').to_string() << "00" << endl;
            } else if (op == "AND") {
                fout << "01011" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string()
                     << bitset<3>(reg[7] - '0').to_string() << "00" << endl;
            } else if (op == "OR") {
                fout << "01100" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string()
                     << bitset<3>(reg[7] - '0').to_string() << "00" << endl;
            } else if (op == "PUSH") {
                fout << "01101000" << bitset<3>(reg[1] - '0').to_string() << "00000" << endl;
            } else if (op == "POP") {
                fout << "01110" << bitset<3>(reg[1] - '0').to_string() << "00000000" << endl;
            } else if (op == "LDD") {
                fout << "01111" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string() << "00000"
                     << endl;
            } else if (op == "STD") {
                fout << "10000000" << bitset<3>(reg[4] - '0').to_string() << bitset<3>(reg[1] - '0').to_string()
                     << "00" << endl;
            } else if (op == "JZ") {
                fout << "10001" << bitset<3>(reg[1] - '0').to_string() << "00000000" << endl;
            } else if (op == "JC") {
                fout << "10010" << bitset<3>(reg[1] - '0').to_string() << "00000000" << endl;
            } else if (op == "JMP") {
                fout << "10011" << bitset<3>(reg[1] - '0').to_string() << "00000000" << endl;
            } else if (op == "CALL") {
                fout << "10100" << bitset<3>(reg[1] - '0').to_string() << "00000000" << endl;
            } else if (op == "RET") {
                fout << "1010100000000000" << endl;
            } else if (op == "RTI") {
                fout << "1011000000000000" << endl;
            } else if (op == "IADD") {
                fout << "1" << bitset<3>(reg[1] - '0').to_string() << bitset<3>(reg[4] - '0').to_string() << "00000"
                     << endl;
                fout << hex2bin(reg[6]) + hex2bin(reg[7]) + hex2bin(reg[8]) + hex2bin(reg[9]) << endl;
            }
        }
    }
    return 0;
}