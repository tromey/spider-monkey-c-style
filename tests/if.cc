int
match()
{
//  if (today == "Tuesday")
//      puts("I don't have my wallet on me.");
//  else
//      puts("I would gladly pay you on Tuesday for a hamburger today.");
    if (today == "Tuesday")
        puts("I don't have my wallet on me.");
    else
        puts("I would gladly pay you on Tuesday for a hamburger today.");

//  if (canSwingFromWeb) {
//      p->swingFromWeb();
//  } else {
//      JS_ASSERT(p->isSpiderPig());
//      p->doWhateverSpiderPigDoes();
//  }
    if (canSwingFromWeb) {
        p->swingFromWeb();
    } else {
        JS_ASSERT(p->isSpiderPig());
        p->doWhateverSpiderPigDoes();
    }
}
