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
        default:
            return "-1";
    }
    return {};
}

void encode (const vector<string> &op, const vector<string> &reg, ofstream &fout) {
    for (int i = 0; i < op.size(); i++) {
        fout << "\t" << i << ": ";
        if (op[i] == "NOP") {
            fout << "0000000000000000" << endl;
        } else if (op[i] == "SETC") {
            fout << "0000100000000000" << endl;
        } else if (op[i] == "CLRC") {
            fout << "0001000000000000" << endl;
        } else if (op[i] == "NOT") {
            fout << "00011" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << "00000"
                 << endl;
        } else if (op[i] == "INC") {
            fout << "00100" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << "00000"
                 << endl;
        } else if (op[i] == "DEC") {
            fout << "00101" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << "00000"
                 << endl;
        } else if (op[i] == "OUT") {
            fout << "00110000" << bitset<3>(reg[i][1] - '0').to_string() << "00000" << endl;
        } else if (op[i] == "IN") {
            fout << "00111" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
        } else if (op[i] == "MOV") {
            fout << "01000" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << "00000"
                 << endl;
        } else if (op[i] == "ADD") {
            fout << "01001" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << bitset<3>(reg[i][7] - '0').to_string() << "00" << endl;
        } else if (op[i] == "SUB") {
            fout << "01010" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << bitset<3>(reg[i][7] - '0').to_string() << "00" << endl;
        } else if (op[i] == "AND") {
            fout << "01011" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << bitset<3>(reg[i][7] - '0').to_string() << "00" << endl;
        } else if (op[i] == "OR") {
            fout << "01100" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << bitset<3>(reg[i][7] - '0').to_string() << "00" << endl;
        } else if (op[i] == "PUSH") {
            fout << "01101000" << bitset<3>(reg[i][1] - '0').to_string() << "00000" << endl;
        } else if (op[i] == "POP") {
            fout << "01110" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
        } else if (op[i] == "LDD") {
            fout << "01111" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << "00000"
                 << endl;
        } else if (op[i] == "STD") {
            fout << "10000000" << bitset<3>(reg[i][4] - '0').to_string() << bitset<3>(reg[i][1] - '0').to_string()
                 << "00" << endl;
        } else if (op[i] == "JZ") {
            fout << "10001" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
        } else if (op[i] == "JC") {
            fout << "10010" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
        } else if (op[i] == "JMP") {
            fout << "10011" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
        } else if (op[i] == "CALL") {
            fout << "10100" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
        } else if (op[i] == "RET") {
            fout << "1010100000000000" << endl;
        } else if (op[i] == "RTI") {
            fout << "1011000000000000" << endl;
        } else if (op[i] == "IADD") {
            fout << "1" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string() << "00000"
                 << endl;
            fout << hex2bin(reg[i][6]) + hex2bin(reg[i][7]) + hex2bin(reg[i][8]) + hex2bin(reg[i][9]) << endl;
        } else if (op[i] == "LDM") {
            fout << "10111" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
            fout << hex2bin(reg[i][4]) + hex2bin(reg[i][5]) + hex2bin(reg[i][6]) + hex2bin(reg[i][7]) << endl;
        }
    }
}

void checksyntax (const string &op, const string &reg) {
    if (op != "NOP" && op != "SETC" && op != "CLRC" && op != "RET" && op != "RTI" && op != "INC" && op != "DEC" &&
        op != "OUT" && op != "IN" && op != "PUSH" && op != "POP" && op != "JZ" && op != "JC" && op != "JMP" &&
        op != "CALL" && op != "IADD" && op != "MOV" && op != "ADD" && op != "SUB" && op != "AND" && op != "OR" &&
        op != "LDD" && op != "STD" && op != "NOT" && op != "LDM" && op != "CALL") {
        throw runtime_error(op + " is not a valid instruction.");
    }
    
    if (op != "NOP" && op != "SETC" && op != "CLRC" && op != "RET" && op != "RTI") {
        if (reg[0] != 'R' || reg[1] - '0' < 0 || reg[1] - '0' > 7) {
            throw runtime_error("Invalid register.");
        }
        if (op != "OUT" && op != "IN" && op != "PUSH" && op != "POP" && op != "JZ" && op != "JC" && op != "JMP" &&
            op != "CALL" && op != "LDM") {
            if (reg[2] != ',' || reg[3] != 'R' || reg[4] - '0' < 0 || reg[4] - '0' > 7) {
                throw runtime_error("Invalid register.");
            }
            if (op != "IADD" && op != "LDD" && op != "STD" && op != "MOV" && op != "NOT" &&
                op != "INC" && op != "DEC") {
                if (reg[5] != ',' || reg[6] != 'R' || reg[7] - '0' < 0 || reg[7] - '0' > 7) {
                    throw runtime_error("Invalid register.");
                }
            } else if (op == "IADD") {
                if (reg[5] != ',' || hex2bin(reg[6]) == "-1" || hex2bin(reg[7]) == "-1" || hex2bin(reg[8]) == "-1" ||
                    hex2bin(reg[9]) == "-1") {
                    throw runtime_error("Invalid immediate value.");
                }
            }
        } else if (op == "LDM") {
            if (reg[2] != ',' || hex2bin(reg[3]) == "-1" || hex2bin(reg[4]) == "-1" || hex2bin(reg[5]) == "-1" ||
                hex2bin(reg[6]) == "-1") {
                throw runtime_error("Invalid immediate value.");
            }
        }
    }
}

void readcode (ifstream &fin, vector<string> &oper, vector<string> &registers) {
    char s;
    string op, reg;
    while (fin >> noskipws >> s) {
        if (s == '#' || s == '.') {
            while (fin >> noskipws >> s && s != '\n');
        } else if (s != '\n' && s != ' ' && s != '\t' && s != '#') {
            op = "";
            reg = "";
            s = toupper(s);
            op += s;
            while (fin >> noskipws >> s && s != ' ' && s != '\t' && s != '\n' && s != '#') {
                s = toupper(s);
                op += s;
            }
            
            if (op != "NOP" && op != "SETC" && op != "CLRC" && op != "RET" && op != "RTI") {
                while (fin >> noskipws >> s && s != '\n' && s != '#') {
                    if (s == ' ' || s == '\t') continue;
                    s = toupper(s);
                    reg += s;
                    
                }
            }
            if (op == "")
                continue;
            
            checksyntax(op, reg);
            cout << op << " " << reg << endl;
            
            oper.push_back(op);
            registers.push_back(reg);
            if (s == '#' || s == '.')
                while (fin >> noskipws >> s && s != '\n');
        }
    }
}

void reordering (vector<string> &oper, vector<string> &registers) {
    for (int i = 0; i < oper.size(); i++) {
        if (oper[i] == "JZ" || oper[i] == "JC" || oper[i] == "JMP" || oper[i] == "CALL") {
            int j = i + 1;
            while (oper[j] != "NOP") {
                j++;
            }
            swap(oper[i], oper[j]);
            swap(registers[i], registers[j]);
        }
    }
}

int main (int argc, char *argv[]) {
    ifstream fin(argv[1] + string(".asm"));
    ofstream fout(argv[2] + string(".mem"));
    
    vector<string> oper;
    vector<string> registers;
    
    readcode(fin, oper, registers);
    reordering(oper, registers);
    encode(oper, registers, fout);
    
    return 0;
}