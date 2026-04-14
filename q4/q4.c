#include <stdio.h>
#include <dlfcn.h>

typedef int (*fptr)(int, int);

int main() {
    char op[6];
    int num1, num2;

    while (scanf("%5s %d %d", op, &num1, &num2) == 3) {
        char lib_path[20];
        snprintf(lib_path, sizeof(lib_path), "./lib%s.so", op);

        void* handle = dlopen(lib_path, RTLD_LAZY);
        fptr operation = (fptr) dlsym(handle, op);

        printf("%d\n", operation(num1, num2));

        dlclose(handle);
    }

    return 0;
}
