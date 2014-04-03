int
match()
{
//  x = foo ? bar
//          : baz;
    x = foo ? bar
            : baz;

//  x += foo ? bar
//           : baz;
    x += foo ? bar
             : baz;

//  x = foo
//    ? bar
//    : baz;
    x = foo
      ? bar
      : baz;

//  x += foo
//     ? bar
//     : baz;
    x += foo
       ? bar
       : baz;

//  x <<= foo
//      ? bar
//      : baz;
    x <<= foo
        ? bar
        : baz;
}

int
no_match()
{
//  x == foo
//      ? bar
//      : baz;
    x == foo
        ? bar
        : baz;

//  x != foo
//      ? bar
//      : baz;
    x != foo
        ? bar
        : baz;

//  SyntacticContext kidsc =
//      pn->isKind(PNK_NOT)
//      ? SyntacticContext::Condition
//      : pn->isKind(PNK_DELETE)
//      ? SyntacticContext::Delete
//      : SyntacticContext::Other;
    SyntacticContext kidsc =
        pn->isKind(PNK_NOT)
        ? SyntacticContext::Condition
        : pn->isKind(PNK_DELETE)
        ? SyntacticContext::Delete
        : SyntacticContext::Other;

//  a =  (1 ? 2 : 3) ? foo
//                   : bar;
    a =  (1 ? 2 : 3) ? foo
                     : bar;

//  return foo->bar() ? baz
//                    : bazz;
    return foo->bar() ? baz
                      : bazz;
}

int
no_match()
{
//  foo = (1 ? 2 : 3) +
//        bar;
    foo = (1 ? 2 : 3) +
          bar;
}
