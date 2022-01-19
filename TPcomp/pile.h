#include<stdio.h>
#include<stdlib.h>
#include<string.h>

 
typedef  int  Val;
 
#define Max 100
 
typedef struct
{
          int sommet;
          Val     tab[Max];
} pile;
 
void initPile(pile *P)
{
    P->sommet = -1;
}
 

int pileVide(pile *P)
{
   return (P->sommet == -1) ;
}
 
int      pilePleine(pile *P)
{
    return (P->sommet == (Max - 1));
}
 
void empiler(pile *P, int x)
{    
    if (!pilePleine(P))
    {
        P->sommet++;
        P->tab[P->sommet] = x;
    }
    else
    {
        printf("Erreur: Ne peut pas empile - Pile Pleine ...\n");
    }
}
 
int desempiler(pile *P)
{   int x;
    if (!pileVide(P))
    {
        x = P->tab[P->sommet];
        P->sommet--; return x;
    }
    else
    {
        printf("Erreur: Ne peut pas depiler - Pile Vide ...\n"); return 1;
    }
}
 
void consulterSommet(pile *P, Val *x)
{
    if (!pileVide(P))
    {
        *x = P->tab[P->sommet];
    }
    else
    {
        printf("Pile Vide ...\n");
    }
}
void afficherpile(pile *p)
{ 
 int x;
while(!pileVide(p))
{  x=desempiler(p);
    printf(" %d ",x);} printf(" \n fin ");
} 
