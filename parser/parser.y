%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; 	/* integer value */
	float  fValue; 	/* float value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	};

%token <sValue> ID
%token <sValue> TYPE
%token <sValue> VAR
%token <sValue> STRING
%token <iValue> INTEGER
%token <fValue> FLOAT
%token EQUALS NOT NOT_EQUALS LESS_THAN LESS_THAN_OR_EQUALS_TO GREATER_THAN GREATER_THAN_OR_EQUALS_TO OR AND
%token WHILE DO IF ELSE ASSIGN

%type <sValue> if

%type <sValue> id assign
%type <sValue> literal_string literal_integer literal_float
%type <sValue> stmts stmt
%type <sValue> logicExps logicExp

%start program

%%
program : stmts                                                            {printf("%s\n", $1);
                                                                           free($1);}
        ;

stmts :                                                                    {$$ = strdup("");} 
      | stmt stmts                                                         {int n1 = strlen($1);
                                                                           int n2 = strlen($2);
                                                                           char * s = malloc(sizeof(char)*(n1+n2+2));
                                                                           sprintf(s, "%s\n%s", $1, $2);
                                                                           free($1);
                                                                           free($2);
                                                                           $$ = s;} 
      ;

stmt : assign                                                              {}
     | if                                                                  {$$ = $1;}
     ;

if : IF logicExps '{' stmts '}'                                            {printf("IF\n")}
   ;

logicExps : '('logicExps')'                                                {}
          | logicExp                                                       {}
          | logicExps OR logicExp                                          {printf("or\n");}
          | logicExps AND logicExp                                         {printf("and\n");}
          ;

logicExp : NOT id                                                          {printf("!\n");}
         | id EQUALS id                                                    {printf("=\n");}
         | id NOT_EQUALS id                                                {printf("!=\n");}
         | id GREATER_THAN id                                              {printf(">\n");}
         | id GREATER_THAN_OR_EQUALS_TO id                                 {printf(">=\n");}
         | id LESS_THAN id                                                 {printf("<\n");}
         | id LESS_THAN_OR_EQUALS_TO id                                    {printf("<=\n");}
         ;


assign : VAR ID ':' TYPE ASSIGN id ';'                                     {}
       ;


id : literal_string                                                        {printf("%s\n", $1);}
   | literal_integer                                                       {printf("%i\n", $1);}
   | literal_float                                                         {printf("%f\n", $1);}
   ;


literal_string : STRING                                                    {}
               ;

literal_integer : INTEGER                                                  {}
                ;

literal_float : FLOAT                                                      {}
              ;

%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}