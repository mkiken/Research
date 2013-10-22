public class Let {
	static Func<Integer> cs;

	public static void main(String[] args) {
		doIt2();
	}

	//クロージャテスト
	static void doIt(){
		Integer a = new Func<Integer>() {
			//@Override
			int ff = 1000;
			public Integer call(int s, int t, int u) {
				return s+t+u+ff;
			}
		}.call(3, 4, 5);
		System.out.println(a);
	}

	static void doIt2(){
		final int ff = 20000; // need final!!!
		Func<Integer> f = new Func<Integer>() {
			//@Override
			//int ff = 1000;
			public Integer call(int s, int t, int u) {
				return s+t+u+ff;
			}
		};
		System.out.println(f.call(100,100,200));
	}

	interface Func<R> {
		R call(int s, int t, int u);
	}

}
