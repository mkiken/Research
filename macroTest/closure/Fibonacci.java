public class Fibonacci {

	public static void main(String[] args) {
		Fibonacci fib = new Fibonacci();
		Func<Integer> f = fib.newFibonacci();
		println(f.call(), f.call(), f.call(), f.call(), f.call(), f.call(), f.call(), f.call(), f.call());
	}

	private static void println(Integer ...integers) {
		for(Integer i : integers) {
			System.out.print(i);
			System.out.print(" ");
		}
	}

	private class IntHolder {
		public int value;
		public IntHolder(int value) {
			this.value = value;
		}
	}

	public interface Func<R> {
		R call();
	}

	public Func<Integer> newFibonacci() {

		// インナークラスからの変数の参照はfinalのみ許可される。
		// インナークラスから値の更新を行えるようにオブジェクトでラップする。
		final IntHolder a = new IntHolder(0);
		final IntHolder b = new IntHolder(1);
		// ↓これがクロージャ
		return new Func<Integer>() {
			@Override
				public Integer call() {
				int fib = a.value + b.value;
				a.value = b.value;
				b.value = fib;
				return fib;
			}
		};
	}
}
