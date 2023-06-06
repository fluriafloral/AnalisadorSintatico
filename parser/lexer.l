%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern int yyerror (char *msg);  
%}

%%

[ \t\n]                         ;

"var"                           {return(VAR);}
"while"      			        {return(WHILE);}
"do"      				        {return(DO);}
"if"      				        {return(IF);}
"else"      			        {return(ELSE);}
"i32"                           {yylval.sValue = strdup("int"); 
                                return TYPE;}
"f32"                           {yylval.sValue = strdup("float"); 
                                return TYPE;}
"str"                           {yylval.sValue = strdup("string"); 
                                return TYPE;}

"("                             {return(LEFT_PARENTHESIS);}
")"                             {return(RIGHT_PARENTHESIS);}
"["                             {return(LEFT_BRACKET);}
"]"                             {return(RIGHT_BRACKET);}
"{"                             {return(LEFT_CURLYBRACKET);}
"}"                             {return(RIGHT_CURLYBRACKET);}
":"                             {return(COLON);}
","                             {return(COMMA);}
";"                             {return(END);}


"="					            {return(ASSIGN);}


"=="              		        {return(EQUALS);}
"!"                             {return(NOT);}
"!="                            {return(NOT_EQUALS);}
"<"                             {return(LESS_THAN);}
"<="		        		    {return(LESS_THAN_OR_EQUALS_TO);}
">"		        		        {return(GREATER_THAN);}
">="		        		    {return(GREATER_THAN_OR_EQUALS_TO);}
"or"		        		    {return(OR);}
"and"		        		    {return(AND);}

"for"                           {return(FOR);}
"while"                         {return(WHILE);}
"fn"                            {return(FUNC);}

[-+]?[0-9]+        	            {yylval.iValue = atoi(yytext); 
                                return INTEGER;}

[0-9]+|[-+]?[0-9]+\.?[0-9]*     {yylval.fValue = atof(yytext);
                                return FLOAT;}

[\"][a-zA-Z0-9]+[\"]            {yylval.sValue = strdup(yytext); 
                                return STRING;}
[\'][a-zA-Z0-9]+[\']            {yylval.sValue = strdup(yytext); 
                                return STRING;}

[a-zA-Z][a-zA-Z0-9]*	          {yylval.sValue = strdup(yytext); 
                                return ID;}

.                               {yyerror("invalid character");}

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif
