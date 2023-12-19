//men83_lab4C
import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
		String str_explaination = "Hello user"+'\n'+
				"Welcome to my little game: ---- The right input ----"+'\n'+
				"The rules are simple! Just input a number between 30 and 40!"+'\n';
		String str_ask_user_input = "What's your number?";
		String str_wrong_answer= "Try again:\n";
		String str_correct_answer= "Correct!!!\n";
		int min_range = 30;
		int max_range = 40;
		boolean wrong = true;

		Scanner s = new Scanner(System.in);
		System.out.println(str_explaination);
		while(wrong){
			System.out.println(str_ask_user_input);
			int guess = s.nextInt();
			if(guess>min_range&&guess<max_range){
				System.out.println(str_correct_answer);
				wrong = false;
			}
			else {
			System.out.println(str_wrong_answer);
			}
		}
	}
}
