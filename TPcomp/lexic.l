%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "gram.tab.h"

extern YYSTYPE yylval;


 int lineno = 1; // initialize to 1
    int err_lex = 0;

%}


%option yylineno


DIGIT              [0-9]
LETTER            [a-zA-Z]
IDENTIFIER         ({LETTER})({LETTER}|{DIGIT}|_)*
IMPORT		   {IDENTIFIER}.h


MULTILINE          (<\/([^\/]|[\r\n]|(\/+([^>]|[\r\n])))*\/+>)


KEYWORD            "Str"|"Bool"|"void"|"BEGIN"|"END"|"return"|"function"|"~"|"LET"|"BE"|"?"|"from"|"to"|"with"|"as"|"repeat"|"putin"|"putout"|"typedef"|"TRUE"|"FALSE"            


WHITESPACE         [ \n\t]
STRING             (\")(.*)(\")

ARITHMETIC         "+"|"-"|"*"|"/"|"%"

SIGNS              "AND"|"OR"|"&"|"|"|">"|"<"|">="|"<="|"<-"|"&="|"="|")"|"("|"]"|"["|"}"|"["|"!"|","|"{"|"}"|":"        

FLOAT        [0-9]+\.[0-9]+

INTEGER      (\+|-)*{DIGIT}+

%%
"print"             //printList();
{KEYWORD}      {
                  if(!strcmp(yytext,"Num"))
                    return TOKEN_NUMTYPE;
                  else if(!strcmp(yytext,"Str"))
                   return TOKEN_STRTYPE ;
                  else if(!strcmp(yytext,"Bool"))
                     return TOKEN_BOOLTYPE ;
                  else if(!strcmp(yytext,"void"))
                 return TOKEN_VOIDTYPE;
                  else if(!strcmp(yytext,"BEGIN"))
                   return TOKEN_BEGIN ;
                  else if(!strcmp(yytext,"END"))
                 return TOKEN_END;
                  else if(!strcmp(yytext,"return"))
                  return  TOKEN_RETURN;
                  else if(!strcmp(yytext,"function"))
                    return TOKEN_FUNCTION;
                  else if(!strcmp(yytext,"~"))
                   return TOKEN_IMPORT;
                  else if(!strcmp(yytext,"LET"))
                  return TOKEN_LET;
		   else if(!strcmp(yytext,"BE"))
                   return TOKEN_BE;
                  else if(!strcmp(yytext,"?"))
                  return  TOKEN_INTEROGATION;
                  else if(!strcmp(yytext,"from"))
                   return TOKEN_FROM    ; 
                  else if(!strcmp(yytext,"to"))
                   return  TOKEN_TO;        
                  else if(!strcmp(yytext,"with"))
                   return TOKEN_WITH ;
                  else if(!strcmp(yytext,"as"))
                   return TOKEN_AS;
                  else if(!strcmp(yytext,"repeat"))
                   return  TOKEN_REPEAT;
                  else if(!strcmp(yytext,"putin"))
                   return TOKEN_PUTIN   ; 
                  else if(!strcmp(yytext,"putout"))
                   return  TOKEN_PUTOUT;
                  else if(!strcmp(yytext,"typedef"))
                   return TOKEN_TYPEDEF;
                  else if(!strcmp(yytext,"TRUE"))
                  return  TOKEN_TRUE ;
                  else if(!strcmp(yytext,"FALSE"))
                   return TOKEN_FALSE;
                  
               }
{IMPORT}         {
			return TOKEN_IMPORTID;
                     //insertFirst(yytext,"IMPORT");	
		}
{IDENTIFIER}   {
                  if(yyleng<32){
                   //  printf("\nTOKEN_ID %s",yytext);
                      return TOKEN_ID;
                //     insertFirst(yytext,"IDENTIFIER",50);
                     }
                  else{
                     printf("\nerror in line %d : identifier too long",yylineno);
                     return 1;
                  }
               }

{WHITESPACE}   {
                  
                   if(!strcmp(yytext,"\n")){
                    // printf("\nTOKEN_WHITESPACE	\\n");
                     lineno++;
                  }
               }

{MULTILINE}  { return TOKEN_MULT; }


{FLOAT}     { 
yylval.xfloat=atof(yytext);
//printf("\nvaleur réelle %f",yylval.xfloat);
return TOKEN_FLOAT;  }



{INTEGER}   { 
	yylval.xint=atoi(yytext);
   if(0<=yylval.xint<=32767){ 
    return TOKEN_INTEGER;   }

}

{STRING}       {  return TOKEN_STRINGCONST  ;}

{ARITHMETIC}   {  if(!strcmp(yytext,"+"))
                   return TOKEN_ADD ;
                   if(!strcmp(yytext,"-"))
                   return TOKEN_SUB ;
                   if(!strcmp(yytext,"*"))
                   return TOKEN_MULT ;
                   if(!strcmp(yytext,"/"))
                   return TOKEN_DIV ;} 
{SIGNS}        {
                  if(!strcmp(yytext,"AND"))
                   return TOKEN_ANDOP ;
                  else if(!strcmp(yytext,"OR"))
                  return   TOKEN_OROP;
                  else if(!strcmp(yytext,"&"))
                  return   TOKEN_NOTOP;
                  else if(!strcmp(yytext,"|"))
                  return  TOKEN_CHAMPOP;
                  else if(!strcmp(yytext,">"))
                  return   TOKEN_SUPOP;
                  else if(!strcmp(yytext,"<"))
                   return  TOKEN_INFOP;
                  else if(!strcmp(yytext,">="))
                  return  TOKEN_SUPEOP;
                  else if(!strcmp(yytext,"<="))
                  return  TOKEN_INFEOP ;
                  else if(!strcmp(yytext,"="))
                  return TOKEN_EQUALOP;
                  else if(!strcmp(yytext,"&="))
                   return TOKEN_NOTEQUALOP;
                  else if(!strcmp(yytext,"<-"))
                   return TOKEN_ASSIGNOP;
                  else if(!strcmp(yytext,")"))
                    return TOKEN_RIGHTPAREN ;
                  else if(!strcmp(yytext,"("))
                   return TOKEN_LEFTPAREN;
                  else if(!strcmp(yytext,"]"))
                   return TOKEN_RB ;
                  else if(!strcmp(yytext,"["))
                    return TOKEN_LB ;
                  else if(!strcmp(yytext,">"))
                    return TOKEN_RCB;
                  else if(!strcmp(yytext,"<"))
                   return TOKEN_LCB ;
                  else if(!strcmp(yytext,"!"))
                     return TOKEN_ENDINSTR;
                  else if(!strcmp(yytext,","))
                    return TOKEN_COMMA;
                  else if(!strcmp(yytext,"{"))
                  return   TOKEN_LTB;
                  else if(!strcmp(yytext,"}"))
                   return  TOKEN_RTB;
                  else if(!strcmp(yytext,":"))
                     return TOKEN_AFFECT;
                 
               }
        .                          { printf("\nERROR %s",yytext);}
%%
int yywrap(){
  
}

