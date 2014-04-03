
//char *foo,
//      bar;
char *foo,
      bar;

struct foo {
//  char *bar,
//        baz;
    char *bar,
          baz;
};

class foo
{
//  char *bar,
//        baz;
    char *bar,
          baz;
};

int
match()
{
    struct a {
//      char *foo,
//            bar;
        char *foo,
              bar;
    };

//  char *foo,
//        bar;
    char *foo,
          bar;

//  char **foo,
//         bar;
    char **foo,
           bar;

//  char []foo,
//         bar;
    char []foo,
           bar;

//  unsigned char *s,
//                 b;
    unsigned char *s,
                   b;

//  unsigned long int a =
//      1,
//                    b
//      = 2;
    unsigned long int a =
        1,
                      b
        = 2;

//  foobar a,
//         b;
    foobar a,
           b;

//  struct foobar a,
//                b;
    struct foobar a,
                  b;

//  Rooted<NormalArgumentsObject*> foo(bar),
//                                 baz;
    Rooted<NormalArgumentsObject*> foo(bar),
                                   baz;

//  foobar<a,b> a,
//              b;
    foobar<a,b> a,
                b;

//  aa::foobar<a,baz<b> > a,
//                        b;
    aa::foobar<a,baz<b> > a,
                          b;

//  foo<T,
//      U> foo,
//         bar;
    foo<T,
        U> foo,
           bar;

}

int
no_match()
{
//  unsigned int a =
//      b;
    unsigned int a =
        b;

//  unsigned int a
//      = b;
    unsigned int a
        = b;

//  DebugOnly<PRStatus> status =
//      PR_WaitCondVar;
    DebugOnly<PRStatus> status =
        PR_WaitCondVar;
}
