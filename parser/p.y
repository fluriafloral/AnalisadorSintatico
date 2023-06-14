%{
#include <stdio.h>

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
%token <iValue> INTEGER
%token <fValue> FLOAT
%token <sValue> STRING
%token <sValue> TYPE
%token ADDITION SUBTRACTION MULTIPLICATION DIVISION REMAINDER
%token ASSIGN ADDITION_AND_ASSIGN SUBTRACTION_AND_ASSIGN MULTIPLICATION_AND_ASSIGN DIVISION_AND_ASSIGN REMAINDER_AND_ASSIGN
%token VAR WHILE FOR DO IF THEN ELSE FUNC RETURN
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET RIGHT_BRACKET LEFT_CURLYBRACKET RIGHT_CURLYBRACKET COLON COMMA END
%token EQUALS NOT NOT_EQUALS LESS_THAN LESS_THAN_OR_EQUALS_TO GREATER_THAN GREATER_THAN_OR_EQUALS_TO OR AND 

%start prog

%type <sValue> stm exprs expr logicExprs logicExpr prog 
%type <sValue> params param

%%
prog : stm      {}
     | stm prog {} 
	 ;

stm : assign                                          {printf("assign\n");}
    | exprs END                                       {printf("exprs\n");}
    | if_stm                                          {printf("if\n");}
    | func_stm                                        {printf("func\n");}
    | for_stm                                         {printf("for\n");}
    | while_stm                                       {printf("while\n");}
    ;

assign: VAR ID COLON TYPE ASSIGN exprs END            {printf("%s(%s) = %s\n", $2, $4, $6);}
      | ID ASSIGN exprs END                           {printf("%s = %s\n", $1, $3);}
      | ID ADDITION_AND_ASSIGN exprs END              {printf("%s += %s\n", $1, $3);}
      | ID SUBTRACTION_AND_ASSIGN exprs END           {printf("%s -= %s\n", $1, $3);}
      | ID MULTIPLICATION_AND_ASSIGN exprs END        {printf("%s *= %s\n", $1, $3);}
      | ID DIVISION_AND_ASSIGN exprs END              {printf("%s /= %s\n", $1, $3);}
      | ID REMAINDER_AND_ASSIGN exprs END             {printf("%s %= %s\n", $1, $3);}
      ;
    

if_stm : IF LEFT_PARENTHESIS logicExprs RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
       | IF logicExprs LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
       ;

func_stm: FUNC ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
        | FUNC ID COLON TYPE LEFT_PARENTHESIS params RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RETURN expr END RIGHT_CURLYBRACKET {}
        ;

for_stm: FOR                                                  {}
       ;

while_stm: WHILE                                              {}
         ;

params:                                                       {}
      | param                                                 {}
      | param COMMA params                                    {}
      ;

param : ID COLON TYPE                                         {}
      ;

exprs : expr                                                  {}
      | expr ADDITION exprs                                   {}
      | expr SUBTRACTION exprs                                {}
      | expr MULTIPLICATION exprs                             {}
      | expr DIVISION exprs                                   {}
      | expr REMAINDER exprs                                  {}
      ;

expr : ID      {$$ = $1;}
     | INTEGER {char * n = (char *) malloc(10);
               sprintf(n, "%i", $1);
               $$ = n;}
     | FLOAT   {char * n = (char *) malloc(10);
               sprintf(n, "%f", $1);
               $$ = n;}
     | STRING  {$$ = $1;}
     ;
     
logicExprs : logicExpr AND logicExprs                      {printf("and\n");}
           | logicExpr OR logicExprs                       {printf("or\n");}     
           | NOT logicExprs                                {}                     
           | logicExpr                                     {}
	       ;
	      
logicExpr : exprs EQUALS exprs                             {printf("%s == %s\n", $1, $3);}
          | exprs NOT_EQUALS exprs                         {printf("%s != %s\n", $1, $3);}
          | exprs GREATER_THAN exprs                       {printf("%s > %s\n", $1, $3);}
          | exprs GREATER_THAN_OR_EQUALS_TO exprs          {printf("%s >= %s\n", $1, $3);}
          | exprs LESS_THAN exprs                          {printf("%s < %s\n", $1, $3);}
          | exprs LESS_THAN_OR_EQUALS_TO exprs             {printf("%s <= %s\n", $1, $3);}
	    ;


%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
