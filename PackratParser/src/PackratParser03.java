package parser;

import java.util.Scanner;

/**
 * not LR(k) for any k
 * 
 * S	<- R | L '=' R
 * R	<- A | A EQ A | A NE A
 * A	<- P | P '+' P | P '-' P
 * P	<- ID | '(' R ')'
 * L	<- ID | '(' L ')'
 * ID	<- 'a' | 'a' ID
 * EQ	<- '=' '='
 * NE	<- '!' '='
 * 
 * 
 * */
public class PackratParser03 {
	static int[][][] memory; //[Derivs][LengthOfInput][Field]
	static char[] input;
	static int len = 0;

	//Constants for Derivs
	static final int NUM_DV = 8;
	static final int DV_S = 0;
	static final int DV_R = 1;
	static final int DV_A = 2;
	static final int DV_P = 3;
	static final int DV_L = 4;
	static final int DV_ID = 5;
	static final int DV_EQ = 6;
	static final int DV_NE = 7;

	//for Field
	static final int NUM_FIELD = 2;
	static final int F_SEM = 0; //field for semantic value
	static final int F_SUF = 1; //field for remainder suffixs begin

	//for remainder suffixs
	static final int RS_UNUSED = 0;
	static final int RS_SUCCESS = -1;
	static final int RS_FAIL = -2;
	static final int RS_END = -3;


	public static void main(String[] args) {
		System.out.println("Packrat Parser start.");
		Scanner sc = new Scanner(System.in);
		while(true){
			String input = sc.nextLine();
			if(input.equals(":q")) break;
			parseLine(input);
		}
		System.out.println("Packrat Parser end.");

	}
	static String translateRS(int r){
		String ret = "";
		switch(r){
		case 0: ret = "UNUSED"; break;
		case -1: ret = "SUCCESS"; break;
		case -2: ret = "FAIL"; break;
		case -3: ret = "END"; break;
		default: ret = String.valueOf(r);
		}
		return ret;
	}
	static void parseLine(String str){
		input = str.replaceAll(" ", "").toCharArray(); //remove whitespace
		len = input.length;
		if(len < 1) return;
		memory = new int[NUM_DV][len][NUM_FIELD];
		System.out.println("input : " + str);
		int ret = pS(0);
		System.out.println("ret : " + translateRS(ret));
		System.out.println("semantic value : " + memory[DV_S][0][F_SEM]);
		System.out.println("suffix value : " + translateRS(memory[DV_S][0][F_SUF]));
	}

	static int pS(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index) return ret;
		if(memory[DV_S][index][F_SUF] == RS_UNUSED){
			memory[DV_S][index][F_SUF] = RS_FAIL;
			if(pR(index) == RS_SUCCESS && memory[DV_R][index][F_SUF] == RS_END){
				memory[DV_S][index][F_SEM] = DV_R;
				memory[DV_S][index][F_SUF] = memory[DV_R][index][F_SUF];
				return RS_SUCCESS;
			}
			else if(pL(index) == RS_SUCCESS){
				int idx = memory[DV_L][index][F_SUF];
				if(idx != RS_END && idx < len && input[idx] == '=' && pR(idx + 1) == RS_SUCCESS){
					memory[DV_S][index][F_SEM] = DV_L;
					memory[DV_S][index][F_SUF] = memory[DV_R][idx + 1][F_SUF];
					return RS_SUCCESS;
				}
			}
		}
		else ret = (memory[DV_S][index][F_SUF] >= 0 || memory[DV_S][index][F_SUF] == RS_END)? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pR(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index) return ret;
		if(memory[DV_R][index][F_SUF] == RS_UNUSED){
			memory[DV_R][index][F_SUF] = RS_FAIL;
			memory[DV_R][index][F_SEM] = RS_FAIL;
			ret = pA(index); 
			if(ret == RS_SUCCESS){
				int idx = memory[DV_A][index][F_SUF];
				if(pEQ(idx) == RS_SUCCESS){
					int idx2 = memory[DV_EQ][idx][F_SUF];
					if(pA(idx2) == RS_SUCCESS){
						memory[DV_R][index][F_SUF] = memory[DV_A][idx2][F_SUF];
						memory[DV_R][index][F_SEM] = DV_R;
					}
					else ret = RS_FAIL;
				}
				else if(pNE(idx) == RS_SUCCESS){
					int idx2 = memory[DV_NE][idx][F_SUF];
					if(pA(idx2) == RS_SUCCESS){
						memory[DV_R][index][F_SUF] = memory[DV_A][idx2][F_SUF];
						memory[DV_R][index][F_SEM] = DV_R;
					}
					else ret = RS_FAIL;
				}
				else{
					memory[DV_R][index][F_SUF] = idx;
					memory[DV_R][index][F_SEM] = DV_R;
				}
			}
		}
		else ret = memory[DV_R][index][F_SEM] == DV_R? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pA(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index) return ret;
		if(memory[DV_A][index][F_SUF] == RS_UNUSED){
			memory[DV_A][index][F_SUF] = RS_FAIL;
			memory[DV_A][index][F_SEM] = RS_FAIL;
			ret = pP(index); 
			if(ret == RS_SUCCESS){
				int idx = memory[DV_P][index][F_SUF];

				if(idx != RS_END && idx < len && input[idx] == '+'){
					int idx2 = idx + 1;
					if(pP(idx2) == RS_SUCCESS){
						memory[DV_A][index][F_SUF] = memory[DV_P][idx2][F_SUF];
						memory[DV_A][index][F_SEM] = DV_A;
					}
					else ret = RS_FAIL;
				}
				else if(idx != RS_END && idx < len && input[idx] == '-'){
					int idx2 = idx + 1;
					if(pP(idx2) == RS_SUCCESS){
						memory[DV_A][index][F_SUF] = memory[DV_P][idx2][F_SUF];
						memory[DV_A][index][F_SEM] = DV_A;
					}
					else ret = RS_FAIL;
				}
				else{
					memory[DV_A][index][F_SUF] = idx;
					memory[DV_A][index][F_SEM] = DV_A;
				}
			}
		}
		else ret = memory[DV_A][index][F_SEM] == DV_A? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pP(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index) return ret;
		if(memory[DV_P][index][F_SUF] == RS_UNUSED){
			memory[DV_P][index][F_SUF] = RS_FAIL;
			memory[DV_P][index][F_SEM] = RS_FAIL;

			ret = pID(index); 
			if(ret == RS_SUCCESS){
				memory[DV_P][index][F_SUF] = memory[DV_ID][index][F_SUF];
				memory[DV_P][index][F_SEM] = DV_L;
				return ret;
			}
			if(input[index] == '('){
				ret = pR(index + 1);
				if(ret == RS_SUCCESS){
					int idx = memory[DV_R][index + 1][F_SUF];
					if(idx != RS_END && idx < len){
						if(input[idx] == ')'){
							memory[DV_P][index][F_SEM] = DV_P;
							memory[DV_P][index][F_SUF] = idx + 1 == len? RS_END : idx + 1;
							ret = RS_SUCCESS;
							return ret;
						}
						
					}
				}
			}
			ret = RS_FAIL;
		}
		else ret = memory[DV_P][index][F_SEM] == DV_P? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pL(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index) return ret;
		if(memory[DV_L][index][F_SUF] == RS_UNUSED){
			memory[DV_L][index][F_SUF] = RS_FAIL;
			memory[DV_L][index][F_SEM] = RS_FAIL;

			ret = pID(index); 
			if(ret == RS_SUCCESS){
				memory[DV_L][index][F_SUF] = memory[DV_ID][index][F_SUF];
				memory[DV_L][index][F_SEM] = DV_L;
				return ret;
			}
			if(input[index] == '('){
				ret = pL(index + 1);
				if(ret == RS_SUCCESS){
					int idx = memory[DV_L][index + 1][F_SUF];
					if(idx != RS_END && idx < len){
						if(input[idx] == ')'){
							memory[DV_L][index][F_SEM] = DV_L;
							memory[DV_L][index][F_SUF] = idx + 1 == len? RS_END : idx + 1;
							ret = RS_SUCCESS;
							return ret;
						}
						
					}
				}
			}
			ret = RS_FAIL;
		}
		else ret = memory[DV_L][index][F_SEM] == DV_L? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pID(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index) return ret;
		if(memory[DV_ID][index][F_SUF] == RS_UNUSED){
			memory[DV_ID][index][F_SUF] = RS_FAIL;
			memory[DV_ID][index][F_SEM] = RS_FAIL;
			if(input[index] == 'a'){
				ret = pID(index + 1);
				if(ret == RS_SUCCESS){
					memory[DV_ID][index][F_SUF] = memory[DV_ID][index + 1][F_SUF];
					memory[DV_ID][index][F_SEM] = DV_ID;
				}
				else{
					ret = RS_SUCCESS; 
					memory[DV_ID][index][F_SUF] = index + 1 == len? RS_END : index + 1;
					memory[DV_ID][index][F_SEM] = DV_ID;
				}
			}
		}
		else ret = memory[DV_ID][index][F_SEM] == DV_ID? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pEQ(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index + 1) return ret;
		if(memory[DV_EQ][index][F_SUF] == RS_UNUSED){
			memory[DV_EQ][index][F_SUF] = RS_FAIL;
			memory[DV_EQ][index][F_SEM] = RS_FAIL;
			if(input[index] == '=' && input[index + 1] == '='){
				ret = RS_SUCCESS; 
				memory[DV_EQ][index][F_SUF] = index + 2;
				memory[DV_EQ][index][F_SEM] = DV_EQ;
			}
		}
		else ret = memory[DV_EQ][index][F_SEM] == DV_EQ? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pNE(int index){
		int ret = RS_FAIL;
		if(index < 0 || len <= index + 1) return ret;
		if(memory[DV_NE][index][F_SUF] == RS_UNUSED){
			memory[DV_NE][index][F_SUF] = RS_FAIL;
			memory[DV_NE][index][F_SEM] = RS_FAIL;
			if(input[index] == '!' && input[index + 1] == '='){
				ret = RS_SUCCESS; 
				memory[DV_NE][index][F_SUF] = index + 2;
				memory[DV_NE][index][F_SEM] = DV_NE;
			}
		}
		else ret = memory[DV_NE][index][F_SEM] == DV_NE? RS_SUCCESS : RS_FAIL;
		return ret;
	}


}
