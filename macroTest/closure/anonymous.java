public class anonymous {
	public static void main(String[] args) {
		doIt();
	}

	static void doIt() {
		System.out.println(new Object() {
			public int myTest(int a, int b) {
				return a + b;
			}
		}.myTest(3, 16));
	}
}
