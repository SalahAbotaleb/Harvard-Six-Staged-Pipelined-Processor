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

int hex2dec(string hexVal)
{
    int len = hexVal.size();
    int base = 1;
    
    int dec_val = 0;
    
    for (int i = len - 1; i >= 0; i--) {
        if (hexVal[i] >= '0' && hexVal[i] <= '9') {
            dec_val += (int(hexVal[i]) - 48) * base;
            base = base * 16;
        }

        else if (hexVal[i] >= 'A' && hexVal[i] <= 'F') {
            dec_val += (int(hexVal[i]) - 55) * base;
            base = base * 16;
        }
    }
    return dec_val;
}

void encode (const vector<string> &op, const vector<string> &reg, ofstream &fout) {
    int counter = 0;
    for (int i = 0; i < op.size(); i++) {
        
        if (op[i] == ".ORG") {
            counter = hex2dec(reg[i]);
            continue;
        } else {
            fout << "\t" << counter << ": ";
        }
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
            fout << "10000000" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][1] - '0').to_string()
                 << "00" << endl;
        } else if (op[i] == "JZ") {
            fout << "10001000" << bitset<3>(reg[i][1] - '0').to_string() << "00000" << endl;
        } else if (op[i] == "JC") {
            fout << "10010000" << bitset<3>(reg[i][1] - '0').to_string() << "00000" << endl;
        } else if (op[i] == "JMP") {
            fout << "10011000" << bitset<3>(reg[i][1] - '0').to_string() << "00000" << endl;
        } else if (op[i] == "CALL") {
            fout << "10100000" << bitset<3>(reg[i][1] - '0').to_string() << "00000" << endl;
        } else if (op[i] == "RET") {
            fout << "1010100000000000" << endl;
        } else if (op[i] == "RTI") {
            fout << "1011000000000000" << endl;
        } else if (op[i] == "IADD") {
            fout << "11110" << bitset<3>(reg[i][1] - '0').to_string() << bitset<3>(reg[i][4] - '0').to_string()
                 << "00000" << endl;
            counter++;
            fout << "\t" << counter << ": ";
            if (reg[i].size() == 7)
                fout << "000000000000";
            else if (reg[i].size() == 8)
                fout << "00000000";
            else if (reg[i].size() == 9)
                fout << "0000";
            for (int j = 6; j < reg[i].size(); ++j) {
                fout << hex2bin(reg[i][j]);
            }
            fout << endl;
        } else if (op[i] == "LDM") {
            fout << "11111" << bitset<3>(reg[i][1] - '0').to_string() << "00000000" << endl;
            counter++;
            fout << "\t" << counter << ": ";
            if (reg[i].size() == 4)
                fout << "000000000000";
            else if (reg[i].size() == 5)
                fout << "00000000";
            else if (reg[i].size() == 6)
                fout << "0000";
            for (int j = 3; j < reg[i].size(); ++j) {
                fout << hex2bin(reg[i][j]);
            }
            fout << endl;
        } else {
            if (op[i].size() == 1) {
                fout << "000000000000";
            } else if (op[i].size() == 2) {
                fout << "00000000";
            } else if (op[i].size() == 3) {
                fout << "0000";
            }
            for (int j = 0; j < op[i].size(); ++j) {
                fout << hex2bin(op[i][j]);
            }
            fout << endl;
        }
        counter++;
    }
    
}

void checksyntax (const string &op, const string &reg) {
    bool number = false;
    if (op != "NOP" && op != "SETC" && op != "CLRC" && op != "RET" && op != "RTI" && op != "INC" && op != "DEC" &&
        op != "OUT" && op != "IN" && op != "PUSH" && op != "POP" && op != "JZ" && op != "JC" && op != "JMP" &&
        op != "CALL" && op != "IADD" && op != "MOV" && op != "ADD" && op != "SUB" && op != "AND" && op != "OR" &&
        op != "LDD" && op != "STD" && op != "NOT" && op != "LDM" && op != "CALL" && op != ".ORG") {
        for (int i = 0; i < op.size(); ++i) {
            if (op[i] - '0' < 0 && op[i] - '0' > 9 && op[i] - '0' != 'A' && op[i] - '0' != 'B' && op[i] - '0' != 'C' &&
                op[i] - '0' != 'D' && op[i] - '0' != 'E' && op[i] - '0' != 'F') {
                throw runtime_error(op + " is not a valid instruction.");
            }
        }
        number = true;
    }
    if (number) return;
    if (op != "NOP" && op != "SETC" && op != "CLRC" && op != "RET" && op != "RTI" && op != ".ORG") {
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
                if (reg[5] != ',') {
                    for (int i = 6; i < reg.size(); ++i) {
                        if (hex2bin(reg[i]) == "-1") {
                            throw runtime_error("Invalid immediate value.");
                        }
                    }
                }
            }
        } else if (op == "LDM") {
            if (reg[2] != ',') {
                for (int i = 3; i < reg.size(); ++i) {
                    if (hex2bin(reg[i]) == "-1") {
                        throw runtime_error("Invalid immediate value.");
                    }
                }
            }
        }
    }
}

void readcode (ifstream &fin, vector<string> &oper, vector<string> &registers) {
    char s;
    string op, reg;
    while (fin >> noskipws >> s) {
        if (s == '#') {
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
            if (s == '#')
                while (fin >> noskipws >> s && s != '\n');
        }
    }
}
void initial(ofstream &fout,string memory_instance_path){
    fout<<"// memory data file (do not edit the following line - required for mem load use)\n";
    fout<<"// instance="+memory_instance_path+'\n';
    fout<<"// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1"<<endl;
}
int main () {
    string input_file_name,output_file_name,memory_instance_path;
    cout<<"Welecome to Assembler :) \n";

    cout<<"Enter the name of input file: ";
    cin>>input_file_name;
    cout<<"Enter the name of output file: ";
    cin>>output_file_name;
    cout<<"Enter the path of memory instance (ex. /processor/FetchUnit/instructionFile/x): ";
    cin>>memory_instance_path;
    cout<<endl;
    ifstream fin(input_file_name);
    ofstream fout(output_file_name);

    vector<string> oper;
    vector<string> registers;

    initial(fout,memory_instance_path);
    readcode(fin, oper, registers);
    encode(oper, registers, fout);
    
    return 0;
}