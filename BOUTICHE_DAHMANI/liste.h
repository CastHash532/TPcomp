#include <stdio.h>
#include <stdlib.h>
#include<string.h>

typedef struct node
{
char ch[20];
int type;
int nature;
struct node *svt;
}no;

typedef struct node *Elmt;


Elmt nouvlist()
{
    Elmt l=(Elmt) malloc(sizeof(no));
    return l;
}

//ajout au debut


Elmt ajoute_tete(Elmt l,char val[20],int type,int nature)
{Elmt p=nouvlist();
if(p==NULL)
{printf("ERORR no memory -' ");
    exit(-1);
}
else {
    strcpy(p->ch,val);
    p->svt=NULL;
    p->type=type;
    p->nature=nature;
    
}
return p;
}


//LIFO
Elmt inser(Elmt tete,char val[20],int type,int nature)
{
if(tete== NULL)
{
ajoute_tete(tete,val,type,nature);
}

Elmt p=nouvlist();
strcpy(p->ch,val);
p->type=type;
p->nature=nature;
p->svt=tete;
return p;

}

void affiche_liste(Elmt l)
{   printf("******************************************\n");


    while(l!=NULL)
    {  
        printf("         [%s]",l->ch);
        printf("         [%d]",l->type);
        printf("         [%d]",l->nature);
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
rch=strcmp(tete->ch,nom);
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

rch=strcmp(tete->ch,nom);
if(rch == 0){return tete -> nature; }

tete=tete->svt;
}


}

int return_type(Elmt tete,char nom[20])
{

int rch=1; //boolean faux

// Uint =0 ,Ufloat = 1



while(tete!=NULL)
{

rch=strcmp(tete->ch,nom);
if(rch == 0){return tete -> type; }

tete=tete->svt;
}


}






/*
int main()
{
Elmt tete;int n; char nom[20];
tete=ajoute_tete(tete,"anis",2);
tete=inser_apr(tete,"nano",20);

tete=inser_apr(tete,"test",25);
tete=inser_apr(tete,"electra",33);
tete=inser_apr(tete,"steve",12);

afflist(tete);


recherche(tete,"steve");



    return 0;
}
*/

























