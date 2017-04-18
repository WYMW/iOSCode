//
//  main.c
//  CProjct
//
//  Created by WangWei on 20/2/17.
//  Copyright © 2017年 WangWei. All rights reserved.
//

#include <stdio.h>


void(^best)(void) = ^{
    printf("Hello,World \n");
    
};

int  (^add)(int a, int b) = ^(int a, int b){
    
    printf("%d\n", a+b);
    return  a+ b;
};



int main(int argc, const char * argv[]) {
    
    
    add(1, 2);

}



