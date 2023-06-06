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
%token VAR WHILE DO IF THEN ELSE
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET RIGHT_BRACKET LEFT_CURLYBRACKET RIGHT_CURLYBRACKET COLON COMMA END
%token ASSIGN EQUALS NOT NOT_EQUALS LESS_THAN LESS_THAN_OR_EQUALS_TO GREATER_THAN GREATER_THAN_OR_EQUALS_TO OR AND 

%start prog

%type <sValue> stm expr logicExprs logicExpr prog 

%%
prog : stm      {}
     | stm prog {} 
	 ;

stm : VAR ID COLON TYPE ASSIGN expr END {printf("assign %s(%s) = %s\n", $2, $4, $6);}
    | if_stm                            {printf("if\n");}
	;

if_stm : IF LEFT_PARENTHESIS logicExprs RIGHT_PARENTHESIS LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
       | IF logicExprs LEFT_CURLYBRACKET prog RIGHT_CURLYBRACKET {}
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
           | logicExpr                                     {}
	       ;
	      
logicExpr : expr EQUALS expr       {printf("%s == %s\n", $1, $3);}
          | expr GREATER_THAN expr {printf("%s >= %s\n", $1, $3);}
	      ;
	      
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
