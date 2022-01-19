%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "liste.h"
#include "quad.h"
#include "pile.h"
//#define YYDEBUG 1

Elmt tete;
quad q;
int cmp=0;
char ch[10];
char t3[10];
int t;
int qc=0;
int buffer; //le quad a buffer
int br; //the quad that we want to jump in to it  
extern FILE* yyin ; /*fichier contenant le code à compiler*/
int yylex();
int yyerror();
int yywrap();
pile p1,p2; //pour le IF
pile p3; //pour le FOR
pile p4,p5;


%}


%union
{
char *chaine;
char ch[50];
char carac;
float Ufloat;
int Uint;
struct { char *val; int type;}VT;
}


%token VIDE DEC INST UINT UFLOAT CMNT VIRGUL IF ELSE FOR ENDFOR ENDIF FINIF DEFINE FIN 
%token DIV MOINS PLUS OU PRODUIT ET NE
%token<Ufloat> REEL
%token<Uint> ENTIER
%token<chaine> EXP_CMP
%type<chaine> Exp_cmp
%token<chaine> IDF
%left OU
%left ET
%left NEF
%left EXP_CMP
%left PLUS MOINS
%left MUL DIV
%type<Uint> Type
%type<Uint> Sdv
%type<VT> Term
%type<chaine> Exp_log
%type<VT> Exp_ar
%type<chaine> Op
%type<chaine> Cdt

%%
/*tous les tokens sont on majuscules et les nonterminaux commence avec une lettre majuscule */
Debut:Nom_prgm DEC S FIN{printf("programme termine\n");
printf("la table des symboles: \n"); affiche_liste(tete); affiche_q(q); exit(0); }
;


S:Dec S  | INST S2_Insts




S2_Insts:Inst S2_Insts |Inst
//Inst {printf(" Inst accp\n");}
;  

Dec:DV {printf("c'une DV\n");} | DC{printf("DC accp\n");}
;
/*
nature de idf  0 = vr , 1 = const
*/

DV:Type IDF Sdv {
$3 = $1;
if(recherche(tete,$2)==1) {tete=inser(tete,$2,$1,0);}
else printf(" %s: idf existe deja\n",$2);
}

//structure Elmt inser(Elmt tete,char val[20],int type,int nature)



/*suite dec des verlbs */
	
Sdv:','IDF Sdv
{if(recherche(tete,$2)== 1) tete=inser(tete,$2,$3,0);
else printf(" %s: idf existe déja\n",$2); 
} 
| ';' {}
;


DC:DEFINE UFLOAT IDF '=' REEL{
} ';' {
if(recherche(tete,$3) == 1)
tete=inser(tete,$3,1,1);
else printf(" %s: idf existe déja\n",$3);
}
|
DEFINE UINT IDF '=' ENTIER ';'
{
if(recherche(tete,$3) == 1)
tete=inser(tete,$3,0,1);
else printf(" %s: idf existe déja\n",$3);
}

;


/* loop it */
Inst: Aff ';' |Cond | Boucle
;


Boucle:FOR '(' Aff  ';' {} '('  {empiler(&p5,qc);}Exp_cmp')' {
q=inser_q(q,"BZ","",strdup($8),"",qc);
empiler(&p4,qc);
}
';' {
qc++;
 }
Aff {}
')'
S2_Insts{

buffer=desempiler(&p5);
  sprintf(ch,"%d",buffer);
q=inser_q(q,"BR",strdup(ch),"","",qc); qc++;

buffer=desempiler(&p4);
sprintf(ch,"%d",qc);
q=mise_a_jour(q,buffer,strdup(ch));

}
ENDFOR
;

/*
iner q_init
inser q_aff
*/


//type  0 = Uint ,1 = Ufloat
Aff: IDF '=' Exp_ar {

if(recherche(tete,$1) == 1)
printf("le idf %s n'existe pas\n",$1);
else
{if(return_nature(tete,strdup($1)) == 1) //cad constant
printf("\nERORR on peut pas affecté une constant\n");
else//insersion de quad  
{
//verifer compt de type .
printf("  comparer avec %d \n",$3.type);
if(return_type(tete,strdup($1))!=$3.type)
{printf("\nERoRR: incompatibilite des types\n");
}
else q=inser_q(q,"=",$3.val," ",$1,qc++);

//}



}


}


} 
;


Exp_ar: Term Op Exp_ar {
char t[10]; sprintf(t,"T%d",cmp);
cmp++;
//if($1.type != $3.type ) $$.type=1; //Ufloat
//else
 $$.type=$1.type;

q=inser_q(q,$2,$3.val,$1.val,t,qc++);
$$.val=strdup(t) ;
}
  | Term {strcpy($$.val,$1.val); $$.type=$1.type;}
;





Op:PLUS { $$=strdup("+");}|
MOINS{$$=strdup("-");}
|PRODUIT{$$=strdup("*");}
|DIV{$$=strdup("/");}
;




// 0=Uint 1=Ufloat
Term:ENTIER  { $$.type=0;
   
 char t[10]; sprintf(t,"%d",$1);  $$.val=strdup(t);

}
|
REEL {
$$.type=1;
char t2[10]; sprintf(t2,"%f",$1);  $$.val=strdup(t2);
 } 

|
IDF {
if(recherche(tete,$1) == 1) printf("le idf %s n'existe pas\n",$1);
else 
{
$$.type=return_type(tete,strdup($1));

}
}
;


//la forme {char t[10]; sprintf(t,"%d",$1); $$=strdup(t);}

Cond:IF '(' Cdt {
q=inser_q(q,"BZ","",$3,"",qc);
empiler(&p1,qc); qc++;
/*ajouter la  pile*/
}
')' S2_Insts {
q=inser_q(q,"BR","","","",qc);
empiler(&p2,qc); qc++;
/*jump to the end*/} 
ELSE{
sprintf(ch,"%d",qc);
buffer=desempiler(&p1);

q=mise_a_jour(q,buffer,strdup(ch));
}
 S2_Insts 
{ sprintf(ch,"%d",qc);
buffer=desempiler(&p2);
mise_a_jour(q,buffer,strdup(ch)); }
ENDIF 
{ 
}

/*ex td:
if a <> b then b = b*a else c = a*c
1-(BE,else,a,b) 2-(*,b,a,T1) 
3-(=,T1,,,b)  4-(BE,fin, , )
5-(*,a,c,T2)   6-(=,T2,,c)   6-()
*/ 
;

Cdt: Exp_log {}|Exp_cmp{$$=$1;}
;


/*
char t[10]; sprintf(t,"T%d",cmp);
cmp++;

q=inser_q(q,$2,$3,$1,t,qc++);
$$=strdup(t) ;
*/



Exp_log: '(' Exp_cmp ')'
{

q=inser_q(q,"BNZ","",$2,"",qc); empiler(&p4,qc);
qc++; }


 OU Exp_log 
{
q=inser_q(q,"BNZ","",strdup($6),"",qc); empiler(&p4,qc);  qc++;
sprintf(t3,"T%d",cmp);
cmp++;

$$=strdup(t3);

q=inser_q(q,"=","0","",t3,qc);   qc++;
sprintf(ch,"%d",qc+2);
q=inser_q(q,"BR",ch,"","",qc); qc++;

q=inser_q(q,"=","1","",t3,qc); 
 
buffer=desempiler(&p4);
sprintf(ch,"%d",qc);
q=mise_a_jour(q,buffer,strdup(ch));
buffer=desempiler(&p4);
q=mise_a_jour(q,buffer,strdup(ch));

qc++;


}
| '(' Exp_cmp ')' {$$=strdup($2);}

 
|


'(' Exp_cmp ')' 
{q=inser_q(q,"BZ","",$2,"",qc); empiler(&p4,qc);
qc++; }


ET  Exp_log {

q=inser_q(q,"BZ","",strdup($6),"",qc); empiler(&p4,qc);  qc++;
sprintf(t3,"T%d",cmp);
cmp++;

$$=strdup(t3);

q=inser_q(q,"=","1","",t3,qc);   qc++;
sprintf(ch,"%d",qc+2);
q=inser_q(q,"BR",ch,"","",qc); qc++;

q=inser_q(q,"=","0","",t3,qc); 
 
buffer=desempiler(&p4);
sprintf(ch,"%d",qc);
q=mise_a_jour(q,buffer,strdup(ch));
buffer=desempiler(&p4);
q=mise_a_jour(q,buffer,strdup(ch));

qc++;


}
;
Nom_prgm:IDF {}
;


/*
Vl_log: OU | ET
;
*/





Exp_cmp:Exp_ar EXP_CMP Exp_ar{
printf("exp_cmp = %s\n",$2);



//q=inser_q(q,"-",$1,$3,strdup(t),qc);
//qc++;

if (strcmp($2, "<") == 0) 
{
q=inser_q(q,"BGE","",$1.val,$3.val,qc);

}
else if (strcmp($2, ">") == 0)
{
  q=inser_q(q,"BLE","",$1.val,$3.val,qc);
}
else if (strcmp($2, "!=") == 0)
{
  q=inser_q(q,"BE","",$1.val,$3.val,qc);
}
else if (strcmp($2, ">=") == 0)
{
 q=inser_q(q,"BL","",$1.val,$3.val,qc);
}
else if (strcmp($2, "<=") == 0)
{
q=inser_q(q,"BG","",$1.val,$3.val,qc);
}
else if (strcmp($2, "==") == 0)
{
q=inser_q(q,"BNE","",$1.val,$3.val,qc);
}


sprintf(t3,"T%d",cmp); cmp++;
qc++;

q=inser_q(q,"=","1","",strdup(t3),qc);
qc++;
sprintf(ch,"%d",qc+2); 
q=inser_q(q,"BR",strdup(ch),"","",qc);  qc++;
q=inser_q(q,"=","0","",strdup(t3),qc); 
sprintf(ch,"%d",qc);
q=mise_a_jour(q,qc-3,ch);
$$=strdup(t3);

qc++;

}

;


Type:UINT {$$=0;}| UFLOAT {$$=1;}
;



%%
int yyerror(char *msg)
{
printf("%s",msg);
return 1;
}

int main()
{
//yydebug=1;
yyin=fopen("code2.txt","r");
yyparse();
return 0;
}

int yywrap()
{
return 0;
}


//compatibilité de type 
//compatibilité de changement de constant 
//double declaration 
//non declaration 
//





