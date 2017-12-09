#include <string.h> /* import for use of strcmp, strcpy */
#include <ctype.h> /* import tolower function */
#include <stdio.h>
#include <emscripten/emscripten.h>

/* function prototype declaration for the function menu */
int menu();

int main(int argc, char ** argv) {
  printf ("\n Welcome to the quiz!\n");
  menu();
  printf ("\n\n Thanks for playing.\n");
  return 0;
}

/*
 * Function: menu
 * ----------------------------
 *   Returns the user input selection from the menu items shown.
 * 
 *   Reads a line from the standard user input (STDIN), 
 *   where sizeof is the maximum allowable characters to be 
 *   read, including the end-of-line (EOL) character.
 *   Store the input from the user in the answer variable
 *
 *   No arguments 
 *
 *   returns: the user input 
 */
int EMSCRIPTEN_KEEPALIVE menu() {
  char line[100];               /* specify the line that is to be read from the user input terminal */
  int menu_user_input_latest;   /* an integer chosen by the user */

  menu_user_input_latest = -1;  /* set answer to a value that falls through */
  while (menu_user_input_latest != 0) {
    printf ("\n Menu:");
    printf ("\n   - Quiz 1: WebAssembly programming language quiz\n");
    printf ("\n What quiz number do you want to play? [Press 0 to exit] ");
    printf("\n >>> ");
    fgets (line, sizeof(line), stdin); /* read in a line */
    int menu_user_input = sscanf (line, "%d", &menu_user_input_latest); /* scan the line for an integer */
    if ((menu_user_input == 0) | (menu_user_input == EOF)) {
      /* either a non-integer or EOL character entered */
      printf ("\n ** Warning: You have to enter an integer ***\n");
      menu_user_input_latest = -1; /* set answer to a value that falls through */
    } else {
      menu_user_input_latest = menu_user_input;
    }
      
    char quiz_answer_user_input[100];
    char quiz_answer_user_input_latest[100];
    
    switch (menu_user_input_latest) {
      case 0:
        break;
      case 1:
        strcpy(quiz_answer_user_input_latest, ""); /* assign to array of characters */
        // FIXME - `Segmentation fault: 11` when use: `putchar(tolower(quiz_answer_user_input_latest))`
        while (strcmp(quiz_answer_user_input_latest, "wasm") != 0) {
          printf ("\n What is the four letter abbreviation for WebAssembly? [0 to exit]");
          printf("\n >>> ");
          // fgets (line, sizeof(line), stdin);
          // strcpy(quiz_answer_user_input, sscanf (line, "%s", *quiz_answer_user_input_latest));
          // scanf("%[^\n]", &quiz_answer_user_input_latest); /* scan whole string including whitespaces */
          fgets(quiz_answer_user_input_latest, sizeof(quiz_answer_user_input_latest), stdin);
          if (strcmp(quiz_answer_user_input_latest, "0\n") == 0) {
            menu_user_input_latest = 0; /* allow exit */
            break;
          }
          strcpy(quiz_answer_user_input, quiz_answer_user_input_latest);
          if (strcmp(quiz_answer_user_input, "wasm\n") == 0) {
            printf ("\n Correct!\n");
            menu_user_input_latest = 0; /* allow exit */
            break;
          } else {
            printf ("\n Wrong. Try again!\n");
            strcpy(quiz_answer_user_input_latest, quiz_answer_user_input);
          }
        }
        break;
      default: /* keep prompting the user if answer is not 0 or 1 */
        break;
    }
  }
  return menu_user_input_latest;
}
