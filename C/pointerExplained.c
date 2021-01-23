
#include  <stdio.h>

int main(void)
{
    
    int num =10;
    // int * pointer는 num의 주소를 가르키고 있다.
    int * pointer = &num;
    
    // pointer는 주소 *pointer는 값
    // num은 값 &num은 주소

    if( *pointer == num){
        printf("맞음");
    } else {
        printf("아님");
    }
    printf("\n");
    if( pointer == &num)
        {
        printf("맞음");
    } else {
        printf("아님");
    }
    printf("\n");
    printf("%p\n", pointer);
    printf("%p\n", &num);
    printf("%d\n", num);
    printf("%d\n", *pointer);
}