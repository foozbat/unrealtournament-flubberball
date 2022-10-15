//=============================================================================
// UT_BioRifle.
//=============================================================================
class BounceRifle extends TournamentWeapon;

#exec MESH SEQUENCE MESH=BRifle2 SEQ=Fire      STARTFRAME=72  NUMFRAMES=9  RATE=2000

var float ChargeSize, Count;
var bool bBurst;

simulated function PlayIdleAnim()
{
	if ( Mesh == PickupViewMesh )
		return;
	if ( (Owner != None) && (VSize(Owner.Velocity) > 10) )
		PlayAnim('Walking',0.3,0.3);
	else 
		TweenAnim('Still', 1.0);
	Enable('AnimEnd');
}

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist;
	local bool bRetreating;
	local vector EnemyDir;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;
	bUseAltMode = 0;
	if ( Pawn(Owner).Enemy == None )
		return AIRating;

	EnemyDir = Pawn(Owner).Enemy.Location - Owner.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 1400 )
		return 0;

	bRetreating = ( ((EnemyDir/EnemyDist) Dot Owner.Velocity) < -0.6 );
	if ( (EnemyDist > 600) && (EnemyDir.Z > -0.4 * EnemyDist) )
	{
		// only use if enemy not too far and retreating
		if ( !bRetreating )
			return 0;

		return AIRating;
	}

	bUseAltMode = int( FRand() < 0.3 );

	if ( bRetreating || (EnemyDir.Z < -0.7 * EnemyDist) )
		return (AIRating + 0.18);
	return AIRating;
}

// return delta to combat style
function float SuggestAttackStyle()
{
	return -0.3;
}

function float SuggestDefenseStyle()
{
	return -0.4;
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = pawn(owner).AdjustToss(ProjSpeed, Start, 0, True, (bWarn || (FRand() < 0.4)));	
	return Spawn(ProjClass,,, Start,AdjustedAim);
}

simulated function PlayAltFiring()
{
	PlayOwnedSound(AltFireSound, SLOT_None, 1.7*Pawn(Owner).SoundDampening);	//fast fire goop
	LoopAnim('Fire',/*0.65 + 0.4 * FireAdjust*/0.35, 0.05);
}



// Finish a firing sequence
function Finish()
{
	local bool bForce, bForceAlt;

	bForce = bForceFire;
	bForceAlt = bForceAltFire;
	bForceFire = false;
	bForceAltFire = false;

	if ( bChangeWeapon )
		GotoState('DownWeapon');
	else if ( PlayerPawn(Owner) == None )
	{
		Pawn(Owner).bAltFire = 0;
		Super.Finish();
	}
	else if ( (AmmoType.AmmoAmount<=0) || (Pawn(Owner).Weapon != self) )
		GotoState('Idle');
	else if ( (Pawn(Owner).bFire!=0) || bForce )
		Global.Fire(0);
	else if ( (Pawn(Owner).bAltFire!=0) || bForceAlt )
		Global.AltFire(0);
	else 
		GotoState('Idle');
}

simulated function PlayAltBurst()
{
	//if ( Owner.IsA('PlayerPawn') )
	//	PlayerPawn(Owner).ClientInstantFlash( InstFlash, InstFog);
	PlayOwnedSound(FireSound, SLOT_Misc, 1.7*Pawn(Owner).SoundDampening);	//shoot goop
	PlayAnim('Fire',0.35, 0.05);
}

simulated function PlayFiring()
{
	PlayOwnedSound(AltFireSound, SLOT_None, 1.7*Pawn(Owner).SoundDampening);	//fast fire goop
	LoopAnim('Fire',/*0.65 + 0.4 * FireAdjust*/0.35, 0.05);
}

defaultproperties
{
     WeaponDescription="Classification: Toxic Rifle\n\nPrimary Fire: Wads of Tarydium byproduct are lobbed at a medium rate of fire.\n\nSecondary Fire: When trigger is held down, the BioRifle will create a much larger wad of byproduct. When this wad is launched, it will burst into smaller wads which will adhere to any surfaces.\n\nTechniques: Byproducts will adhere to walls, floors, or ceilings. Chain reactions can be caused by covering entryways with this lethal green waste."
     InstFlash=-0.150000
     InstFog=(X=139.000000,Y=218.000000,Z=72.000000)
     AmmoName=Class'botpack.BioAmmo'
     PickupAmmoCount=25
     bAltWarnTarget=True
     bRapidFire=false
     FiringSpeed=1.000000
     FireOffset=(X=12.000000,Y=-11.000000,Z=-6.000000)
     ProjectileClass=Class'Flubber.BounceGel'
     AltProjectileClass=Class'Flubber.BounceGel'
     AIRating=0.600000
     RefireRate=0.100000
     AltRefireRate=0.700000
     FireSound=Sound'UnrealI.BioRifle.GelShot'
     AltFireSound=Sound'UnrealI.BioRifle.GelShot'
     CockingSound=Sound'UnrealI.BioRifle.GelLoad'
     SelectSound=Sound'UnrealI.BioRifle.GelSelect'
     DeathMessage="%o was pulverized by %k's green flubber blob."
     NameColor=(R=0,B=0)
     AutoSwitchPriority=3
     InventoryGroup=3
     PickupMessage="You got the GES BioRifle."
     ItemName="GES Bio Rifle"
     PlayerViewOffset=(X=1.700000,Y=-0.850000,Z=-0.950000)
     PlayerViewMesh=LodMesh'botpack.BRifle2'
     BobDamping=0.972000
     PickupViewMesh=LodMesh'botpack.BRifle2Pick'
     ThirdPersonMesh=LodMesh'botpack.BRifle23'
     StatusIcon=Texture'botpack.Icons.UseBio'
     PickupSound=Sound'UnrealShare.Pickups.WeaponPickup'
     Icon=Texture'botpack.Icons.UseBio'
     Mesh=LodMesh'botpack.BRifle2Pick'
     bNoSmooth=False
     CollisionHeight=19.000000
}
