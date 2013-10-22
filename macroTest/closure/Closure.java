public class Closure {
	static Func<Integer> cs;

	public static void main(String[] args) {
		//doIt();
		//FGtest();
		//closure_extent();
		//cs.call();
		//closure_gc();
		//arrayTest();
		javaTest();
	}

	static void javaTest(){
		Integer a = 3;
		int b = 5;
		b = a;
		System.out.println(b);
	}

	static void arrayTest(){
		MakeClosure mc = new MakeClosure();
		int[] a = {0};
		Func<Integer> fc = mc.newClosureWithArary(a);
		fc.call();
		fc.call();
		System.out.println("a[0] = " + a[0]);
	}

	//1. クロージャーの呼び出しもとが無くなってもクロージャーが死なないか？(extent)
	// closure_extent
	//2. クロージャーはfirst-class objectか？
	// first-class object.
	//3. Garbage Collectionでしっかり消えるか？
	static void closure_gc(){
		prepare();
		System.gc();
		cs.call();
		System.gc();
		cs.call();
		System.gc();
		cs.call();
		System.gc();
		cs.call();
		System.gc();
		cs.call();
		System.gc();
	}


	//1. クロージャーの呼び出しもとが無くなってもクロージャーが死なないか？(extent)
	static void closure_extent(){
		prepare();
		cs.call();
		cs.call();
		cs.call();
		cs.call();
		cs.call();
	}
	//クロージャのextentは？？
	static void prepare(){
		IntHolder ih = new IntHolder(100);
		MakeClosure mc = new MakeClosure();
		cs = mc.f(ih);;
		ih = null; // nullにすると？？
		mc = null;
		//f(new IntHolder(100000)); //適当に違う値で作ってみる
	}

	/**

	   ↓こういうコードが実行出来るか？？
	   int f(int b){
	   int g(){
	   print b;
	   b++;
	   }
	   g();
	   b++;
	   g();
	   b++;
	   }
	   f(0);
	   g();
	   g();
	   f(100);
	   g();
	   g();
	**/
	static void FGtest(){
		System.out.println("FGTest invoked.");
		IntHolder a = new IntHolder(0);
		MakeClosure mc = new MakeClosure();
		Func<Integer> fc = mc.f(a);
		fc.call();
		fc.call();
		fc = mc.f(new IntHolder(100));
		fc.call();
		fc.call();
		System.out.println("FGTest end." + a.value);

	}


	//クロージャテスト
	static void doIt(){
		//Closure fib = new Closure();
		IntHolder c = new IntHolder(0);
		MakeClosure mc = new MakeClosure();
		//final IntHolder b = new IntHolder(1);
		Func<Integer> f = mc.newClosure(c);
		println(f.call(), f.call(), f.call(), f.call(), f.call(), f.call(), f.call(), f.call(), f.call());
		System.out.println();
	}

	private static void println(Integer ...integers) {
		for(Integer i : integers) {
			System.out.print(i);
			System.out.print(" ");
		}
	}

}

class IntHolder {
	public int value;
	public IntHolder(int value) {
		this.value = value;
	}
}

interface Func<R> {
	R call();
}

class MakeClosure{
	static Func<Integer> newClosureWithArary(final int[] a) {

		// インナークラスからの変数の参照はfinalのみ許可される。
		// インナークラスから値の更新を行えるようにオブジェクトでラップする。

		// ↓これがクロージャ
		return new Func<Integer>() {
			//@Override
			public Integer call() {
				a[0]++;
				return a[0];
			}
		};
	}
	static Func<Integer> newClosure(final IntHolder a) {

		// インナークラスからの変数の参照はfinalのみ許可される。
		// インナークラスから値の更新を行えるようにオブジェクトでラップする。

		// ↓これがクロージャ
		return new Func<Integer>() {
			//@Override
			public Integer call() {
				int fib = a.value + 1;
				a.value = fib;
				return fib;
			}
		};

	}
	static Func<Integer> f(final IntHolder b) {

		// インナークラスからの変数の参照はfinalのみ許可される。
		// インナークラスから値の更新を行えるようにオブジェクトでラップする。
		Func<Integer> fn = new Func<Integer>() {
			//@Override
			public Integer call() {
				int fib = b.value + 1;
				b.value = fib;
				System.out.println(b.value);
				return fib;
			}
		};
		System.out.println("f invoked.");
		fn.call();
		b.value++;
		fn.call();
		b.value++;
		System.out.println("f end.");
		// ↓これがクロージャ
		return fn;
	}
}
