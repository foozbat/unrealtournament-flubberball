class Flubber expands Arena;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('TournamentHealth') || Other.IsA('UT_Shieldbelt')
		|| Other.IsA('Armor2') || Other.IsA('ThighPads')
		|| Other.IsA('UT_Invisibility') || Other.IsA('UDamage') 
		|| (Other.IsA('Weapon') && (WeaponString != "") && !Other.IsA(WeaponName))
		|| Other.IsA('Ammo') )
		return false;

	return Super.CheckReplacement( Other, bSuperRelevant );

/*
	bSuperRelevant = 0;
	return true;
*/
}

defaultproperties
{
	//GameName="Special Forces"
    WeaponName=BounceRifle
    AmmoName=BioAmmo
    WeaponString="Flubber.BounceRifle"
    AmmoString="Botpack.BioAmmo"
	DefaultWeapon=Class'Flubber.BounceRifle'

}


