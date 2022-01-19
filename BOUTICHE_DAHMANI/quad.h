#include <stdio.h>
#include <stdlib.h>
#include <string.h>




struct elt
{   
    char oper[50];   
	char op1[50];   //opérande 1
	char op2[50];   //opérande 2
	char res[50];   //Resultat
	int qc;    //le numero de quad
    struct elt *Suivant;//chainage
};
typedef struct elt elt;
typedef elt* quad;
//Fonctions 
quad Teteq(char opr[],char opr1[],char opr2[],char re[],int n)
{
     quad nouv;
// On cree un nouvel element 
nouv = malloc(sizeof(elt));
	strcpy(nouv->oper,opr);
	strcpy(nouv->op1,opr1);
	strcpy(nouv->op2,opr2);
	strcpy(nouv->res,re);
	nouv->qc=n;

nouv->Suivant = NULL;
						return (nouv);
}
//la fonction d'insèrtion dans la TS
quad inser_q (quad tete,char opera[],char opr1[],char opr2[],char re[],int n) 
{  
   quad nouv;
if(tete==NULL){
     tete=Teteq(opera,opr1,opr2,re,n);
	 
	    return tete;
}else{
// On cree un nouvel element //
nouv = malloc(sizeof(elt));
    strcpy(nouv->oper,opera);
    strcpy(nouv->op1,opr1);
    strcpy(nouv->op2,opr2);
    strcpy(nouv->res,re);
	nouv->qc=n;
nouv->Suivant = tete;
tete = nouv;
	return tete;
   }
}



quad mise_a_jour(quad q,int qc,char *ch)
{quad p=q;


   if (p==NULL)
{

return q;
}

while(p!=NULL) 
{

if(p->qc == qc)

{				
strcpy(p->op1,ch);
return q;
}

p=p->Suivant;  // On avance
}


return q;

}




void affiche_q(quad L)
{
     printf("\n<<<<<<<<<<  Affichage des quads  >>>>>>>>>>\n");
     if (L==NULL)
     
     printf("\n\n \t\t Quad Vide \n");
     
     else 
	 {
printf("**********************************************\n");
while(L!=NULL) // 
{   
printf("\t Quad[%d]=[ %s , %s , %s , %s ] \n",L->qc,L->oper,L->op1,L->op2,L->res); // On affiche 
L=L->Suivant;  // On avance d'une case
}
}
printf("**********************************************\n");
}































/*typedef struct elt{
	  char * oper;   //opérateur
	  char * op1;   //opérande 1
	  char * op2;   //opérande 2
	  char * res;   //Resultat
	//
}elt;
int main(){
	int i;
	elt tab[1000];
	tab[0].oper="+";
	tab[0].op1="33";
	tab[0].op2="99";
	tab[0].res="x";
for(i=0;i<20;i++)
	printf(" tab[%d]---> oper :%s  \top1 : %s   \top2 : %s  \tres : %s  \n",i+1,tab[i].oper,tab[i].op1,tab[i].op2,tab[i].res);	
	return 0;
}*/
