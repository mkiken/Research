import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Scanner;
import java.util.Vector;

public class Q2131 {

	public static void main(String[] args) {
		doIt();
	}

	static void doIt(){
		Scanner sc = new Scanner(System.in);
		PrintWriter pw = new PrintWriter(System.out);
		int pm = (int)Math.sqrt(2.0e9) + 100;
		Vector<Integer> v = new Vector<Integer>();
		boolean[] primes = new boolean[pm];
		Arrays.fill(primes, true);
		primes[0] = primes[1] = false;
		for (int i = 2; i < pm; i++) {
			if(primes[i]){
				v.add(i);
				for (int j = i * 2; j < primes.length; j += i) primes[j] = false;
			}
		}
		//System.out.println(v.get(v.size() - 1));
		while(sc.hasNext()){
			int n  = sc.nextInt();
			int[] input = new int[n];
			int[] pused = new int[pm];
			boolean[] iused = new boolean[n];
			for(int i = 0; i < n; i++) input[i] = sc.nextInt();
			Arrays.sort(input);
			Arrays.fill(pused, -1);
			for (int i = 0; i < n; i++) {
				int t = input[i];
				//System.out.println("t = " + t);
				for (int j = 0; j < v.size(); j++) {
					int p = v.get(j);
					if(t < p) break;
					if(t % p == 0){
						//System.out.println("p = " + p);
						if(pused[p] != -1){
							iused[pused[p]] = true;
							iused[i] = true;
						}
						pused[p] = i;
						while(t % p == 0 && t != 0){
							t %= p;
						}
					}
				}
			}
			int ans = -1;
			for (int i = n - 1; 0 <= i; i--) {
				if(!iused[i]){ans = i;break;}
			}
			//pw.println(input[ans]);
			System.out.println(input[ans]);
		}
		//pw.close();
	}
}
