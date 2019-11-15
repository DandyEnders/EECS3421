
public class Tester {

	public static void main(String[] args) {
		System.out.println("abc");

		Assignment2 test = new Assignment2();
		boolean a = test.connectDB("jdbc:postgresql://db:5432", "howden2", "1");
		System.out.println(a == false);
		test.insertPlayer(1, "a", 1, 1);
		//work on this
	}
}
