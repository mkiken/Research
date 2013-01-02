package parser;

import java.util.Scanner;

/**
 * Grammar for a trivial language
 * 
 * Additive		<- Multitive '+' Additive | Multitive
 * Multitive	<- Primary '*' Multitive | Primary
 * Primary		<- '(' Additive ')' | Decimal
 * Decimal		<- '0' | ... | '9'
 * 
 * 
 * */
public class PackratParser01 {
	static int[][][] memory; //[Derivs][LengthOfInput][Field]
	static char[] input;
	static int len = 0;

	//Constants for Derivs
	static final int NUM_DV = 4;
	static final int DV_ADD = 0;
	static final int DV_MUL = 1;
	static final int DV_PRI = 2;
	static final int DV_DEC = 3;

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
		memory = new int[NUM_DV][len][NUM_FIELD];
		System.out.println("input : " + str);
		int ret = pAdditive(0);
		System.out.println("ret : " + translateRS(ret));
		System.out.println("semantic value : " + memory[DV_ADD][0][F_SEM]);
		System.out.println("suffix value : " + translateRS(memory[DV_ADD][0][F_SUF]));
	}

	static int pAdditive(int index){
		int ret = RS_FAIL;
		if(len <= index) return ret;
		if(memory[DV_ADD][index][F_SUF] == RS_UNUSED){
			memory[DV_ADD][index][F_SUF] = RS_FAIL;
			ret = pMultitive(index); 
			if(ret == RS_SUCCESS){
				int val = memory[DV_MUL][index][F_SEM];
				int idx = memory[DV_MUL][index][F_SUF];
				if(idx != RS_END && input[idx] == '+'){
					idx++;
					ret = pAdditive(idx); 
					if(ret == RS_SUCCESS){
						memory[DV_ADD][index][F_SUF] = memory[DV_ADD][idx][F_SUF];
						memory[DV_ADD][index][F_SEM] = val + memory[DV_ADD][idx][F_SEM];
					}
				}
				else{
					memory[DV_ADD][index][F_SUF] = idx;
					memory[DV_ADD][index][F_SEM] = val;
				}
			}
		}
		else ret = (memory[DV_ADD][index][F_SUF] >= 0 || memory[DV_ADD][index][F_SUF] == RS_END)? RS_SUCCESS : RS_FAIL;
		return ret;
	}

	static int pMultitive(int index){
		int ret = RS_FAIL;
		if(len <= index) return ret;
		if(memory[DV_MUL][index][F_SUF] == RS_UNUSED){
			memory[DV_MUL][index][F_SUF] = RS_FAIL;
			ret = pPrimary(index); 
			if(ret == RS_SUCCESS){
				int val = memory[DV_PRI][index][F_SEM];
				int idx = memory[DV_PRI][index][F_SUF];
				if(idx != RS_END && input[idx] == '*'){
					ret = pMultitive(idx + 1);
					if(ret == RS_SUCCESS){
						idx++;
						memory[DV_MUL][index][F_SUF] = memory[DV_MUL][idx][F_SUF];
						memory[DV_MUL][index][F_SEM] = val * memory[DV_MUL][idx][F_SEM];
					}
				}
				else{
					memory[DV_MUL][index][F_SUF] = idx;
					memory[DV_MUL][index][F_SEM] = val;
				}
			}
		}
		else ret = (memory[DV_MUL][index][F_SUF] >= 0 || memory[DV_MUL][index][F_SUF] == RS_END)? RS_SUCCESS : RS_FAIL;
		return ret;
	}

	static int pPrimary(int index){
		int ret = RS_FAIL;
		if(len <= index) return ret;
		if(memory[DV_PRI][index][F_SUF] == RS_UNUSED){
			memory[DV_PRI][index][F_SUF] = RS_FAIL; 
			if(index < len){
				if(input[index] == '('){
					int idx = index + 1;
					ret = pAdditive(idx);
					if(ret == RS_SUCCESS){
						int idx2 = memory[DV_ADD][idx][F_SUF];
						if(idx2 != RS_END && idx2 < len && input[idx2] == ')'){
							idx2++;
							memory[DV_PRI][index][F_SUF] = idx2 < len? idx2 : RS_END;
							memory[DV_PRI][index][F_SEM] = memory[DV_ADD][idx][F_SEM];
						}
						else ret = RS_FAIL;
					}
				}
				else{
					ret = pDecimal(index);
					if(ret == RS_SUCCESS){
						memory[DV_PRI][index][F_SEM] = memory[DV_DEC][index][F_SEM];
						memory[DV_PRI][index][F_SUF] = memory[DV_DEC][index][F_SUF];
					}
				}
			}
		}
		else ret = (memory[DV_PRI][index][F_SUF] >= 0 || memory[DV_MUL][index][F_SUF] == RS_END)? RS_SUCCESS : RS_FAIL;
		return ret;
	}
	
	static int pDecimal(int index){
		int ret = RS_FAIL;
		if(len <= index) return ret;
		if(memory[DV_DEC][index][F_SUF] == RS_UNUSED){
			memory[DV_DEC][index][F_SUF] = RS_FAIL; 
			if(index < len){
				if('0' <= input[index] && input[index] <= '9'){
					memory[DV_DEC][index][F_SEM] = input[index] - '0';
					if(index + 1 == len) memory[DV_DEC][index][F_SUF] = RS_END;
					else memory[DV_DEC][index][F_SUF] = index + 1;
					ret = RS_SUCCESS;
				}
			}
		}
		else ret = (memory[DV_DEC][index][F_SUF] >= 0 || memory[DV_DEC][index][F_SUF] == RS_END)? RS_SUCCESS : RS_FAIL;
		return ret;
	}

}
