//class Ninja : public WeaponWeilder,
//              public Camouflagible
//{
//    Ninja() : WeaponWeilder(Weapons::SHURIKEN),
//              Camouflagibley(Garments::SHINOBI_SHOZOKU) {}
//};
class Ninja : public WeaponWeilder,
              public Camouflagible
{
    Ninja() : WeaponWeilder(Weapons::SHURIKEN),
              Camouflagibley(Garments::SHINOBI_SHOZOKU) {}
};

//class Ninja
//  : public WeaponWeilder,
//    public Camouflagible
//{
//    Ninja()
//      : WeaponWeilder(Weapons::SHURIKEN),
//        Camouflagibley(Garments::SHINOBI_SHOZOKU) {}
//};
class Ninja
  : public WeaponWeilder,
    public Camouflagible
{
    Ninja()
      : WeaponWeilder(Weapons::SHURIKEN),
        Camouflagibley(Garments::SHINOBI_SHOZOKU) {}
};
