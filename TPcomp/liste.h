#include <stdio.h>
#include <stdlib.h>
#include<string.h>

typedef struct node
{
char token[20];
char type[20];
float value;
struct node *svt;
}no;

typedef struct node *Elmt;


Elmt nouvlist()
{
    Elmt l=(Elmt) malloc(sizeof(no));
    return l;
}

//ajout au debut


Elmt ajoute_tete(Elmt l,char token[20],char type[20],float value)
{Elmt p=nouvlist();
if(p==NULL)
{printf("ERORR no memory -' ");
    exit(-1);
}
else {
    strcpy(p->token,token);
    p->svt=NULL;
    strcpy(p->type,type);
    p->value=value;
    
}
return p;
}


//LIFO
Elmt inser(Elmt tete,char token[20],char type[20],float value)
{
if(tete== NULL)
{
ajoute_tete(tete,token,type,value);
}

Elmt p=nouvlist();
strcpy(p->token,token);
strcpy(p->type,type);
p->value=value;
p->svt=tete;
return p;

}

void affiche_liste(Elmt l)
{   printf("******************************************\n");

  printf("    ------------      ------          ----------  \n");
  printf("       Name            Type             Value    \n");
  printf("    ------------      ------          ----------\n");

    while(l!=NULL)
    {  
        printf("       [%s]",l->token);
        printf("       [%s]",l->type);
        printf("       [%f]",l->value);
        printf("\n");

        l=l->svt;
    }
    printf("******************************************\n");
}

int recherche(Elmt tete,char nom[20])
{
int rch=1; //boolean faux

while(tete!=NULL)
{
rch=strcmp(tete->token,nom);
if(rch == 0) return 0;//vrai
tete=tete->svt;
}



return 1;//faux
 

}


int return_nature(Elmt tete,char nom[20])
{

int rch=1; //boolean faux

while(tete!=NULL)
{

rch=strcmp(tete->token,nom);
if(rch == 0){return tete -> value; }

tete=tete->svt;
}


}

char *return_type(Elmt tete,char nom[20])
{

int rch=1; //boolean faux

// Uint =0 ,Ufloat = 1



while(tete!=NULL)
{

rch=strcmp(tete->token,nom);
if(rch == 0){return tete -> type; }

tete=tete->svt;
}


}


























