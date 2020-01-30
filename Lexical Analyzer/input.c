#include<stdio.h>
#include<stdlib.h>

#define num 100



int main(void)
{

int number=32,sum=0; //integer datatype


char name[100] = "abcd"; // charater datatype

// example of single line comments

for(int i=1;i<20;i++)
{

         if(i%2==0)
        {
        	 sum=sum+i;

         printf("%d\n",sum);

int j;
         while(j<5)
         {
         	printf("hellow\n");
         	j++;
         	/*
           this is example for   multi line comment in c
         	*/
         }
        }
        else
        {
        	printf("skip odd numbers\n");
        }
}


printf("%d\n",sum );




}
