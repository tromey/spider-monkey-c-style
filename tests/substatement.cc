int
match()
{
    switch (v) {
//    case L1:
//      if (t)
//          x = foo ? bar : baz;
//      goto L2;
      case L1:
        if (t)
            x = foo ? bar : baz;
        goto L2;
    }
}
