int
match() {
//  for (int i = 0; i < 5; i++)
//      doStuff();
    for (int i = 0; i < 5; i++)
        doStuff();

//  for (size_t ind = JSObject::JSSLOT_DATE_COMPONENTS_START;
//       ind < JSObject::DATE_FIXED_RESERVED_SLOTS;
//       ind++) {
//      obj->setSlot(ind, DoubleValue(utcTime));
//  }
    for (size_t ind = JSObject::JSSLOT_DATE_COMPONENTS_START;
         ind < JSObject::DATE_FIXED_RESERVED_SLOTS;
         ind++) {
        obj->setSlot(ind, DoubleValue(utcTime));
    }
}
