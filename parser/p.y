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

%type <sValue> stm stmList expr logicExprs logicExpr 

%%
prog : stmList {} 
	 ;

stm :   VAR ID COLON TYPE ASSIGN expr                              {printf("var %s:%s = %s\n", $2, $4, $6);}
      | IF logicExprs LEFT_CURLYBRACKET stmList RIGHT_CURLYBRACKET {printf("if %s { %s }\n", $2, $4);}
	  ;
	
stmList : stm             {$$ = $1;}
		| stm END stmList {sprintf($$, "%s;\n%s", $1, $3);}
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
     
logicExprs : logicExpr                                     {$$ = $1;}
           | LEFT_PARENTHESIS logicExprs RIGHT_PARENTHESIS {$$ = $2;}
           | logicExpr AND logicExprs                      {sprintf($$, "%s and %s", $3, $1);}
           | logicExpr OR logicExprs                       {sprintf($$, "%s or %s", $3, $1);}
	       ;
	      
logicExpr : INTEGER EQUALS INTEGER       {char * n1 = (char *) malloc(10);
                                         char * n2 = (char *) malloc(10);
                                         sprintf(n1, "%d", $1);
                                         sprintf(n2, "%d", $3);
                                         char * str = malloc(sizeof(char) * sizeof(n1)+sizeof(n2)+6);
                                         sprintf(str,"%s == %s", n1, n2);
                                         free(n1);
                                         free(n2);
                                         $$ = str;}
          | INTEGER GREATER_THAN INTEGER {char * n1 = (char *) malloc(10);
                                         char * n2 = (char *) malloc(10);
                                         sprintf(n1, "%d", $1);
                                         sprintf(n2, "%d", $3);
                                         char * str = malloc(sizeof(char) * sizeof(n1)+sizeof(n2)+5);
                                         sprintf(str,"%s > %s", n1, n2);
                                         free(n1);
                                         free(n2);
                                         $$ = str;}
	      ;
	      
%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
