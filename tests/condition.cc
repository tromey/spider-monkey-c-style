int
match()
{
    types::TypeSet *types = frame.extra(lhs).types;

//  if (JSOp(*PC) == JSOP_SETPROP && id == types::MakeTypeId(cx, id) &&
//      types && !types->unknownObject() &&
//      types->getObjectCount() == 1 &&
//      types->getTypeObject(0) != NULL &&
//      !types->getTypeObject(0)->unknownProperties())
    if (JSOp(*PC) == JSOP_SETPROP && id == types::MakeTypeId(cx, id) &&
        types && !types->unknownObject() &&
        types->getObjectCount() == 1 &&
        types->getTypeObject(0) != NULL &&
        !types->getTypeObject(0)->unknownProperties())
    {
        JS_ASSERT(usePropCache);
        types::TypeObject *object = types->getTypeObject(0);
        types::TypeSet *propertyTypes = object->getProperty(cx, id, false);
    } else {
    }

//  if (forHead->pn_kid1 && NewSrcNote2(cx, cg, SRC_DECL,
//                                      (forHead->pn_kid1->isOp(JSOP_DEFVAR))
//                                      ? SRC_DECL_VAR
//                                      : SRC_DECL_LET) < 0) {
//      return false;
//  }
    if (forHead->pn_kid1 && NewSrcNote2(cx, cg, SRC_DECL,
                                        (forHead->pn_kid1->isOp(JSOP_DEFVAR))
                                        ? SRC_DECL_VAR
                                        : SRC_DECL_LET) < 0) {
        return false;
    }
}
