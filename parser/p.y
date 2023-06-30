%{
#include <stdio.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
     short  hValue;      /* short value */
	int    iValue; 	/* integer value */
     long   lValue; 	/* long value */
	float  fValue; 	/* float value */
     double dValue; 	/* double value */
	char   cValue; 	/* char value */
	char * sValue;      /* string value */
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

%type <sValue> stm exprs expr logicExprs logicExpr index prog primitive type
%type <sValue> assign_params assign_param params subprograms subprogram stms

%%
prog : subprograms {} 
     ;

subprograms : subprogram {}
            | subprogram subprograms {}
            ;

subprogram : stms {}
           ;

stms : stm       {}    
     | stm '' stms  {}
     ;

stm : init                                                                  {printf("init\n");}
    | assign                                                               {printf("assign\n");}
    | if_stm                                                                {printf("if\n");}
    | func_stm                                                              {printf("func\n");}
    | for_stm                                                               {printf("for\n");}
    | while_stm                                                             {printf("while\n");}
    ;

type : COLON TYPE                                                           {$$ = $2}

init : VAR ID type ASSIGN exprs END                                         {printf("%s(%s) = %s\n", $2, $3, $5);}
     | VAR ID type ASSIGN LEFT_BRACKET index RIGHT_BRACKET                  {printf("%s(%s) = []\n", $2, $3);}
     ;

assign : ID ADDITION_AND_ASSIGN exprs END                                      {printf("%s += %s\n", $1, $3);}
       | ID LEFT_BRACKET exprs RIGHT_BRACKET ASSIGN expr END                   {printf("%s[] = array\n", $1);}
       | ID ASSIGN exprs END                                                   {printf("%s = %s\n", $1, $3);}
       | ID SUBTRACTION_AND_ASSIGN exprs END                                   {printf("%s -= %s\n", $1, $3);}
       | ID MULTIPLICATION_AND_ASSIGN exprs END                                {printf("%s *= %s\n", $1, $3);}
       | ID DIVISION_AND_ASSIGN exprs END                                      {printf("%s /= %s\n", $1, $3);}
       | ID REMAINDER_AND_ASSIGN exprs END                                     {printf("%s mod= %s\n", $1, $3);}
       ;
    
index :                                                                     {}
      | exprs                                                               {}
      | exprs COMMA index                                                   {}
      ;

if_stm : IF logicExprs LEFT_CURLYBRACKET stms RIGHT_CURLYBRACKET            {}
       | IF logicExprs LEFT_CURLYBRACKET stms RIGHT_CURLYBRACKET ELSE LEFT_CURLYBRACKET stms RIGHT_CURLYBRACKET {}
       ;

func_stm : FUNC ID LEFT_PARENTHESIS assign_params RIGHT_PARENTHESIS LEFT_CURLYBRACKET stms RIGHT_CURLYBRACKET {}
         | FUNC ID LEFT_PARENTHESIS assign_params RIGHT_PARENTHESIS LEFT_CURLYBRACKET stms RETURN exprs END RIGHT_CURLYBRACKET {}
         ;

for_stm : FOR LEFT_PARENTHESIS assign END logicExprs END exprs RIGHT_PARENTHESIS LEFT_CURLYBRACKET stms RIGHT_CURLYBRACKET {}
        ;

while_stm : WHILE logicExprs LEFT_CURLYBRACKET stms RIGHT_CURLYBRACKET      {}
          ;     

assign_params:                                                              {}
             | assign_param                                                 {}
             | assign_param COMMA assign_params                             {}
             ;

assign_param : ID type                                                      {}
             | ID COLON LEFT_BRACKET TYPE RIGHT_BRACKET                     {}
             ;

params:                                                                     {}
      | exprs                                                               {}
      | exprs COMMA params                                                  {}
      ;

logicExprs : logicExpr AND logicExprs                                       {printf("and\n");}
           | logicExpr OR logicExprs                                        {printf("or\n");}
           | NOT logicExprs                                                 {}                     
           | logicExpr                                                      {}
	         ;
	      
logicExpr : expr EQUALS expr                                                {printf("%s == %s\n", $1, $3);}
          | expr NOT_EQUALS expr                                            {printf("%s != %s\n", $1, $3);}
          | expr GREATER_THAN expr                                          {printf("%s > %s\n", $1, $3);}
          | expr GREATER_THAN_OR_EQUALS_TO expr                             {printf("%s >= %s\n", $1, $3);}
          | expr LESS_THAN expr                                             {printf("%s < %s\n", $1, $3);}
          | expr LESS_THAN_OR_EQUALS_TO expr                                {printf("%s <= %s\n", $1, $3);}
          | LEFT_PARENTHESIS logicExprs RIGHT_PARENTHESIS                   {}       
	        ;

exprs : expr                                                                {}
      | expr ADDITION exprs                                                 {}
      | expr SUBTRACTION exprs                                              {}
      | expr MULTIPLICATION exprs                                           {}
      | expr DIVISION exprs                                                 {}
      | expr REMAINDER exprs                                                {}
      | expr PLUS_PLUS                                                      {}
      | expr MINUS_MINUS                                                    {}
      ;

expr : LEFT_PARENTHESIS exprs RIGHT_PARENTHESIS                             {}
     | ID                                                                   {$$ = $1;} 
     | primitive                                                            {}
     | ID dims                                                              {}
     | invoke                                                               {}
     ;

dims : dim                                                                  {}
     | dim dims                                                             {}
     ;

dim : LEFT_BRACKET exprs RIGHT_BRACKET                                      {}

invoke : ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS                       {}
       ;

primitive : SHORT   {char s = (char) $1;
                    char * n = (char *) malloc(strlen(&s));
                    sprintf(n, "%i", $1);
                    $$ = n;}
          | INTEGER {char i = (char) $1;
                    char * n = (char *) malloc(strlen(&i));
                    sprintf(n, "%i", $1);
                    $$ = n;}
          | LONG    {char l = (char) $1;
                    char * n = (char *) malloc(strlen(&l));
                    sprintf(n, "%ld", $1);
                    $$ = n;}
          | FLOAT   {char f = (char) $1;
                    char * n = (char *) malloc(strlen(&f));
                    sprintf(n, "%f", $1);
                    $$ = n;}
          | DOUBLE  {char d = (char) $1;
                    char * n = (char *) malloc(strlen(&d));
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
