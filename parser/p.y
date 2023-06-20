%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
    short  hValue;  /* short value */
	int    iValue; 	/* integer value */
    long   lValue; 	/* long value */
	float  fValue; 	/* float value */
    double dValue; 	/* double value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	};


%token <sValue> ID
%token <hValue> SHORT
%token <iValue> INTEGER
%token <lValue> LONG
%token <fValue> FLOAT
%token <dValue> DOUBLE
%token <sValue> STRING
%token <sValue> TYPE
%token ADDITION SUBTRACTION MULTIPLICATION DIVISION REMAINDER PLUS_PLUS MINUS_MINUS
%token ASSIGN ADDITION_AND_ASSIGN SUBTRACTION_AND_ASSIGN MULTIPLICATION_AND_ASSIGN DIVISION_AND_ASSIGN REMAINDER_AND_ASSIGN
%token VAR WHILE FOR DO IF THEN ELSE FUNC IN RETURN
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET RIGHT_BRACKET LEFT_CURLYBRACKET RIGHT_CURLYBRACKET COLON COMMA END
%token EQUALS NOT NOT_EQUALS LESS_THAN LESS_THAN_OR_EQUALS_TO GREATER_THAN GREATER_THAN_OR_EQUALS_TO OR AND 

%start prog

%type <sValue> stm exprs expr logicExprs logicExpr index prog primitive
%type <sValue> assign_params assign_param params

%%
prog : stm      {}
     | stm prog {} 
	 ;

stm :                                                 {} 
    | assign END                                      {printf("assign\n");}
    | exprs END                                       {printf("exprs\n");}
    | if_stm                                          {printf("if\n");}
    | func_stm                                        {printf("func\n");}
    | for_stm                                         {printf("for\n");}
    | while_stm                                       {printf("while\n");}
    | RETURN exprs END                                {}
    ;

assign: VAR ID COLON TYPE ASSIGN exprs                                    {printf("%s(%s) = %s\n", $2, $4, $6);}
      | VAR ID COLON TYPE ASSIGN LEFT_BRACKET index RIGHT_BRACKET         {printf("%s(%s) = []\n", $2, $4);}
      | ID LEFT_BRACKET exprs RIGHT_BRACKET ASSIGN expr                   {printf("%s[] = array\n", $1);}
      | ID ASSIGN exprs                                                   {printf("%s = %s\n", $1, $3);}
      | ID ADDITION_AND_ASSIGN exprs                                      {printf("%s += %s\n", $1, $3);}
      | ID SUBTRACTION_AND_ASSIGN exprs                                   {printf("%s -= %s\n", $1, $3);}
      | ID MULTIPLICATION_AND_ASSIGN exprs                                {printf("%s *= %s\n", $1, $3);}
      | ID DIVISION_AND_ASSIGN exprs                                      {printf("%s /= %s\n", $1, $3);}
      | ID REMAINDER_AND_ASSIGN exprs                                     {printf("%s mod = %s\n", $1, $3);}
      ;
    
index :                                             {}
      | exprs                                       {}
      | exprs COMMA index                           {}
      ;

if_stm : IF logicExprs LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
       | IF logicExprs LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET ELSE LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
       ;

func_stm: FUNC ID LEFT_PARENTHESIS assign_params RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
        | FUNC ID LEFT_PARENTHESIS assign_params RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RETURN exprs END RIGHT_CURLYBRACKET {}
        ;

for_stm: FOR LEFT_PARENTHESIS assign END logicExprs END exprs RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
       ;

while_stm: WHILE LEFT_PARENTHESIS logicExprs RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
         ;     

assign_params:                                                       {}
             | assign_param                                          {}
             | assign_param COMMA assign_params                      {}
             ;

assign_param : ID COLON TYPE                                  {}
      | ID COLON LEFT_BRACKET TYPE RIGHT_BRACKET              {}
      ;

params:                                                       {}
      | exprs                                                 {}
      | exprs COMMA params                                    {}
      ;

logicExprs : logicExpr AND logicExprs                      {printf("and\n");}
           | logicExpr OR logicExprs                       {printf("or\n");}
           | LEFT_PARENTHESIS logicExprs RIGHT_PARENTHESIS {}       
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

exprs : expr                                                  {$$ == $1;}
      | LEFT_PARENTHESIS exprs RIGHT_PARENTHESIS              {$$ == $2;}
      | expr ADDITION exprs                                   {$$ == $1;}
      | expr SUBTRACTION exprs                                {$$ == $1;}
      | expr MULTIPLICATION exprs                             {$$ == $1;}
      | expr DIVISION exprs                                   {$$ == $1;}
      | expr REMAINDER exprs                                  {$$ == $1;}
      | expr PLUS_PLUS                                        {$$ == $1;}
      | expr MINUS_MINUS                                      {$$ == $1;}
      ;

expr : ID      {$$ = $1;}
     | primitive {}
     | ID LEFT_BRACKET exprs RIGHT_BRACKET          {}
     | ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS {}
     ;

primitive : SHORT   {char * n = (char *) malloc(10);
                    sprintf(n, "%i", $1);
                    $$ = n;}
          | INTEGER {char * n = (char *) malloc(10);
                    sprintf(n, "%i", $1);
                    $$ = n;}
          | LONG    {char * n = (char *) malloc(10);
                    sprintf(n, "%ld", $1);
                    $$ = n;}
          | FLOAT   {char * n = (char *) malloc(10);
                    sprintf(n, "%f", $1);
                    $$ = n;}
          | DOUBLE  {char * n = (char *) malloc(10);
                    sprintf(n, "%f", $1);
                    $$ = n;}
          | STRING  {$$ = $1;}
          ;
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
