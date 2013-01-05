package parser;

import java.util.Scanner;

/**
 * not LR(k) for any k
 * 
 * S	<- A | B
 * A	<- xAy | xzy
 * B	<- xByy | xzyy
 * 
 * 
 * */
public class PackratParser02 {
	static int[][][] memory; //[Derivs][LengthOfInput][Field]
	static char[] input;
	static int len = 0;

	//Constants for Derivs
	static final int NUM_DV = 3;
	static final int DV_S = 0;
	static final int DV_A = 1;
	static final int DV_B = 2;

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
	static String translateSV(int r){
		String ret = "";
		switch(r){
		case 0: ret = "INIT VALUE"; break;
		case DV_A: ret = "DV_A"; break;
		case DV_B: ret = "DV_B"; break;
		case -2: ret = "FAIL"; break;
		default: ret = String.valueOf(r);
		}
		return ret;
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
		memory = new int[NUM_DV][len][NUM_FIELD];
		System.out.println("input : " + str);
		int ret = pS(0);
		System.out.println("ret : " + translateRS(ret));
		System.out.println("semantic value : " + translateSV(memory[DV_S][0][F_SEM]));
		System.out.println("suffix value : " + translateRS(memory[DV_S][0][F_SUF]));
	}

	static int pS(int index){
		int ret = RS_FAIL;
		if(len <= index) return ret;
		if(memory[DV_S][index][F_SUF] == RS_UNUSED){
			memory[DV_S][index][F_SUF] = RS_FAIL;
			ret = pA(index); 
			if(ret == RS_SUCCESS && memory[DV_A][index][F_SUF] == RS_END){
				memory[DV_S][index][F_SEM] = memory[DV_A][index][F_SEM];
				memory[DV_S][index][F_SUF] = memory[DV_A][index][F_SUF];
			}
			else{
				ret = pB(index);
				memory[DV_S][index][F_SEM] = memory[DV_B][index][F_SEM];
				memory[DV_S][index][F_SUF] = memory[DV_B][index][F_SUF];
			}
		}
		else ret = (memory[DV_S][index][F_SUF] >= 0 || memory[DV_S][index][F_SUF] == RS_END)? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pA(int index){
		int ret = RS_FAIL;
		if(len <= index + 2) return ret;
		if(memory[DV_A][index][F_SUF] == RS_UNUSED){
			memory[DV_A][index][F_SUF] = RS_FAIL;
			memory[DV_A][index][F_SEM] = RS_FAIL;
			if(input[index] == 'x'){
				ret = pA(index + 1); 
				if(ret == RS_SUCCESS){
					int val = memory[DV_A][index + 1][F_SEM];
					int idx = memory[DV_A][index + 1][F_SUF];
					if(val == DV_A && idx != RS_END && idx < len){
						if(input[idx] == 'y'){
							idx++;
							memory[DV_A][index][F_SUF] = idx == len? RS_END : idx;
							memory[DV_A][index][F_SEM] = val;
						}
						else ret = RS_FAIL;
					}
					else ret = RS_FAIL;
				}
				else{
					if(input[index + 1] == 'z' && input[index + 2] == 'y'){
						memory[DV_A][index][F_SEM] = DV_A;
						memory[DV_A][index][F_SUF] = index + 3 == len? RS_END : index + 3;
						ret = RS_SUCCESS;
					}
				}
			}
		}
		else ret = memory[DV_A][index][F_SEM] == DV_A? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	static int pB(int index){
		int ret = RS_FAIL;
		if(len <= index + 3) return ret;
		if(memory[DV_B][index][F_SUF] == RS_UNUSED){
			memory[DV_B][index][F_SUF] = RS_FAIL;
			memory[DV_B][index][F_SEM] = RS_FAIL;
			if(input[index] == 'x'){
				ret = pB(index + 1); 
				if(ret == RS_SUCCESS){
					int val = memory[DV_B][index + 1][F_SEM];
					int idx = memory[DV_B][index + 1][F_SUF];
					if(val == DV_B && idx != RS_END && idx + 1 < len){
						if(input[idx] == 'y' && input[idx + 1] == 'y'){
							memory[DV_B][index][F_SUF] = idx + 2 == len? RS_END : idx + 2;
							memory[DV_B][index][F_SEM] = val;
						}
						else ret = RS_FAIL;
					}
					else ret = RS_FAIL;
				}
				else{
					if(input[index + 1] == 'z' && input[index + 2] == 'y' && input[index + 3] == 'y'){
						memory[DV_B][index][F_SEM] = DV_B;
						memory[DV_B][index][F_SUF] = index + 4 == len? RS_END : index + 4;
						ret = RS_SUCCESS;
					}
				}
			}
		}
		else ret = memory[DV_B][index][F_SEM] == DV_B? RS_SUCCESS : RS_FAIL;
		return ret;
	}


}
