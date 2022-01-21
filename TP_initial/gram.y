%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	//#include "sll.c"
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int err_lex;
	extern int yylex();
	void yyerror();
%}

/* token definition */
%token DIGIT LETTER MULTILINE KEYWORD WHITESPACE STRING ARITHMETIC SIGNS NUMBER TOKEN_VOIDTYPE
%token TOKEN_NUMTYPE TOKEN_STRTYPE TOKEN_BOOLTYPE VOIDTYPE TOKEN_BEGIN TOKEN_END TOKEN_RETURN TOKEN_FUNCTION TOKEN_IMPORT 
%token TOKEN_LET TOKEN_BE TOKEN_INTEROGATION TOKEN_FROM TOKEN_TO TOKEN_WITH TOKEN_AS TOKEN_REPEAT TOKEN_PUTIN TOKEN_PUTOUT TOKEN_TYPEDEF TOKEN_TRUE TOKEN_FALSE TOKEN_ELSE
%token TOKEN_IMPORTID TOKEN_ID IDENTIFIER TOKEN_WHITESPACE TOKEN_COMMENT 
%token TOKEN_NUMBERCONST TOKEN_STRINGCONST TOKEN_ARITHMATICOP TOKEN_NOTEQUALOP TOKEN_ASSIGNOP TOKEN_RIGHTPAREN TOKEN_LEFTPAREN TOKEN_RB TOKEN_LB
%token TOKEN_ANDOP TOKEN_OROP TOKEN_NOTOP TOKEN_CHAMPOP TOKEN_SUPOP TOKEN_INFOP TOKEN_SUPEOP TOKEN_INFEOP TOKEN_EQUALOP 
%token TOKEN_RCB TOKEN_LCB TOKEN_ENDINSTR TOKEN_COMMA TOKEN_LTB TOKEN_RTB TOKEN_AFFECT 
%token TOKEN_ADD TOKEN_SUB TOKEN_DIV TOKEN_MULT TOKEN_DOT

%start program

/* expression priorities and rules */

%%

program: structure { printf("\n FIN DE PROGRAMME AVEC SUCCESS \n");};

structure: import define declarations fonctions TOKEN_BEGIN TOKEN_LB declarations instructions TOKEN_RB TOKEN_END

/* DECLARATION */

import: import TOKEN_IMPORT TOKEN_IMPORTID TOKEN_ENDINSTR {printf("import avec succes ligne %d\n", lineno);}
| ;
define:   define TOKEN_LET TOKEN_ID TOKEN_BE TOKEN_NUMBERCONST TOKEN_ENDINSTR {printf("define avec succes ligne %d\n", lineno);}

        |
;
declarations: declarations declaration | declaration | /* vide */ ;

declaration: names TOKEN_AFFECT type TOKEN_ENDINSTR 				{printf(" declaration avec success a la ligne %d\n", lineno);}
	| TOKEN_TYPEDEF TOKEN_ID TOKEN_LB declarations TOKEN_RB TOKEN_ENDINSTR	{printf(" \n structure declaration avec success a la ligne %d\n", lineno);}
    |  names TOKEN_AFFECT type array TOKEN_ENDINSTR
;

type: TOKEN_NUMTYPE 		{ printf("\n number integer/float/double");}
	| TOKEN_STRTYPE 		{ printf("\n string ");}
	| TOKEN_BOOLTYPE 	{ printf("\n boolean");}
;


names: variable | names TOKEN_COMMA variable;

variable: TOKEN_ID | TOKEN_ID array ;

array: array TOKEN_INFOP TOKEN_SUPOP | TOKEN_INFOP TOKEN_SUPOP ;



/* FONCTIONS */
fonctions: fonctions fonction | fonction | /* vide */;

fonction: fonction_argument fonction_corps  {printf("\n fin d'implementation d'une fonction %d\n", lineno);};

fonction_argument: type_fonction TOKEN_ID TOKEN_LEFTPAREN parameteres TOKEN_RIGHTPAREN;

fonction_corps: TOKEN_LB declarations instructions TOKEN_RB;

type_fonction: TOKEN_FUNCTION type 	{printf("  : type de retour d'une fonction qui termine a la ligne %d\n", lineno);};
	|  TOKEN_VOIDTYPE			{printf("  \n void : type de retour d'une fonction qui termine a la ligne %d\n", lineno);};
;

parameteres: parameteres TOKEN_COMMA parametere | parametere | /* vide */;

parametere : type var {printf("  parametre d'une fonction a la ligne %d\n", lineno);};;

var : var TOKEN_COMMA parametere | variable ;


/* INSTRUCTIONS */
instructions: instructions instruction | instruction | /* vide */;

instruction:
	if_instruction		{printf("\n fin de if instruction a la ligne %d\n", lineno);}
	| while_instruction	{printf("\n fin de while instruction a la ligne %d\n", lineno);}
    | for_instruction	{printf("\n fin de for instruction a la ligne %d\n", lineno);}
    | repeat_instruction	{printf("\n fin de repeat instruction a la ligne %d\n", lineno);}
	| affectation 		{printf("\n assigment instruction a la ligne %d\n", lineno);}
	| TOKEN_RETURN type_return TOKEN_ENDINSTR	{printf("\n return instruction a la ligne %d\n", lineno);}
	| fonction_call TOKEN_ENDINSTR
	| write {printf("\n ecriture a la ligne %d\n", lineno);}
	| read{printf("\n lecture a la ligne %d\n", lineno);}
;

if_instruction: TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN TOKEN_INTEROGATION corps else;

else: TOKEN_ELSE TOKEN_INTEROGATION corps 	
	| /* vide */	
; 

while_instruction: TOKEN_REPEAT TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN TOKEN_LB corps TOKEN_RB ;

for_instruction: TOKEN_FROM TOKEN_ID TOKEN_EQUALOP TOKEN_NUMBERCONST  TOKEN_TO TOKEN_ID TOKEN_EQUALOP TOKEN_NUMBERCONST TOKEN_WITH TOKEN_ID TOKEN_ADD TOKEN_ADD TOKEN_LB corps TOKEN_RB ;

repeat_instruction: TOKEN_AS TOKEN_LB corps TOKEN_RB TOKEN_REPEAT TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN;

corps: instruction | TOKEN_LB instructions TOKEN_RB ;

expression:
    expression TOKEN_ADD expression 	
	|expression TOKEN_SUB expression 	
	|expression TOKEN_MULT expression 	
	|expression TOKEN_DIV expression 	
	|expression TOKEN_OROP expression 
	|expression TOKEN_ANDOP expression 
	|TOKEN_NOTOP expression 
	|expression TOKEN_EQUALOP expression 	
	|expression TOKEN_NOTEQUALOP expression 
	|expression TOKEN_SUPOP expression 
	|expression TOKEN_INFOP expression 
	|expression TOKEN_SUPEOP expression 
	|expression TOKEN_INFEOP expression 
	|TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN 
	|variable 	
	| 		TOKEN_NUMBERCONST			
	|fonction_call
    |write
    |read
    | table_call
	|struct_call	{printf("\n Acceder a un champ d'un enregistrement a la ligne %d\n", lineno);};
;


type_return :  TOKEN_STRINGCONST | TOKEN_TRUE| TOKEN_FALSE | expression ;

affectation: variable TOKEN_ASSIGNOP expression TOKEN_ENDINSTR ; 

fonction_call: TOKEN_ID TOKEN_LEFTPAREN call_parametres TOKEN_RIGHTPAREN		{printf("\n Appel d'une fonction a la ligne %d\n", lineno);};

call_parametres: call_parametre | /* vide */;

call_parametre : call_parametre TOKEN_COMMA variable | variable ;

struct_call : TOKEN_ID TOKEN_CHAMPOP variable TOKEN_ENDINSTR;

table_call:TOKEN_ID TOKEN_INFOP TOKEN_ID TOKEN_SUPOP TOKEN_ASSIGNOP expression TOKEN_ENDINSTR {printf("\n creation d un tableau avec succes a la ligne %d\n", lineno);};

write:TOKEN_PUTOUT TOKEN_LEFTPAREN TOKEN_STRINGCONST TOKEN_RIGHTPAREN TOKEN_ENDINSTR
        | TOKEN_PUTOUT TOKEN_LEFTPAREN variable TOKEN_RIGHTPAREN TOKEN_ENDINSTR;
read: TOKEN_PUTIN TOKEN_LEFTPAREN TOKEN_STRINGCONST TOKEN_RIGHTPAREN TOKEN_ENDINSTR
        | TOKEN_PUTIN TOKEN_LEFTPAREN variable TOKEN_RIGHTPAREN TOKEN_ENDINSTR;
%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[]){	


	// yyparse();
	// printf("Success");
	

	
	
	// parsing
	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();

	// if(err_lex == 1){printf("err lexicale");}
	// else{printf("Success de l'analyse lexicale");}

	fclose(yyin);
	
	
	
	
	return flag;
}
