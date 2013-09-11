#ifndef FOO_EXAMPLE_H_
#define FOO_EXAMPLE_H_

typedef struct mytype
{
    int i;
    double x;
} mytype;

void voidfoo0(void);
void voidfoo1(int);
void voidfoo2(int, double);
void voidfoo3(int, double, const char *);
//...
void voidfoo9(int, int, int, int, int, int, int, int, mytype *);

int intfoo0(void);
int intfoo1(int);
int intfoo2(int, int);
int intfoo3(int, int, int);
//...
int intfoo9(int, int, int, int, int, int, int, int, mytype *);

#endif
