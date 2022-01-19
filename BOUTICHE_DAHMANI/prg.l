%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "prg.tab.h"
int c=0;
int l=0;
extern YYSTYPE yylval;
%}
idf [a-zA-Z]([a-zA-Z0-9]|_[a-zA-Z0-9])*
vide [ \s\t]+
cmnt "<<".+">>"
exp_cmp <|>|!=|>=|<=|==
entier 0|[1-9][0-9]*
reel ([1-9][0-9]*|[0-9])\.([1-9]|0[1-9])*
%%
"\n" {l++; c=0;}
{vide}     {c++;}



"Uint"   {printf("type \n");
c=c+strlen(yytext);  return UINT; }


"Ufloat" {printf("type \n");
c=c+strlen(yytext);  return UFLOAT; }

","       {printf("separateur\n");
c=c+strlen(yytext); return yytext[0];
}

"="       {printf("affectation\n");
c=c+strlen(yytext); return yytext[0];

}

"DEC" {printf("mot cle\n");
c=c+strlen(yytext);
return DEC;
}

"INST" {printf("mot cle :          DEBUT INST \n");
c=c+strlen(yytext);
return INST;
}

"IF"      {printf("mot cle\n");
c=c+strlen(yytext); return IF;
}

"ELSE"    {printf("mot cle\n");
c=c+strlen(yytext); return ELSE; }

"FINIF"   {printf("mot cle\n");
c=c+strlen(yytext); return FINIF; }

"FOR"     {printf("mot cle\n");
c=c+strlen(yytext); return FOR; }

"ENDFOR"  {printf("mot cle \n");
c=c+strlen(yytext); return ENDFOR; }
"ENDIF" {printf("mot cle\n");
c=c+strlen(yytext); return ENDIF; }
"FIN" {printf("mot cle\n");
c=c+strlen(yytext);  return FIN; 
}

"define"  {printf("mot cle\n");
c=c+strlen(yytext); return DEFINE; }

"("       {printf("sep\n");
c=c+strlen(yytext); return yytext[0]; }

")"       {printf("sep\n");
c=c+strlen(yytext); return yytext[0]; }

";"       {printf("pv\n");
c=c+strlen(yytext); return yytext[0]; }

"/"       {printf("op\n");
c=c+strlen(yytext); return DIV; }

"+"       {printf("op\n");
c=c+strlen(yytext); return PLUS; }


"-"       {printf("op\n");
c=c+strlen(yytext); return MOINS; }

"*"       {printf("exp_art\n");
c=c+strlen(yytext); return PRODUIT; }

"|"       {printf("exp_log\n");
c=c+strlen(yytext); return OU; }

"&" {printf("exp_log\n");
c=c+strlen(yytext); return ET; }

"!" {printf("exp_log\n"); return NE;
c=c=strlen(yytext); }

{cmnt}    {printf("commentaire \n");
c=c+strlen(yytext); }

{exp_cmp} {printf("exp_comp\n");
c=c+strlen(yytext); yylval.chaine=strdup(yytext); return EXP_CMP; }



  
{reel} {c=c+strlen(yytext); 
yylval.Ufloat=atof(yytext);
printf("reel \n");
return REEL;
}
	
{entier}  {c=c+strlen(yytext); 
	yylval.Uint=atoi(yytext);
	if(0<=yylval.Uint<=32767){ printf("valeur entier\n"); return ENTIER; }
	else printf("ERORR entier tres grand ligne: %d colone: %d",l,c);}


	

{idf}     {c=c+strlen(yytext); 
yylval.chaine=strdup(yytext);
if(strlen(yytext)<=7){printf("IDF detecte\n"); return IDF;}
else printf("ERORR IDF tros long ligne ; %d colone %d : \n",l,c);
}	
.         {printf("ERORR LEXICAL PAS VALIDE ligne: %d et colone: %d\n ",l,c);}

%%
//problem ta3 l REEL





/*
int main()
{
yylex();
return 0;
}


int yywrap()
{
return 0;
}
*/

