%{
  #include <stdio.h>
  #include "p.tab.h"
  
  extern int yyerror (char *msg);  
%}

%%

[ \t\n]                         ;
"i16"                           {yylval.sValue = strdup("short"); 
                                return TYPE;}
"i32"                           {yylval.sValue = strdup("int"); 
                                return TYPE;}
"i64"                           {yylval.sValue = strdup("long"); 
                                return TYPE;}
"f32"                           {yylval.sValue = strdup("float"); 
                                return TYPE;}
"f64"                           {yylval.sValue = strdup("double"); 
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


"="					                    {return(ASSIGN);}


"=="              		          {return(EQUALS);}
"!"                             {return(NOT);}
"!="                            {return(NOT_EQUALS);}
"<"                             {return(LESS_THAN);}
"<="		        		            {return(LESS_THAN_OR_EQUALS_TO);}
">"		        		              {return(GREATER_THAN);}
">="		        		            {return(GREATER_THAN_OR_EQUALS_TO);}
"or"		        		            {return(OR);}
"and"		        		            {return(AND);}

"+" 			                 	  	{return(ADDITION);}
"++"			        	            {return(PLUS_PLUS);}
"+=" 			                 	  	{return(ADDITION_AND_ASSIGN);}
"-" 			                 	  	{return(SUBTRACTION);}
"--"			        	            {return(MINUS_MINUS);}
"-=" 			                  		{return(SUBTRACTION_AND_ASSIGN);}
"*" 			                  		{return(MULTIPLICATION);}
"*=" 			                 	  	{return(MULTIPLICATION_AND_ASSIGN);}
"/" 			                  		{return(DIVISION);}
"/=" 			                  		{return(DIVISION_AND_ASSIGN);}
"%" 			        	          	{return(REMAINDER);}
"%=" 			                    	{return(REMAINDER_AND_ASSIGN);}

"var"                           {return(VAR);}
"if"      				              {return(IF);}
"else"      			              {return(ELSE);}
"do"      				              {return(DO);}
"while"                         {return(WHILE);}
"for"                           {return(FOR);}
"fn"                            {return(FUNC);}
"in"                            {return(IN);}
"return"                        {return(RETURN);}

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
