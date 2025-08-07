#pragma semicolon 1
#pragma newdecls required


static char g_DeathSounds[][] = {
	"vo/medic_paincrticialdeath01.mp3",
	"vo/medic_paincrticialdeath02.mp3",
	"vo/medic_paincrticialdeath03.mp3",
};

static char g_HurtSounds[][] = {
	")vo/medic_painsharp01.mp3",
	")vo/medic_painsharp02.mp3",
	")vo/medic_painsharp03.mp3",
	")vo/medic_painsharp04.mp3",
	")vo/medic_painsharp05.mp3",
	")vo/medic_painsharp06.mp3",
	")vo/medic_painsharp07.mp3",
	")vo/medic_painsharp08.mp3",
};

static char g_IdleSounds[][] = {
	")vo/null.mp3",
};

static char g_IdleAlertedSounds[][] = {
	")vo/medic_battlecry01.mp3",
	")vo/medic_battlecry02.mp3",
	")vo/medic_battlecry03.mp3",
	")vo/medic_battlecry04.mp3",
};

static char g_MeleeHitSounds[][] = {
	"weapons/ubersaw_hit3.wav",
	"weapons/pan/melee_frying_pan_02.wav",
	"weapons/metal_gloves_hit_crit2.wav",
	"weapons/halloween_boss/knight_axe_hit.wav",
	"weapons/bottle_hit_flesh2.wav",
	"weapons/batsaber_hit_flesh1.wav",
};


static char g_MeleeAttackSounds[][] = {
	")weapons/knife_swing.wav",
};

static char g_RangedAttackSounds[][] = {
	"weapons/breadmonster/throwable/bm_throwable_throw.wav",
};
static char g_TeleportSounds[][] = {
	"misc/halloween/spell_teleport.wav",
};

static char g_MeleeDrawSound[][] = {
	"weapons/draw_machete_sniper.wav",
};

static char g_AngerSounds[][] = {
	")vo/medic_hat_taunts04.mp3",
};

static char g_PullSounds[][] = {
	"weapons/physcannon/energy_sing_explosion2.wav"
};

enum Tocksick_Projectile_Type {
	Tocksick_Projectile_Kaboom = 0,
	Tocksick_Projectile_Sizzle,
	Tocksick_Projectile_Sizz,
	Tocksick_Projectile_Bang,
	Tocksick_Projectile_Whack
}

enum Tocksick_RTD_Type {
	Tocksick_RTD_LongRange = 0,	// A cool multiplier aka lag experience
	Tocksick_RTD_PowerFullHit,	// A not cool multiplier
	Tocksick_RTD_Toxic, 		// Toxic tocksick (: (it's 4 am, pls don't judge me)
	Tocksick_RTD_Invisible, 	// Fun fact, invisible and frozen rtd match together, that's all... this is not really fun afterwards...
	Tocksick_RTD_Speed, 		// Fun fact, this does nothing when frozen
	Tocksick_RTD_Frozen, 		// idk if you know, but frozen and invisible match together, well now you know
	Tocksick_RTD_Firebreath,	// At the same time the worst and the best rtd, to code, and to play against
	Tocksick_RTD_ScaryBullet,	// Artvin, my man, don't kill me for that pls
	Tocksick_RTD_FastHand,		// An insane multiplier
	Tocksick_RTD_ExtraAmmo,		// You know what we need? 6 times more chaos
	Tocksick_RTD_BumperCar,		// why I'm doing that? just to suffer? (actually, I just want to see a giant npc in a kart)
	Tocksick_RTD_NecroSmash,	// Why everytime I read that, dark jokes come in my mind?
	Tocksick_RTD_DejaVu,		// Fun fact, this is french (déjà vu) which mean already seen, but no one cares because no one likes french
	Tocksick_RTD_LuckyThrow,	// I'm so hyped for this one (I need more chaos!)
	Tocksick_RTD_Portals		// Well, this one is just here but does nothing rn, it's a lie
}

enum Tocksick_Ability_Type {
	Tocksick_Ability_PsycheUp = 0,
	Tocksick_Ability_Oomph,
	Tocksick_Ability_Acceleratle,
	Tocksick_Ability_Bounce,
	Tocksick_Ability_Ducks, // Well, idk, I have a fun idea for this one
	Tocksick_Ability_BadAnalyse,
	Tocksick_Ability_GoodAnalyse,
	Tocksick_Ability_MagicBurst,
	Tocksick_Ability_MVM,
	Tocksick_Ability_BeatThemUp,
	Tocksick_Ability_WhoTouched,
	Tocksick_Ability_BUSTER,
	Tocksick_Ability_Chaos,
	Tocksick_Ability_Fakes,
	Tocksick_Ability_Magnet,
	Tocksick_Ability_JumpingElec,
}




static char gGlow1;
static char gExplosive1;
static char gLaser1;


// Next time tocksick can use rng
static float Tocksick_Next_Event[MAXENTITIES];
static float Tocksick_Next_Melee[MAXENTITIES];
static float Tocksick_Next_RTD[MAXENTITIES]; // This one is gonna be fun
static float Tocksick_Next_Projectile[MAXENTITIES]; 

// Passive stats
//static float Tocksick_Dmg_Multiplier[MAXENTITIES];
//static float Tocksick_Res_Multiplier[MAXENTITIES];

// Here are all the possible rtd tocksick can have, all rtd stay for 8 secs, except the instant one like necro smasher
static float Tocksick_InLongRangeFor[MAXENTITIES]; // Better melee range
static float Tocksick_InPowerfullHitFor[MAXENTITIES]; // Next attacks will hurt

static float Tocksick_IsToxicFor[MAXENTITIES]; // Dw, it will be weak
static float Tocksick_IsToxic_NextAttack[MAXENTITIES]; 

static float Tocksick_IsInvisibleFor[MAXENTITIES];
static float Tocksick_InSpeedFor[MAXENTITIES];
static float Tocksick_IsFrozenFor[MAXENTITIES];
static float Tocksick_InFireBreathFor[MAXENTITIES]; // Basically launch fireball each time he talks
static float Tocksick_InScaryBulletsFor[MAXENTITIES];
static float Tocksick_InFastHandFor[MAXENTITIES];
static float Tocksick_ExtraAmmoCountFor[MAXENTITIES];
static int Tocksick_ExtraAmmoCount[MAXENTITIES];

static float Tocksick_InBumperCarFor[MAXENTITIES];
static float Tocksick_InBumperCarAnimStart[MAXENTITIES];
static float Tocksick_InBumperCarAnimEnd[MAXENTITIES];
static float Tocksick_InBumperNextCharge[MAXENTITIES];
static float Tocksick_InBumperIsChargingFor[MAXENTITIES];




/*/////////////////////////////////////////////////////////////////
			Here are all the basic ability tocksick can use
*/
// Melee section
static float Tocksick_InFlameSlashFor[MAXENTITIES];
static float Tocksick_NextFlameCheck[MAXENTITIES]; // I need to hardcode that
static float Tocksick_InHachetMannFor[MAXENTITIES];
static float Tocksick_InKacrackleSlashFor[MAXENTITIES];
static float Tocksick_InThwackFor[MAXENTITIES];
static float Tocksick_InMetalSlashFor[MAXENTITIES];


// Buff section
static float Tocksick_InPsycheUpFor[MAXENTITIES];
static float Tocksick_InOomphFor[MAXENTITIES];
static int Tocksick_InOomphCount[MAXENTITIES];
static float Tocksick_InAcceleratleFor[MAXENTITIES];
static float Tocksick_InBounceFor[MAXENTITIES];


/*/////////////////////////////////////////////////////////////////
			Here are all the "advanced" ability tocksick can use
*/
static float Tocksick_InBonusDucksFor[MAXENTITIES]; // Next projectiles will be ducks
static float Tocksick_InGoodAnalyseFor[MAXENTITIES]; // tocksick will be stuck in place and create where player are, but only dmg buildings
static float Tocksick_InGoodAnalysePoints[MAXENTITIES][5][3]; // tocksick will be stuck in place and create where player are, but only dmg buildings
static int Tocksick_InGoodAnalyseIndex[MAXENTITIES]; // tocksick will be stuck in place and create where player are, but only dmg buildings



/* Ideas that don't use any global var
	- **NEW** MvM?: Will spawn hacker snipers
	- **NEW** Beat them up: Will spawn melee scouts
	- **NEW** Who touched doctor?: Will spawn heavy brawler
	- **NEW** BUSTERS!!!: Will spawn sentry busters
	- **NEW** Tactical support: Will spawn weaker tocksick
	- **NEW** Sacrifice: For each player dead, tocksick will loose 2% of his max hp
	- **NEW** Critical thinking: For each player in radius, tocksick will be stunt for 0.5 but after that, he will roll that number of events
*/





public void TrueTocksick_OnMapStart()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));       i++) { PrecacheSound(g_DeathSounds[i]);       }
	for (int i = 0; i < (sizeof(g_HurtSounds));        i++) { PrecacheSound(g_HurtSounds[i]);        }
	for (int i = 0; i < (sizeof(g_IdleSounds));        i++) { PrecacheSound(g_IdleSounds[i]);        }
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	for (int i = 0; i < (sizeof(g_MeleeHitSounds));    i++) { PrecacheSound(g_MeleeHitSounds[i]);    }
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds));    i++) { PrecacheSound(g_MeleeAttackSounds[i]);    }
	for (int i = 0; i < (sizeof(g_MeleeDrawSound));   i++) { PrecacheSound(g_MeleeDrawSound[i]);   }
	for (int i = 0; i < (sizeof(g_TeleportSounds));   i++) { PrecacheSound(g_TeleportSounds[i]);   }
	for (int i = 0; i < (sizeof(g_RangedAttackSounds));   i++) { PrecacheSound(g_RangedAttackSounds[i]);   }
	for (int i = 0; i < (sizeof(g_AngerSounds));   i++) { PrecacheSound(g_AngerSounds[i]);   }
	for (int i = 0; i < (sizeof(g_PullSounds));   i++) { PrecacheSound(g_PullSounds[i]);   }
	
	
	PrecacheSound("weapons/physcannon/superphys_launch1.wav", true);
	PrecacheSound("weapons/physcannon/superphys_launch2.wav", true);
	PrecacheSound("weapons/physcannon/superphys_launch3.wav", true);
	PrecacheSound("weapons/physcannon/superphys_launch4.wav", true);
	PrecacheSound("weapons/physcannon/energy_sing_loop4.wav", true);
	
	PrecacheSound("vo/medic_specialcompleted02.mp3", true);
	TrueTocksick_Precahce();
	
	gLaser1 = PrecacheModel("materials/sprites/laser.vmt");
	gGlow1 = PrecacheModel("sprites/blueglow2.vmt", true);
	gExplosive1 = PrecacheModel("materials/sprites/sprite_fire01.vmt");
	
	PrecacheSound("player/flow.wav");
	
	NecroMash_Start();
}

void TrueTocksick_Precahce()
{
	/*
	FusionWarrior_BEAM_Laser = PrecacheModel("materials/sprites/laser.vmt", false);
	FusionWarrior_BEAM_Glow = PrecacheModel("sprites/glow02.vmt", true);
	*/
	PrecacheModel("models/weapons/c_models/c_drg_cowmangler/c_drg_cowmangler.mdl", true);
}

methodmap TrueTocksick < CClotBody
{
	// first, all stats multiplier
	// Important, they will all be scaled negatively
	// time tocksick change that stat, it will be: stat + x/stat
	// it's the best way to avoid the raid to be too weak/strong
	// also, x goes between 0.7 and 1.3
	// in short, the max should be 4
	// I know, it's passive but with the shitton of event I made, it has a low chance to boost his passive stats
	// WELL THIS GOT REMOVED, WILL BE APPLIED IF THE BOSS IS TO WEAK
	/*
	property float m_fDmgMultiplier
	{
		public get()							{ return Tocksick_Dmg_Multiplier[this.index]; }
		public set(float TempValueForProperty) 	{ Tocksick_Dmg_Multiplier[this.index] = TempValueForProperty; }
	}
	property float m_fResMultiplier
	{
		public get()							{ return Tocksick_Res_Multiplier[this.index]; }
		public set(float TempValueForProperty) 	{ Tocksick_Res_Multiplier[this.index] = TempValueForProperty; }
	}
	*/
	// Here is the time he will use an ability
	property float m_flNextEvent
	{
		public get()							{ return Tocksick_Next_Event[this.index]; }
		public set(float TempValueForProperty) 	{ Tocksick_Next_Event[this.index] = TempValueForProperty; }
	}
	property float m_flNextEventMelee
	{
		public get()							{ return Tocksick_Next_Melee[this.index]; }
		public set(float TempValueForProperty) 	{ Tocksick_Next_Melee[this.index] = TempValueForProperty; }
	}
	property float m_flNextRtd
	{
		public get()							{ return Tocksick_Next_RTD[this.index]; }
		public set(float TempValueForProperty) 	{ Tocksick_Next_RTD[this.index] = TempValueForProperty; }
	}
	property float m_flNextProjectile
	{
		public get()							{ return Tocksick_Next_Projectile[this.index]; }
		public set(float TempValueForProperty) 	{ Tocksick_Next_Projectile[this.index] = TempValueForProperty; }
	}
	
	
	// Shitton melee here
	property float m_flFlameSlashDuration
	{
		public get()							{ return Tocksick_InFlameSlashFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InFlameSlashFor[this.index] = TempValueForProperty; 
			this.m_bInFlameSlash = true;
		}
	}
	property bool m_bInFlameSlash
	{
		public get() { 
			if (Tocksick_InFlameSlashFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InFlameSlashFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInFlameSlash = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InFlameSlashFor[this.index] = -1.0;
				this.ResetMelee();
			}
			else
				this.GiveFS();
		}
	}
	property float m_flFlameCheck
	{
		public get()							{ return Tocksick_NextFlameCheck[this.index]; }
		public set(float TempValueForProperty) { Tocksick_NextFlameCheck[this.index] = TempValueForProperty; }
	}
	
	property float m_flHachetMannDuration
	{
		public get()							{ return Tocksick_InHachetMannFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InHachetMannFor[this.index] = TempValueForProperty; 
			this.m_bInHachetMann = true;
		}
	}
	property bool m_bInHachetMann
	{
		public get() { 
			if (Tocksick_InHachetMannFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InHachetMannFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInHachetMann = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InHachetMannFor[this.index] = -1.0;
				this.ResetMelee();
			}
			else
				this.GiveHM();
		}
	}
	
	
	property float m_flKacrackleSlashDuration
	{
		public get()							{ return Tocksick_InKacrackleSlashFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InKacrackleSlashFor[this.index] = TempValueForProperty; 
			this.m_bInKacrackleSlash = true;
		}
	}
	property bool m_bInKacrackleSlash
	{
		public get() { 
			if (Tocksick_InKacrackleSlashFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InKacrackleSlashFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInKacrackleSlash = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InKacrackleSlashFor[this.index] = -1.0;
				this.ResetMelee();
			}
			else
				this.GiveKS();
		}
	}
	
	property float m_flThwackDuration
	{
		public get()							{ return Tocksick_InThwackFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InThwackFor[this.index] = TempValueForProperty; 
			this.m_bInThwack = true;
		}
	}
	property bool m_bInThwack
	{
		public get() { 
			if (Tocksick_InThwackFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InThwackFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInThwack = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InThwackFor[this.index] = -1.0;
				this.ResetMelee();
			}
			else
				this.GiveThwack();
		}
	}
	
	property float m_flMetalSlashDuration
	{
		public get()							{ return Tocksick_InMetalSlashFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InMetalSlashFor[this.index] = TempValueForProperty; 
			this.m_bInMetalSlash = true;
		}
	}
	property bool m_bInMetalSlash
	{
		public get() { 
			if (Tocksick_InMetalSlashFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InMetalSlashFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInMetalSlash = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InMetalSlashFor[this.index] = -1.0;
				this.ResetMelee();
			}
			else
				this.GiveMS();
		}
	}
	
	
	/*
		RTD MANAGEMENT
	*/
	// The long range doesn't seem to applied on every weapon, why? IDK 
	property float m_flLongRangeDuration
	{
		public get()							{ return Tocksick_InLongRangeFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InLongRangeFor[this.index] = TempValueForProperty; 
			this.m_bInLongRange = true;
		}
	}
	property bool m_bInLongRange
	{
		public get() { 
			if (Tocksick_InLongRangeFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InLongRangeFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInLongRange = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InLongRangeFor[this.index] = -1.0;
				this.ResetLongRange();
			}
			else
				this.AddLongRange();
		}
	}
	
	property float m_flPowerfullHitDuration
	{
		public get()							{ return Tocksick_InPowerfullHitFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InPowerfullHitFor[this.index] = TempValueForProperty; 
			this.m_bInPowerfullHit = true;
		}
	}
	property bool m_bInPowerfullHit
	{
		public get() { 
			if (Tocksick_InPowerfullHitFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InPowerfullHitFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInPowerfullHit = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InPowerfullHitFor[this.index] = -1.0;
			}
		}
	}
	
	property float m_flToxicDuration
	{
		public get()							{ return Tocksick_IsToxicFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_IsToxicFor[this.index] = TempValueForProperty; 
			this.m_bInToxic = true;
		}
	}
	property bool m_bInToxic
	{
		public get() { 
			if (Tocksick_IsToxicFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_IsToxicFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInToxic = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_IsToxicFor[this.index] = -1.0;
			}
		}
	}
	property float m_flToxicCheck
	{
		public get()							{ return Tocksick_IsToxic_NextAttack[this.index]; }
		public set(float TempValueForProperty) { Tocksick_IsToxic_NextAttack[this.index] = TempValueForProperty; }
	}
	
	property float m_flInvisibleDuration
	{
		public get()							{ return Tocksick_IsInvisibleFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_IsInvisibleFor[this.index] = TempValueForProperty; 
			this.m_bInInvisible = true;
		}
	}
	property bool m_bInInvisible
	{
		public get() { 
			if (Tocksick_IsInvisibleFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_IsInvisibleFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInInvisible = false;
			
			return StillIn;
		}
		// Dear god, I really like when you make my life easier like that
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_IsInvisibleFor[this.index] = -1.0;
				SetEntityRenderColor(this.index, i_EntityRenderColour1[this.index], i_EntityRenderColour2[this.index], i_EntityRenderColour3[this.index], i_EntityRenderColour4[this.index], true, false, true);
			}
			else
				SetEntityRenderColor(this.index, 0, 0, 0, 0, false, false, true); // ghost, also, idk if I gonna bother make melee invisible (YES, YES I DID)
		}
	}
	
	property float m_flSpeedDuration
	{
		public get()							{ return Tocksick_InSpeedFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InSpeedFor[this.index] = TempValueForProperty; 
			this.m_bInSpeed = true;
		}
	}
	property bool m_bInSpeed
	{
		public get() { 
			if (Tocksick_InSpeedFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InSpeedFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInSpeed = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InSpeedFor[this.index] = -1.0;
				if (!this.m_bInFrozen && !this.m_bInBumperCar)
					this.m_flSpeed -= 100.0;
			}
			else {
				if (!this.m_bInFrozen && !this.m_bInBumperCar)
					this.m_flSpeed += 100.0;
			}
		}
	}
	
	property float m_flFrozenDuration
	{
		public get()							{ return Tocksick_IsFrozenFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_IsFrozenFor[this.index] = TempValueForProperty; 
			this.m_bInFrozen = true;
		}
	}
	property bool m_bInFrozen
	{
		public get() { 
			if (Tocksick_IsFrozenFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_IsFrozenFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInFrozen = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_IsFrozenFor[this.index] = -1.0;
				this.m_flSpeed = 330.0;
				
				if (this.m_bInAcceleratle)
					this.m_flSpeed = GetRandomFloat(300.0, 420.0);
				
				if (this.m_bInSpeed)
					this.m_flSpeed += 100.0;
				
				SetEntityRenderColor(this.index, i_EntityRenderColour1[this.index], i_EntityRenderColour2[this.index], i_EntityRenderColour3[this.index], i_EntityRenderColour4[this.index], true, false, true);
				this.StartPathing();
				this.PlayIdleAlertSound();
			}
			else {
				this.m_flSpeed = 0.0;
				PF_StopPathing(this.index);
				this.m_bPathing = false;
				SetEntityRenderColor(this.index, 0, 0, 255, 200, false, false, true);
			}
		}
	}
	
	property float m_flFireBreathDuration
	{
		public get()							{ return Tocksick_InFireBreathFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InFireBreathFor[this.index] = TempValueForProperty; 
			this.m_bInFireBreath = true;
		}
	}
	property bool m_bInFireBreath
	{
		public get() { 
			if (Tocksick_InFireBreathFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InFireBreathFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInFireBreath = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InFireBreathFor[this.index] = -1.0;
			}
		}
	}
	
	property float m_flScaryBulletsDuration
	{
		public get()							{ return Tocksick_InScaryBulletsFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InScaryBulletsFor[this.index] = TempValueForProperty; 
			this.m_bInScaryBullets = true;
		}
	}
	property bool m_bInScaryBullets
	{
		public get() { 
			if (Tocksick_InScaryBulletsFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InScaryBulletsFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInScaryBullets = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InScaryBulletsFor[this.index] = -1.0;
			}
		}
	}
	
	property float m_flFastHandDuration
	{
		public get()							{ return Tocksick_InFastHandFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InFastHandFor[this.index] = TempValueForProperty; 
			this.m_bInFastHand = true;
		}
	}
	property bool m_bInFastHand
	{
		public get() { 
			if (Tocksick_InFastHandFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InFastHandFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInFastHand = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InFastHandFor[this.index] = -1.0;
			}
		}
	}
	
	property float m_flExtraAmmoDuration
	{
		public get()							{ return Tocksick_ExtraAmmoCountFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_ExtraAmmoCountFor[this.index] = TempValueForProperty; 
			this.m_bInExtraAmmo = true;
		}
	}
	property bool m_bInExtraAmmo
	{
		public get() { 
			if (Tocksick_ExtraAmmoCountFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_ExtraAmmoCountFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInExtraAmmo = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_ExtraAmmoCountFor[this.index] = -1.0;
			}
			else
				this.m_iExtraAmmo = GetRandomInt(1, 6);
		}
	}
	property int m_iExtraAmmo
	{
		public get()							{ return Tocksick_ExtraAmmoCount[this.index]; }
		public set(int TempValueForProperty) 	{ Tocksick_ExtraAmmoCount[this.index] = TempValueForProperty; }
	}
	
	
	property float m_flBumperCarDuration
	{
		public get()							{ return Tocksick_InBumperCarFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InBumperCarFor[this.index] = TempValueForProperty; 
			this.m_bInBumperCar = true;
		}
	}
	property bool m_bInBumperCar
	{
		public get() { 
			if (Tocksick_InBumperCarFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InBumperCarFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
			{
				int iActivity = this.LookupActivity("ACT_MP_RUN_MELEE");
				if(iActivity > 0) this.StartActivity(iActivity);
				
				this.m_bInBumperCarCharging = false;
				this.m_bInBumperCar = false;
				this.m_flBumperCarAnimEnd = GetGameTime(this.index) + 0.4;
			}
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InBumperCarFor[this.index] = -1.0;
			}
			else {
				this.m_iWearable2 = this.EquipItem("head", "models/player/items/taunts/bumpercar/parts/bumpercar.mdl");
				SetVariantString("1.0");
				AcceptEntityInput(this.m_iWearable2, "SetModelScale");
				SetEntProp(this.m_iWearable2, Prop_Send, "m_nSkin", 1);
				this.m_flBumperCarAnimStart = GetGameTime(this.index) + 0.4;
			}
		}
	}
	
	property float m_flBumperCarAnimStart
	{
		public get()							{ return Tocksick_InBumperCarAnimStart[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InBumperCarAnimStart[this.index] = TempValueForProperty; 
			this.m_bInBumperCarAnimStart = true;
		}
	}
	property bool m_bInBumperCarAnimStart
	{
		public get() { 
			if (Tocksick_InBumperCarAnimStart[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InBumperCarAnimStart[this.index] > GetGameTime(this.index);
			if (!StillIn)
			{
				this.m_bInBumperCarAnimStart = false;
				int iActivity = this.LookupActivity("ACT_KART_IDLE");
				if(iActivity > 0) this.StartActivity(iActivity);
			}
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InBumperCarAnimStart[this.index] = -1.0;
				this.m_flSpeed = 0.0;
			}
			else {
				this.AddGestureViaSequence("taunt_vehicle_allclass_start");
				this.m_flBumperCarNextCharge = GetGameTime(this.index) + 2.0;
			}
		}
	}
	
	property float m_flBumperCarAnimEnd
	{
		public get()							{ return Tocksick_InBumperCarAnimEnd[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InBumperCarAnimEnd[this.index] = TempValueForProperty; 
			this.m_bInBumperCarAnimEnd = true;
		}
	}
	property bool m_bInBumperCarAnimEnd
	{
		public get() { 
			if (Tocksick_InBumperCarAnimEnd[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InBumperCarAnimEnd[this.index] > GetGameTime(this.index);
			if (!StillIn)
			{
				this.m_bInBumperCarAnimEnd = false;
				this.m_flSpeed = 330.0;
				
				if (this.m_bInAcceleratle)
					this.m_flSpeed = GetRandomFloat(300.0, 420.0);
				
				if (this.m_bInSpeed)
					this.m_flSpeed += 100.0;
					
				if (this.m_bInFrozen)
					this.m_flSpeed = 0.0;
			}
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InBumperCarAnimEnd[this.index] = -1.0;
			}
			else {
				this.AddGestureViaSequence("taunt_vehicle_allclass_end");
				
				if(IsValidEntity(this.m_iWearable2))
					RemoveEntity(this.m_iWearable2);
			}
		}
	}
	
	property float m_flBumperCarNextCharge
	{
		public get()							{ return Tocksick_InBumperNextCharge[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InBumperNextCharge[this.index] = TempValueForProperty; 
			this.m_bInBumperNextCharge = true;
		}
	}
	property bool m_bInBumperNextCharge
	{
		public get() { 
			if (Tocksick_InBumperNextCharge[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InBumperNextCharge[this.index] > GetGameTime(this.index);
			if (!StillIn)
			{
				this.m_bInBumperNextCharge = false;
			}
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InBumperNextCharge[this.index] = -1.0;
				this.m_flBumperCarChargingDuration = GetGameTime(this.index) + 4.0;
			}
		}
	}

	property float m_flBumperCarChargingDuration
	{
		public get()							{ return Tocksick_InBumperIsChargingFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InBumperIsChargingFor[this.index] = TempValueForProperty; 
			this.m_bInBumperCarCharging = true;
		}
	}
	property bool m_bInBumperCarCharging
	{
		public get() { 
			if (Tocksick_InBumperIsChargingFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InBumperIsChargingFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
			{
				this.m_bInBumperCarCharging = false;
			}
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InBumperIsChargingFor[this.index] = -1.0;
				this.m_flSpeed = 0.0;
				this.m_flBumperCarNextCharge = GetGameTime(this.index) + 2.0;
			}
			else {
				this.AddGesture("ACT_KART_ACTION_DASH");
				this.m_flSpeed = 800.0;
			}
		}
	}
	
	
	/*
		Ability MANAGEMENT
	*/
	property float m_flPsycheUpDuration
	{
		public get()							{ return Tocksick_InPsycheUpFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InPsycheUpFor[this.index] = TempValueForProperty; 
			this.m_bInPsycheUp = true;
		}
	}
	property bool m_bInPsycheUp
	{
		public get() { 
			if (Tocksick_InPsycheUpFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InPsycheUpFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInPsycheUp = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InPsycheUpFor[this.index] = -1.0;
			}
		}
	}
	
	
	property float m_flOomphDuration
	{
		public get()							{ return Tocksick_InOomphFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InOomphFor[this.index] = TempValueForProperty; 
			this.m_bInOomph = true;
		}
	}
	property bool m_bInOomph
	{
		public get() { 
			if (Tocksick_InOomphFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InOomphFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInOomph = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InOomphFor[this.index] = -1.0;
			}
			else {
				this.m_iOomphCount = 0;
			}
		}
	}
	property int m_iOomphCount
	{
		public get()							{ return Tocksick_InOomphCount[this.index]; }
		public set(int TempValueForProperty) { 
			if (TempValueForProperty>5)
				TempValueForProperty = 5;
			Tocksick_InOomphCount[this.index] = TempValueForProperty; 
		}
	}
	
	
	property float m_flAcceleratleDuration
	{
		public get()							{ return Tocksick_InAcceleratleFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InAcceleratleFor[this.index] = TempValueForProperty; 
			this.m_bInAcceleratle = true;
		}
	}
	property bool m_bInAcceleratle
	{
		public get() { 
			if (Tocksick_InAcceleratleFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InAcceleratleFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInAcceleratle = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InAcceleratleFor[this.index] = -1.0;
				this.m_flSpeed = 330.0;
				
				if (this.m_bInSpeed)
					this.m_flSpeed += 100.0;
					
				if (this.m_bInFrozen || this.m_bInBumperCar)
					this.m_flSpeed = 0.0;
			}
			else {
				this.m_flSpeed = GetRandomFloat(300.0, 420.0);
				if (this.m_bInSpeed)
					this.m_flSpeed += 100.0;
					
				if (this.m_bInFrozen || this.m_bInBumperCar)
					this.m_flSpeed = 0.0;
			}
		}
	}
	
	property float m_flBounceDuration
	{
		public get()							{ return Tocksick_InBounceFor[this.index]; }
		public set(float TempValueForProperty) { 
			Tocksick_InBounceFor[this.index] = TempValueForProperty; 
			this.m_bInBounce = true;
		}
	}
	property bool m_bInBounce
	{
		public get() { 
			if (Tocksick_InBounceFor[this.index]==-1.0)
				return false; 
			
			bool StillIn = Tocksick_InBounceFor[this.index] > GetGameTime(this.index);
			if (!StillIn)
				this.m_bInBounce = false;
			
			return StillIn;
		}
		public set(bool TempValueForProperty) { 
			if (!TempValueForProperty) {
				Tocksick_InBounceFor[this.index] = -1.0;
			}
		}
	}
	
	
	
	// For hud thingy and other things actually like freeze and such
	property bool m_bIsTocksick
	{
		public get() { return true; } // Best code ever
	}
	
	
	
	
	public void PlayIdleSound(bool repeat = false) {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		int sound = GetRandomInt(0, sizeof(g_IdleSounds) - 1);
		
		EmitSoundToAll(g_IdleSounds[sound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(24.0, 48.0);	
	}
	
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
			
		int sound = GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1);
		
		EmitSoundToAll(g_IdleAlertedSounds[sound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
	}
	
	public void PlayHurtSound() {
		
		int sound = GetRandomInt(0, sizeof(g_HurtSounds) - 1);

		EmitSoundToAll(g_HurtSounds[sound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		this.m_flNextHurtSound = GetGameTime(this.index) + GetRandomFloat(0.6, 1.6);
		
	}
	
	public void PlayDeathSound() {
		
		int sound = GetRandomInt(0, sizeof(g_DeathSounds) - 1);
		
		EmitSoundToAll(g_DeathSounds[sound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
	}
	
	public void PlayMeleeSound() {
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
	
	
	public void PlayMeleeHitSound() {
		int meleeSound = 0;
		
		if (this.m_bInFlameSlash)
			meleeSound = 1;
		
		if (this.m_bInHachetMann)
			meleeSound = 3;
			
		if (this.m_bInKacrackleSlash)
			meleeSound = 4;
			
		if (this.m_bInThwack)
			meleeSound = 5;
			
		if (this.m_bInMetalSlash)
			meleeSound = 2;
		
		EmitSoundToAll(g_MeleeHitSounds[meleeSound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}

	public void PlayMeleeDrawSound() {
		EmitSoundToAll(g_MeleeDrawSound[GetRandomInt(0, sizeof(g_MeleeDrawSound) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeDrawSound()");
		#endif
	}
	
	public void ResetMelee(){
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/weapons/c_models/c_ubersaw/c_ubersaw_xmas.mdl");
		if (this.m_bInLongRange)
			SetVariantString("4.0");
		else
			SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		if (this.m_bInInvisible)
			SetEntityRenderColor(this.m_iWearable5, 0, 0, 0, 0, false, true, true);
		
		this.PlayMeleeDrawSound();
	}
	
	/*///////////////////////////////////////////////////////
					MELEE SECTION
														*/
	
	public bool UpdateLogic() {
		bool checked = this.m_bInFlameSlash;
		checked = this.m_bInHachetMann ? checked : true;
		checked = this.m_bInKacrackleSlash ? checked : true;
		checked = this.m_bInThwack ? checked : true;
		checked = this.m_bInMetalSlash ? checked : true;
		
		checked = this.m_bInLongRange ? checked : true;
		checked = this.m_bInPowerfullHit ? checked : true;
		checked = this.m_bInToxic ? checked : true;
		checked = this.m_bInInvisible ? checked : true;
		checked = this.m_bInSpeed ? checked : true;
		checked = this.m_bInFrozen ? checked : true;
		checked = this.m_bInFireBreath ? checked : true;
		checked = this.m_bInScaryBullets ? checked : true;
		checked = this.m_bInFastHand ? checked : true;
		checked = this.m_bInExtraAmmo ? checked : true;
		
		if (this.m_bInBumperCar)
		{
			checked = this.m_bInBumperCarAnimStart ? checked : true;
			if (!this.m_bInBumperNextCharge)
				checked = this.m_bInBumperCarCharging ? checked : true;
		}
		else
			checked = this.m_bInBumperCarAnimEnd ? checked : true;
			
		
		checked = this.m_bInPsycheUp ? checked : true;
		checked = this.m_bInOomph ? checked : true;
		checked = this.m_bInAcceleratle ? checked : true;
		checked = this.m_bInBounce ? checked : true;
		
		if (this.m_flFlameCheck <= GetGameTime())
		{
			this.m_flFlameCheck = GetGameTime() + 1.0;
			
			for(int client_check=1; client_check<=MaxClients; client_check++)
			{
				if(IsClientInGame(client_check) && !IsFakeClient(client_check))
				{
					if (TF2_IsPlayerInCondition(client_check, TFCond_OnFire) || TF2_IsPlayerInCondition(client_check, TFCond_BurningPyro)) // I see you pyro
					{
						SDKHooks_TakeDamage(client_check, this.index, this.index, 5.0 * RaidModeScaling, DMG_SLOWBURN, -1);
					}
				}
			}
		}
		if (this.m_flToxicCheck <= GetGameTime(this.index) && this.m_bInToxic)
		{
			this.m_flToxicCheck = GetGameTime(this.index) + 0.2;
			
			for(int client_check=1; client_check<=MaxClients; client_check++)
			{
				if(IsClientInGame(client_check) && !IsFakeClient(client_check))
				{
					if (GetVectorDistance(WorldSpaceCenter(client_check), WorldSpaceCenter(this.index), true) <= Pow(500.0, 2.0))
					{
						SDKHooks_TakeDamage(client_check, this.index, this.index, 1.0 * RaidModeScaling, DMG_CLUB, -1);
					}
				}
			}
		}
		return checked;
	}
	
	public void GiveFS() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/weapons/c_models/c_frying_pan/c_frying_pan.mdl");
		if (this.m_bInLongRange)
			SetVariantString("4.0");
		else
			SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		if (this.m_bInInvisible)
			SetEntityRenderColor(this.m_iWearable5, 0, 0, 0, 0, false, true, true);
		
		this.PlayMeleeDrawSound();
	}
	
	public void GiveHM() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/workshop/weapons/c_models/c_croc_knife/c_croc_knife.mdl");
		if (this.m_bInLongRange)
			SetVariantString("4.0");
		else
			SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		if (this.m_bInInvisible)
			SetEntityRenderColor(this.m_iWearable5, 0, 0, 0, 0, false, true, true);
		
		this.PlayMeleeDrawSound();
	}
	
	public void GiveKS() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/weapons/c_models/c_8mm_camera/c_8mm_camera.mdl");
		if (this.m_bInLongRange)
			SetVariantString("4.0");
		else
			SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		if (this.m_bInInvisible)
			SetEntityRenderColor(this.m_iWearable5, 0, 0, 0, 0, false, true, true);
		
		this.PlayMeleeDrawSound();
	}
	
	public void GiveThwack() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/workshop/weapons/c_models/c_skullbat/c_skullbat.mdl");
		if (this.m_bInLongRange)
			SetVariantString("4.0");
		else
			SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		if (this.m_bInInvisible)
			SetEntityRenderColor(this.m_iWearable5, 0, 0, 0, 0, false, true, true);
		
		this.PlayMeleeDrawSound();
	}
	
	public void GiveMS() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/workshop/weapons/c_models/c_crossing_guard/c_crossing_guard.mdl");
		if (this.m_bInLongRange)
			SetVariantString("4.0");
		else
			SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		if (this.m_bInInvisible)
			SetEntityRenderColor(this.m_iWearable5, 0, 0, 0, 0, false, true, true);
		
		this.PlayMeleeDrawSound();
	}
	
	
	
	public void AddLongRange() {
		
		if(!IsValidEntity(this.m_iWearable5))
			return;
		
		SetVariantString("4.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		//this.PlayMeleeDrawSound();
	}
	
	public void ResetLongRange() {
		
		if(!IsValidEntity(this.m_iWearable5))
			return;
		
		SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		//this.PlayMeleeDrawSound();
	}
	
	public void DejaVu()
	{
		this.m_flNextRtd = GetGameTime(this.index);
		this.m_flNextEvent = GetGameTime(this.index);
	}
	
	public void BeatThemUp()
	{
		// Thanks for that Deivid
		int maxHealth = RoundToCeil(GetEntProp(this.index, Prop_Data, "m_iMaxHealth")*0.05); // Not good and not bad
		float pos[3]; GetEntPropVector(this.index, Prop_Data, "m_vecAbsOrigin", pos);
		float ang[3]; GetEntPropVector(this.index, Prop_Data, "m_angRotation", ang);
		
		// I'll make spawn like 5
		for (int c = 0; c < 5; c++)
		{
			int spawn_index = Npc_Create(RND_SCOUT, -1, pos, ang, GetEntProp(this.index, Prop_Send, "m_iTeamNum") == 2);
			Zombies_Currently_Still_Ongoing += 1;
			if(spawn_index > MaxClients)	//Currently always spawns.
			{
			
				SetEntProp(spawn_index, Prop_Data, "m_iHealth", maxHealth);
				SetEntProp(spawn_index, Prop_Data, "m_iMaxHealth", maxHealth);
			}
		}
	}
	
	/*
	enum Tocksick_RTD_Type {
		Tocksick_RTD_LongRange = 0,	// A cool multiplier aka lag experience
		Tocksick_RTD_PowerFullHit,	// A not cool multiplier
		Tocksick_RTD_Toxic, 		// Toxic tocksick (: (it's 4 am, pls don't judge me)
		Tocksick_RTD_Invisible, 	// Fun fact, invisible and frozen rtd match together, that's all... this is not really fun afterwards...
		Tocksick_RTD_Speed, 		// Fun fact, this does nothing when frozen
		Tocksick_RTD_Frozen, 		// idk if you know, but frozen and invisible match together, well now you know
		Tocksick_RTD_Firebreath,	// At the same time the worst and the best rtd, to code, and to play against
		Tocksick_RTD_ScaryBullet,	// Artvin, my man, don't kill me for that pls
		Tocksick_RTD_FastHand,		// An insane multiplier
		Tocksick_RTD_ExtraAmmo,		// You know what we need 6 times more chaos
		Tocksick_RTD_BumperCar,		// why I'm doing that? just to suffer? (actually, I just want to see a giant npc in a kart)
		Tocksick_RTD_NecroSmash,	// Why everytime I read that, dark jokes come in my mind?
		Tocksick_RTD_DejaVu,		// Fun fact, this is french (déjà vu) which mean already seen, but no one cares because no one likes french
		Tocksick_RTD_LuckyThrow,	// I'm so hyped for this one (I need more chaos!)
		Tocksick_RTD_Portals		// Well, this one is just here but does nothing rn
	}
	
	enum Tocksick_Ability_Type {
		Tocksick_Ability_PsycheUp = 0,
		Tocksick_Ability_Oomph,
		Tocksick_Ability_Acceleratle,
		Tocksick_Ability_Bounce,
		Tocksick_Ability_Ducks,
		Tocksick_Ability_BadAnalyse,
		Tocksick_Ability_GoodAnalyse,
		Tocksick_Ability_MVM,
		Tocksick_Ability_BeatThemUp,
		Tocksick_Ability_WhoTouched,
		Tocksick_Ability_BUSTER,
		Tocksick_Ability_Tactical,
		Tocksick_Ability_Sacrifice,
		Tocksick_Ability_CriticalThink,
	}
*/
	
	public void LuckyThrow()
	{
		switch(GetRandomInt(0, 1))
		{
			//npc.m_flLongRangeDuration = GetGameTime(npc.index) + 8.0;
			//npc.m_flPowerfullHitDuration = GetGameTime(npc.index) + 5.0;
			//npc.m_flToxicDuration = GetGameTime(npc.index) + 9.0;
			//npc.m_flInvisibleDuration = GetGameTime(npc.index) + 10.0;
			//npc.m_flSpeedDuration = GetGameTime(npc.index) + 10.0;
			//npc.m_flFrozenDuration = GetGameTime(npc.index) + 5.0;
			//npc.m_flFireBreathDuration = GetGameTime(npc.index) + 10.0;
			//npc.m_flScaryBulletsDuration = GetGameTime(npc.index) + 7.0;
			//npc.m_flFastHandDuration = GetGameTime(npc.index) + 10.0;
			case 0: {
				this.m_flLongRangeDuration = GetGameTime(this.index) + 10.0;
				this.m_flPowerfullHitDuration = GetGameTime(this.index) + 10.0;
				this.m_flFastHandDuration = GetGameTime(this.index) + 10.0;
			}
			
			case 1: {
				this.m_flToxicDuration = GetGameTime(this.index) + 10.0;
				this.m_flInvisibleDuration = GetGameTime(this.index) + 10.0;
				this.m_flSpeedDuration = GetGameTime(this.index) + 10.0;
			}
			
			case 2: {
				// Tocksick_Ability_BUSTER
				// Tocksick_Ability_BUSTER
				// Tocksick_Ability_BUSTER
			}
			
			case 3: {
				// Tocksick_Ability_MVM
				// Tocksick_Ability_BeatThemUp
				// Tocksick_Ability_WhoTouched
				// Tocksick_Ability_BUSTER
			}
			
			case 4: {
				// Tocksick_Ability_MVM
				// Tocksick_Ability_BeatThemUp
				// Tocksick_Ability_WhoTouched
			}
		}
	}
	
	public void Portals()
	{
		int playerOrder[MAXTF2PLAYERS + 1];
		int playerNotOrder[MAXTF2PLAYERS + 1];
		int playerCount = 0;
		
		
		for (int target = 1; target <= MaxClients; target++)
		{
			if(IsValidClient(target))
			{
				if (!IsFakeClient(target))
				{
					playerOrder[playerCount] = target; // yeah, no shit for teuton
					playerNotOrder[playerCount] = target;
					playerCount++;
					
					char name[64];
					GetClientName(target, name, 64);
				}
			}
		}
		
		int scrambleTime = GetRandomInt(1, 3);
		for (int yes = 0; yes <= scrambleTime; yes++)
		{
			for (int place = 0; place < playerCount; place++)
			{
				int backOrder = playerNotOrder[place];
				int randomId = GetRandomInt(0, playerCount-1);
				
				playerNotOrder[place] = playerNotOrder[randomId];
				playerNotOrder[randomId] = backOrder;
			}
		}
		
		float flPos[MAXTF2PLAYERS + 1][3];
		float flAng[MAXTF2PLAYERS + 1][3];
		for (int storePos = 0; storePos < playerCount; storePos++)
		{
			GetClientAbsOrigin(playerNotOrder[storePos], flPos[storePos]);
			GetClientAbsAngles(playerNotOrder[storePos], flAng[storePos]);
		}
		
		for (int sortingId = 0; sortingId < playerCount; sortingId++)
		{
			TeleportEntity(playerOrder[sortingId], flPos[sortingId], flAng[sortingId], _);
		}
	}
	
	public void ResetPlayersCamera()
	{
		for (int target = 1; target <= MaxClients; target++)
		{
			if(IsValidClient(target))
			{
				if (!IsFakeClient(target))
				{
					SetClientViewEntity(target, target);
					//SetEntProp(target, Prop_Send, "m_iObserverMode", 1);
				}
			}
		}
	}
	
	/*///////////////////////////////////////////////////////
					Projectile SECTION
														*/
	// I love when other devs make my life easier, thanks you
	public int UseProjectile(float vecTarget[3], float vPredictedPos[3], float Scale, Tocksick_Projectile_Type iProjectileMode) {
		float baseDmg = 4.0;
		float baseSpeed = 700.0;
		char modelProj[124];
		strcopy(modelProj, 124, "");
		
		switch(iProjectileMode)
		{
			case Tocksick_Projectile_Bang:
			{
				baseDmg = 5.0;
				baseSpeed = 850.0;
			}
			
			case Tocksick_Projectile_Kaboom:
			{
				baseDmg = 6.0;
				baseSpeed = 700.0;
			}
			
			case Tocksick_Projectile_Sizz:
			{
				baseDmg = 4.0;
				baseSpeed = 1100.0;
			}
			
			case Tocksick_Projectile_Sizzle:
			{
				baseDmg = 5.0;
				baseSpeed = 1000.0;
			}
			
			case Tocksick_Projectile_Whack:
			{
				baseDmg = 10.0;
				baseSpeed = 500.0;
				strcopy(modelProj, 124, "models/weapons/c_models/c_drg_cowmangler/c_drg_cowmangler.mdl");
			}
		}
		
		this.FaceTowards(vecTarget);
		this.FaceTowards(vecTarget);
		this.FireRocket(vPredictedPos, baseDmg * Scale, baseSpeed, modelProj, 1.0);	
		
		if (this.m_bInBumperCar)
			this.AddGestureViaSequence("taunt_vehicle_allclass_honk");
		else
			this.AddGesture("ACT_MP_THROW");
		
		// TODO: sound here too
	}									
	
	public char[] getRtdEffects()
	{
		char buffAdder[16];
		if (this.m_bInLongRange)
			Format(buffAdder, 16, "%s%s", buffAdder, "⛢");
			
		if (this.m_bInPowerfullHit)
			Format(buffAdder, 16, "%s%s", buffAdder, "☠");
			
		if (this.m_bInToxic)
			Format(buffAdder, 16, "%s%s", buffAdder, "☣");
			
		if (this.m_bInInvisible)
			Format(buffAdder, 16, "%s%s", buffAdder, "⯑");
		
		if (this.m_bInSpeed)
			Format(buffAdder, 16, "%s%s", buffAdder, "↠");
		
		if (this.m_bInFrozen)
			Format(buffAdder, 16, "%s%s", buffAdder, "⛄");
			
		if (this.m_bInFireBreath)
			Format(buffAdder, 16, "%s%s", buffAdder, "☀");
			
		//TODO: finish fire breath when all sound are done
		
		if (this.m_bInScaryBullets)
			Format(buffAdder, 16, "%s%s", buffAdder, "⛓");
			
		if (this.m_bInFastHand)
			Format(buffAdder, 16, "%s%s", buffAdder, "☞");
			
		if (this.m_bInBumperCar)
			Format(buffAdder, 16, "%s%s", buffAdder, "⛐");
		
		if (this.m_bInExtraAmmo)
		{
			switch(this.m_iExtraAmmo)
			{
				case 1: Format(buffAdder, 16, "%s%s", buffAdder, "⚀");
				case 2: Format(buffAdder, 16, "%s%s", buffAdder, "⚁");
				case 3: Format(buffAdder, 16, "%s%s", buffAdder, "⚂");
				case 4: Format(buffAdder, 16, "%s%s", buffAdder, "⚃");
				case 5: Format(buffAdder, 16, "%s%s", buffAdder, "⚄");
				case 6: Format(buffAdder, 16, "%s%s", buffAdder, "⚅");
			}
		}
		
		if (StrEqual(buffAdder, NULL_STRING))
			strcopy(buffAdder, 16, "None");
		return buffAdder;
	}
	
	public char[] getAbilityEffects()
	{
		char buffAdder[16];
		
		if (this.m_bInPsycheUp)
			Format(buffAdder, 16, "%s%s", buffAdder, "☄");
		
		if (this.m_bInOomph)
		{
			switch(this.m_iOomphCount)
			{
				case 0: Format(buffAdder, 16, "%s%s", buffAdder, "♺");
				case 1: Format(buffAdder, 16, "%s%s", buffAdder, "♳");
				case 2: Format(buffAdder, 16, "%s%s", buffAdder, "♴");
				case 3: Format(buffAdder, 16, "%s%s", buffAdder, "♵");
				case 4: Format(buffAdder, 16, "%s%s", buffAdder, "♶");
				case 5: Format(buffAdder, 16, "%s%s", buffAdder, "♷");
			}
		}
		
		if (this.m_bInAcceleratle)
			Format(buffAdder, 16, "%s%s", buffAdder, "➠");
			
		if (this.m_bInBounce)
			Format(buffAdder, 16, "%s%s", buffAdder, "⛨");
		
		if (StrEqual(buffAdder, NULL_STRING))
			strcopy(buffAdder, 16, "None");
		return buffAdder;
	}
	
	public Tocksick_RTD_Type getRandomRTD()
	{
		Tocksick_RTD_Type abilityType[Tocksick_RTD_Type];
		int currentLenght = 0;
		
		if (!this.m_bInLongRange)
		{
			abilityType[currentLenght] = Tocksick_RTD_LongRange;
			currentLenght += 1;
		}
		
		if (!this.m_bInPowerfullHit)
		{
			abilityType[currentLenght] = Tocksick_RTD_PowerFullHit;
			currentLenght += 1;
		}
		
		if (!this.m_bInToxic)
		{
			abilityType[currentLenght] = Tocksick_RTD_Toxic;
			currentLenght += 1;
		}
		
		if (!this.m_bInInvisible)
		{
			abilityType[currentLenght] = Tocksick_RTD_Invisible;
			currentLenght += 1;
		}
		
		if (!this.m_bInSpeed)
		{
			abilityType[currentLenght] = Tocksick_RTD_Speed;
			currentLenght += 1;
		}
		
		if (!this.m_bInFrozen)
		{
			abilityType[currentLenght] = Tocksick_RTD_Frozen;
			currentLenght += 1;
		}
		
		if (!this.m_bInFireBreath)
		{
			abilityType[currentLenght] = Tocksick_RTD_Firebreath;
			currentLenght += 1;
		}
		
		if (!this.m_bInScaryBullets)
		{
			abilityType[currentLenght] = Tocksick_RTD_ScaryBullet;
			currentLenght += 1;
		}
		
		if (!this.m_bInFastHand)
		{
			abilityType[currentLenght] = Tocksick_RTD_FastHand;
			currentLenght += 1;
		}
		
		if (!this.m_bInExtraAmmo)
		{
			abilityType[currentLenght] = Tocksick_RTD_ExtraAmmo;
			currentLenght += 1;
		}
		
		if (!this.m_bInBumperCar)
		{
			abilityType[currentLenght] = Tocksick_RTD_BumperCar;
			currentLenght += 1;
		}
		
		
		abilityType[currentLenght] = Tocksick_RTD_NecroSmash;
		currentLenght += 1;
		abilityType[currentLenght] = Tocksick_RTD_DejaVu;
		currentLenght += 1;
		abilityType[currentLenght] = Tocksick_RTD_LuckyThrow;
		currentLenght += 1;
		abilityType[currentLenght] = Tocksick_RTD_Portals;
		currentLenght += 1;
		
		return abilityType[GetRandomInt(0, currentLenght-1)];
	}
	
	public Tocksick_Ability_Type getRandomAbility()
	{
		Tocksick_Ability_Type abilityType[Tocksick_Ability_Type];
		int currentLenght = 0;
		
		
		if (!this.m_bInPsycheUp)
		{
			abilityType[currentLenght] = Tocksick_Ability_PsycheUp;
			currentLenght += 1;
		}
		
		if (!this.m_bInOomph)
		{
			abilityType[currentLenght] = Tocksick_Ability_Oomph;
			currentLenght += 1;
		}
		
		if (!this.m_bInAcceleratle)
		{
			abilityType[currentLenght] = Tocksick_Ability_Acceleratle;
			currentLenght += 1;
		}
		
		if (!this.m_bInBounce)
		{
			abilityType[currentLenght] = Tocksick_Ability_Bounce;
			currentLenght += 1;
		}
		
		
		abilityType[currentLenght] = Tocksick_Ability_BeatThemUp;
		currentLenght += 1;
		
		return abilityType[GetRandomInt(0, currentLenght-1)];
	}
	
	public TrueTocksick(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		TrueTocksick npc = view_as<TrueTocksick>(CClotBody(vecPos, vecAng, "models/player/medic.mdl", "1.35", "25000", ally, false, true, true,true)); //giant!
		
		i_NpcInternalId[npc.index] = RAIDMODE_TRUE_TOCKSICK;
		
		FormatEx(c_HeadPlaceAttachmentGibName[npc.index], sizeof(c_HeadPlaceAttachmentGibName[]), "head");
		
		RaidBossActive = EntIndexToEntRef(npc.index);
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		
		EmitSoundToAll("vo/medic_specialcompleted02.mp3", _, _, _, _, 1.0, SNDPITCH_LOW);	
		EmitSoundToAll("vo/medic_specialcompleted02.mp3", _, _, _, _, 1.0, SNDPITCH_LOW);	
		
		for(int client_check=1; client_check<=MaxClients; client_check++)
		{
			if(IsClientInGame(client_check) && !IsFakeClient(client_check))
			{
				LookAtTarget(client_check, npc.index);
				SetGlobalTransTarget(client_check);
				ShowGameText(client_check, "item_armor", 1, "%t", "True Tocksick Doctor Spawn");
			}
		}
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_GIANT;	
		npc.m_iNpcStepVariation = STEPSOUND_NORMAL;		
		
		npc.m_bThisNpcIsABoss = true;
		
		RaidModeTime = GetGameTime(npc.index) + 200.0;
		
		RaidModeScaling = float(ZR_GetWaveCount()+1);
		
		if(RaidModeScaling < 55)
		{
			RaidModeScaling *= 0.17; //abit low, inreacing
		}
		else
		{
			RaidModeScaling *= 0.34;
		}
		
		float amount_of_people = float(CountPlayersOnRed());
		
		amount_of_people *= 0.11;
		
		if(amount_of_people < 1.0)
			amount_of_people = 1.0;
			
		RaidModeScaling *= amount_of_people; //More then 9 and he raidboss gets some troubles, bufffffffff
		
		Raidboss_Clean_Everyone();
		
		SDKHook(npc.index, SDKHook_Think, TrueTocksick_ClotThink);
		SDKHook(npc.index, SDKHook_OnTakeDamage, TrueTocksick_ClotDamaged);
		
		
		
		int skin = 5;
		SetEntProp(npc.index, Prop_Send, "m_nSkin", skin);
		
		npc.m_iWearable1 = npc.EquipItem("head", "models/player/items/medic/medic_zombie.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		SetEntProp(npc.m_iWearable1, Prop_Send, "m_nSkin", 1);
		
		/* Color doesn't works, will be reserved for bumper car
		npc.m_iWearable2 = npc.EquipItem("head", "models/player/items/medic/medic_blighted_beak.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		SetEntProp(npc.m_iWearable2, Prop_Send, "m_nSkin", 1);
		*/
		
		npc.m_iWearable3 = npc.EquipItem("head", "models/workshop/player/items/medic/sf14_medic_herzensbrecher/sf14_medic_herzensbrecher.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable3, "SetModelScale");
		SetEntProp(npc.m_iWearable3, Prop_Send, "m_nSkin", 1);
		
		
		
		npc.m_iWearable4 = npc.EquipItem("head", "models/workshop/player/items/medic/medic_gasmask/medic_gasmask.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable4, "SetModelScale");
		SetEntProp(npc.m_iWearable4, Prop_Send, "m_nSkin", 1);
		
		
		npc.m_iWearable5 = npc.EquipItem("head","models/weapons/c_models/c_ubersaw/c_ubersaw_xmas.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable5, "SetModelScale");
		SetEntProp(npc.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		npc.m_iWearable6 = npc.EquipItem("head","models/workshop/player/items/medic/jul13_madmans_mop/jul13_madmans_mop.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable6, "SetModelScale");
		
		SetEntityRenderMode(npc.index, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.index, 10, 50, 10, 255);
		
		SetEntityRenderMode(npc.m_iWearable1, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable1, 10, 50, 10, 255);
		
		/*
		SetEntityRenderMode(npc.m_iWearable2, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable2, 50, 250, 50, 255);
		*/
		
		SetEntityRenderMode(npc.m_iWearable3, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable3, 50, 100, 50, 255);
		SetEntityRenderMode(npc.m_iWearable4, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable4, 100, 100, 100, 255);
		SetEntityRenderMode(npc.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable5, 192, 192, 192, 255);
		SetEntityRenderMode(npc.m_iWearable6, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable6, 150, 200, 150, 255);
		
		npc.m_iTeamGlow = TF2_CreateGlow(npc.index);
			
		SetVariantColor(view_as<int>({255, 255, 255, 200}));
		AcceptEntityInput(npc.m_iTeamGlow, "SetGlowColor");
		
		
		//IDLE
		npc.m_flSpeed = 330.0;
		
		npc.m_flFlameCheck = GetGameTime(npc.index) + 2.0;
		npc.m_bInFlameSlash = false;
		npc.m_bInHachetMann = false;
		npc.m_bInKacrackleSlash = false;
		npc.m_bInThwack = false;
		npc.m_bInMetalSlash = false;
		npc.m_flNextEventMelee = GetGameTime(npc.index) + 4.0;
		
		npc.m_flNextProjectile = GetGameTime(npc.index) + 5.0;
		
		npc.m_bInLongRange = false;
		npc.m_bInPowerfullHit = false;
		npc.m_bInToxic = false;
		npc.m_bInInvisible = false;
		npc.m_bInSpeed = false;
		npc.m_bInFrozen = false;
		npc.m_bInFireBreath = false;
		npc.m_bInScaryBullets = false;
		npc.m_bInFastHand = false;
		npc.m_bInExtraAmmo = false;
		npc.m_bInBumperCar = false;
		npc.m_flNextRtd = GetGameTime(npc.index) + 2.0;
		
		npc.m_bInPsycheUp = false;
		npc.m_bInOomph = false;
		npc.m_bInAcceleratle = false;
		npc.m_bInBounce = false;
		npc.m_flNextEvent = GetGameTime(npc.index) + 6.0;
		
		
		Citizen_MiniBossSpawn(npc.index);
		
		return npc;
	}
}

//TODO 
//Rewrite
public void TrueTocksick_ClotThink(int iNPC)
{
	TrueTocksick npc = view_as<TrueTocksick>(iNPC);
	
	if(RaidModeTime < GetGameTime())
	{
		int entity = CreateEntityByName("game_round_win"); //You loose.
		DispatchKeyValue(entity, "force_map_reset", "1");
		SetEntProp(entity, Prop_Data, "m_iTeamNum", TFTeam_Blue);
		DispatchSpawn(entity);
		AcceptEntityInput(entity, "RoundWin");
		Music_RoundEnd(entity);
		RaidBossActive = INVALID_ENT_REFERENCE;
		SDKUnhook(npc.index, SDKHook_Think, TrueTocksick_ClotThink);
	}

	if(npc.m_flNextDelayTime > GetGameTime(npc.index))
	{
		return;
	}
	
	npc.m_flNextDelayTime = GetGameTime(npc.index) + DEFAULT_UPDATE_DELAY_FLOAT;
	
	if (!npc.m_bInFrozen)
		npc.Update();
	
	//Think throttling
	if(npc.m_flNextThinkTime > GetGameTime(npc.index)) {
		return;
	}
	if(npc.m_blPlayHurtAnimation && !npc.m_bInFrozen)
	{
		npc.AddGesture("ACT_MP_GESTURE_FLINCH_CHEST", false);
		npc.PlayHurtSound();
		npc.m_blPlayHurtAnimation = false;
	}
	
	npc.m_flNextThinkTime = GetGameTime(npc.index) + 0.10;
	
	npc.UpdateLogic();	
	if (npc.m_flNextEventMelee <= GetGameTime(npc.index))
	{		
		switch(GetRandomInt(0, 4))
		{
			case 0: npc.m_flFlameSlashDuration = GetGameTime(npc.index) + 4.0;
			case 1: npc.m_flHachetMannDuration = GetGameTime(npc.index) + 4.0;
			case 2: npc.m_flKacrackleSlashDuration = GetGameTime(npc.index) + 4.0;
			case 3: npc.m_flThwackDuration = GetGameTime(npc.index) + 4.0;
			case 4: npc.m_flMetalSlashDuration = GetGameTime(npc.index) + 4.0;
		}
		npc.m_flNextEventMelee = GetGameTime(npc.index) + 8.0;
	}
	
	if (npc.m_flNextRtd <= GetGameTime(npc.index))
	{
		Tocksick_RTD_Type RTD = npc.getRandomRTD();
		
		switch(RTD)
		{
			case Tocksick_RTD_LongRange: npc.m_flLongRangeDuration = GetGameTime(npc.index) + 8.0;
			case Tocksick_RTD_PowerFullHit: npc.m_flPowerfullHitDuration = GetGameTime(npc.index) + 5.0;
			case Tocksick_RTD_Toxic: npc.m_flToxicDuration = GetGameTime(npc.index) + 9.0;
			case Tocksick_RTD_Invisible: npc.m_flInvisibleDuration = GetGameTime(npc.index) + 10.0;
			case Tocksick_RTD_Speed: npc.m_flSpeedDuration = GetGameTime(npc.index) + 10.0;
			case Tocksick_RTD_Frozen: npc.m_flFrozenDuration = GetGameTime(npc.index) + 5.0;
			case Tocksick_RTD_Firebreath: npc.m_flFireBreathDuration = GetGameTime(npc.index) + 10.0;
			case Tocksick_RTD_ScaryBullet: npc.m_flScaryBulletsDuration = GetGameTime(npc.index) + 7.0;
			case Tocksick_RTD_FastHand: npc.m_flFastHandDuration = GetGameTime(npc.index) + 10.0;
			case Tocksick_RTD_ExtraAmmo: npc.m_flExtraAmmoDuration = GetGameTime(npc.index) + 20.0;
			case Tocksick_RTD_BumperCar: npc.m_flBumperCarDuration = GetGameTime(npc.index) + 10.0;
			case Tocksick_RTD_NecroSmash: NecroMash_SmashClient(npc.index);
			case Tocksick_RTD_DejaVu: npc.DejaVu();
			case Tocksick_RTD_LuckyThrow: npc.LuckyThrow();
			case Tocksick_RTD_Portals:npc.Portals();
		}
		
		if (npc.m_bInExtraAmmo)
		{
			for (int extra_ability = 1; extra_ability <= npc.m_iExtraAmmo; extra_ability++)
			{
				Tocksick_RTD_Type extraRTD = npc.getRandomRTD();
				
				switch(extraRTD)
				{
					case Tocksick_RTD_LongRange: npc.m_flLongRangeDuration = GetGameTime(npc.index) + 8.0;
					case Tocksick_RTD_PowerFullHit: npc.m_flPowerfullHitDuration = GetGameTime(npc.index) + 5.0;
					case Tocksick_RTD_Toxic: npc.m_flToxicDuration = GetGameTime(npc.index) + 9.0;
					case Tocksick_RTD_Invisible: npc.m_flInvisibleDuration = GetGameTime(npc.index) + 10.0;
					case Tocksick_RTD_Speed: npc.m_flSpeedDuration = GetGameTime(npc.index) + 10.0;
					case Tocksick_RTD_Frozen: npc.m_flFrozenDuration = GetGameTime(npc.index) + 5.0;
					case Tocksick_RTD_Firebreath: npc.m_flFireBreathDuration = GetGameTime(npc.index) + 10.0;
					case Tocksick_RTD_ScaryBullet: npc.m_flScaryBulletsDuration = GetGameTime(npc.index) + 7.0;
					case Tocksick_RTD_FastHand: npc.m_flFastHandDuration = GetGameTime(npc.index) + 10.0;
					case Tocksick_RTD_ExtraAmmo: npc.m_flExtraAmmoDuration = GetGameTime(npc.index) + 20.0;
					case Tocksick_RTD_BumperCar: npc.m_flBumperCarDuration = GetGameTime(npc.index) + 10.0;
					case Tocksick_RTD_NecroSmash: NecroMash_SmashClient(npc.index);
					case Tocksick_RTD_DejaVu: npc.DejaVu();
					case Tocksick_RTD_LuckyThrow: npc.LuckyThrow();
					case Tocksick_RTD_Portals:npc.Portals();
				}
			}
		}
		
		npc.m_flNextRtd = GetGameTime(npc.index) + 15.0;
	}
	
	if (npc.m_flNextEvent <= GetGameTime(npc.index))
	{
		
		Tocksick_Ability_Type ability = npc.getRandomAbility();
		
		switch(ability)
		{
			case Tocksick_Ability_PsycheUp: npc.m_flPsycheUpDuration = GetGameTime(npc.index) + 10.0;
			case Tocksick_Ability_Oomph: npc.m_flOomphDuration = GetGameTime(npc.index) + 11.0;
			case Tocksick_Ability_Acceleratle: npc.m_flAcceleratleDuration = GetGameTime(npc.index) + 10.0;
			case Tocksick_Ability_Bounce: npc.m_flBounceDuration = GetGameTime(npc.index) + 11.0;
			case Tocksick_Ability_BeatThemUp: npc.BeatThemUp();
		}
		
		if (npc.m_bInExtraAmmo)
		{
			for (int extra_ability = 1; extra_ability <= npc.m_iExtraAmmo; extra_ability++)
			{
				Tocksick_Ability_Type extra = npc.getRandomAbility();
		
				switch(extra)
				{
					case Tocksick_Ability_PsycheUp: npc.m_flPsycheUpDuration = GetGameTime(npc.index) + 10.0;
					case Tocksick_Ability_Oomph: npc.m_flOomphDuration = GetGameTime(npc.index) + 11.0;
					case Tocksick_Ability_Acceleratle: npc.m_flAcceleratleDuration = GetGameTime(npc.index) + 10.0;
					case Tocksick_Ability_Bounce: npc.m_flBounceDuration = GetGameTime(npc.index) + 11.0;
					case Tocksick_Ability_BeatThemUp: npc.BeatThemUp();
				}
			}
		}
		
		npc.m_flNextEvent = GetGameTime(npc.index) + 12.0;
	}

	if (npc.m_bInFrozen)
		return;

	if(npc.m_flGetClosestTargetTime < GetGameTime(npc.index))
	{
		npc.m_iTarget = GetClosestTarget(npc.index);
		npc.m_flGetClosestTargetTime = GetGameTime(npc.index) + 1.0;
	}
	
	int closest = npc.m_iTarget;
	
	

	if(IsValidEnemy(npc.index, closest, true))
	{
		
		float vecTarget[3]; vecTarget = WorldSpaceCenter(closest);
	
		float flDistanceToTarget = GetVectorDistance(vecTarget, WorldSpaceCenter(npc.index), true);
		
		float vPredictedPos[3]; vPredictedPos = PredictSubjectPosition(npc, closest, 0.3);
	
		//Body pitch
//		if(flDistanceToTarget < Pow(110.0,2.0))
		{
			int iPitch = npc.LookupPoseParameter("body_pitch");
			if(iPitch < 0)
				return;		
		
			//Body pitch
			float v[3], ang[3];
			SubtractVectors(WorldSpaceCenter(npc.index), WorldSpaceCenter(closest), v); 
			NormalizeVector(v, v);
			GetVectorAngles(v, ang); 
			
			float flPitch = npc.GetPoseParameter(iPitch);
			
		//	ang[0] = clamp(ang[0], -44.0, 89.0);
			npc.SetPoseParameter(iPitch, ApproachAngle(ang[0], flPitch, 10.0));
		}
			
		if(flDistanceToTarget < npc.GetLeadRadius()) {
			
		/*	int color[4];
			color[0] = 255;
			color[1] = 255;
			color[2] = 0;
			color[3] = 255;
		
			int xd = PrecacheModel("materials/sprites/laserbeam.vmt");
		
			TE_SetupBeamPoints(vPredictedPos, vecTarget, xd, xd, 0, 0, 0.25, 0.5, 0.5, 5, 5.0, color, 30);
			TE_SendToAllInRange(vecTarget, RangeType_Visibility);*/
			
			PF_SetGoalVector(npc.index, vPredictedPos);
		} else {
			PF_SetGoalEntity(npc.index, closest);
		}
		
		
		if (npc.m_flNextProjectile <= GetGameTime(npc.index))
		{
			npc.m_flNextProjectile = GetGameTime(npc.index) + 5.0;
			npc.UseProjectile(vecTarget, vPredictedPos, RaidModeScaling, view_as<Tocksick_Projectile_Type>(GetRandomInt(0,4)));
		}
		
		float minDistance = 125.0;
		if (npc.m_bInBumperCar)
		{
			if (npc.m_bInBumperCarCharging && flDistanceToTarget < Pow(minDistance, 2.0))
			{
				npc.m_bInBumperCarCharging = false;
				npc.AddGesture("ACT_KART_IMPACT_BIG");
				// TODO: sound
				
				Handle swingTrace;
				npc.FaceTowards(vecTarget, 5000.0);
				if(npc.DoSwingTrace(swingTrace, closest,_,_,_,1))
				{
					int target = TR_GetEntityIndex(swingTrace);	
							
					float vecHit[3];
					TR_GetEndPosition(vecHit, swingTrace);
					
					if(target > MaxClients)
					{
						SDKHooks_TakeDamage(target, npc.index, npc.index, 20.0 * RaidModeScaling * 10.0, DMG_CLUB, -1, _, vecHit);
					}
					else
					{
						SDKHooks_TakeDamage(target, npc.index, npc.index, 25.0 * RaidModeScaling * 10.0, DMG_CLUB, -1, _, vecHit);
					}
					
					if(IsValidClient(target))
					{
						Custom_Knockback(npc.index, target, 1500.0, true);
						TF2_AddCondition(target, TFCond_LostFooting, 0.5);
						TF2_AddCondition(target, TFCond_AirCurrent, 0.5);
					}
				}
			}
		}
		
		if (npc.m_bInLongRange)
			minDistance *= 4;
		//Target close enough to hit
		if(flDistanceToTarget < Pow(minDistance, 2.0) || npc.m_flAttackHappenswillhappen)
		{
			//Look at target so we hit.
			//Can we attack right now?
			if(npc.m_flNextMeleeAttack < GetGameTime(npc.index))
			{
				if (!npc.m_flAttackHappenswillhappen)
				{
					npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE", false);
					npc.PlayMeleeSound();
					
					
					npc.m_flAttackHappens = GetGameTime(npc.index)+0.3;
					npc.m_flAttackHappens_bullshit = GetGameTime(npc.index)+0.44;
					
					
					npc.m_flAttackHappenswillhappen = true;
				}
					
				if (npc.m_flAttackHappens < GetGameTime(npc.index) && npc.m_flAttackHappens_bullshit >= GetGameTime(npc.index) && npc.m_flAttackHappenswillhappen)
				{
					Handle swingTrace;
					npc.FaceTowards(vecTarget, 5000.0);
					if((npc.DoSwingTrace(swingTrace, closest,{ 500.0, 500.0, 500.0 },{ 500.0, 500.0, 500.0 }) && npc.m_bInLongRange) || (npc.DoSwingTrace(swingTrace, closest,_,_,_,1) && !npc.m_bInLongRange))
						{
							
							int target = TR_GetEntityIndex(swingTrace);	
							
							float vecHit[3];
							TR_GetEndPosition(vecHit, swingTrace);
							
							if(target > 0) 
							{
								npc.PlayMeleeHitSound();
								
								if(target > MaxClients)
								{
									SDKHooks_TakeDamage(target, npc.index, npc.index, 12.0 * RaidModeScaling * 10.0, DMG_CLUB, -1, _, vecHit);
								}
								else
								{
									float baseDmg = 16.0; // this needs to be low, too much dmg mult
									
									if (npc.m_bInHachetMann)
									{
										baseDmg *= 2.3;
										npc.m_bInHachetMann = false;
									}
									
									if (npc.m_bInThwack)
									{
										if (GetEntProp(target, Prop_Data, "m_iMaxHealth")*0.2 >= GetEntProp(target, Prop_Data, "m_iHealth"))
										{
											baseDmg = 5000.0;
										}
										npc.m_bInThwack = false;
									}
									
									if (npc.m_bInMetalSlash)
									{
										baseDmg = GetEntProp(target, Prop_Data, "m_iMaxHealth")*0.4;
										npc.m_bInMetalSlash = false;
									}
									
									if (npc.m_bInPowerfullHit)
									{
										baseDmg *= 2.5;
									}
									
									if (npc.m_bInPsycheUp)
									{
										baseDmg *= 1.35;
									}
									
									if (npc.m_bInOomph)
									{
										baseDmg *= (GetRandomFloat(1.5, 3.0) / (npc.m_iOomphCount + 1));
										npc.m_iOomphCount += 1;
									}
									
									
									SDKHooks_TakeDamage(target, npc.index, npc.index, baseDmg* RaidModeScaling, DMG_CLUB, -1, _, vecHit);
									
									if (npc.m_bInFlameSlash)
									{
										TF2_AddCondition(target, TFCond_BurningPyro, 8.0);
										TF2_IgnitePlayer(target, target, 8.0);
										npc.m_bInFlameSlash = false;
									}
									
									if (npc.m_bInKacrackleSlash)
									{
										TF2_StunPlayer(target, 2.0, 1.0, TF_STUNFLAGS_NORMALBONK);
										npc.m_bInKacrackleSlash = false;
									}
									
									if (npc.m_bInScaryBullets)
									{
										TF2_StunPlayer(target, 1.0, 0.2, TF_STUNFLAGS_GHOSTSCARE);
									}
								}
								
								
								if(IsValidClient(target))
								{
									if (IsInvuln(target))
									{
										Custom_Knockback(npc.index, target, 900.0, true);
										TF2_AddCondition(target, TFCond_LostFooting, 0.5);
										TF2_AddCondition(target, TFCond_AirCurrent, 0.5);
									}
									else
									{
										Custom_Knockback(npc.index, target, 300.0); 
										TF2_AddCondition(target, TFCond_LostFooting, 0.5);
										TF2_AddCondition(target, TFCond_AirCurrent, 0.5);
									}
								}
							} 
						}
					delete swingTrace;
					if (!npc.m_bInFastHand)
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 1.0;
					else
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 0.4;
					npc.m_flAttackHappenswillhappen = false;
				}
				else if (npc.m_flAttackHappens_bullshit < GetGameTime(npc.index) && npc.m_flAttackHappenswillhappen)
				{
					npc.m_flAttackHappenswillhappen = false;
					if (!npc.m_bInFastHand)
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 1.0;
					else
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 0.4;
				}
			}
			PF_StopPathing(npc.index);
			npc.m_bPathing = false;
		}
	}
	npc.StartPathing();
	npc.PlayIdleAlertSound();
}
	
public Action TrueTocksick_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	//Valid attackers only.
	if(attacker <= 0)
		return Plugin_Continue;
		
	TrueTocksick npc = view_as<TrueTocksick>(victim);
	
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	if (npc.m_bInBounce)
		damage *= GetRandomFloat(0.5, 0.9);
	
	return Plugin_Changed;
}

public void TrueTocksick_NPCDeath(int entity)
{
	TrueTocksick npc = view_as<TrueTocksick>(entity);
	npc.PlayDeathSound();
	
	SDKUnhook(npc.index, SDKHook_Think, TrueTocksick_ClotThink);
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, TrueTocksick_ClotDamaged);
	
	RaidBossActive = INVALID_ENT_REFERENCE;
	
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
	if(IsValidEntity(npc.m_iWearable4))
		RemoveEntity(npc.m_iWearable4);
	if(IsValidEntity(npc.m_iWearable5))
		RemoveEntity(npc.m_iWearable5);
	if(IsValidEntity(npc.m_iWearable6))
		RemoveEntity(npc.m_iWearable6);
		
//	AcceptEntityInput(npc.index, "KillHierarchy");
//	npc.Anger = false;

	Citizen_MiniBossDeath(entity);
}





// Almost all that code is take from rtd, thanks to Phil25
void NecroMash_Start(){
	PrecacheModel("models/props_halloween/hammer_gears_mechanism.mdl");
	PrecacheModel("models/props_halloween/hammer_mechanism.mdl");
	PrecacheModel("models/props_halloween/bell_button.mdl");

	PrecacheSound("misc/halloween/strongman_fast_impact_01.wav");
	PrecacheSound("ambient/explosions/explode_1.wav");
	PrecacheSound("misc/halloween/strongman_fast_whoosh_01.wav");
	PrecacheSound("misc/halloween/strongman_fast_swing_01.wav");
	PrecacheSound("doors/vent_open2.wav");
}

void NecroMash_SmashClient(int npcentity){
	float flPos[3], flPpos[3], flAngles[3];
	GetEntPropVector(npcentity, Prop_Data, "m_vecAbsOrigin", flPos); 
	GetEntPropVector(npcentity, Prop_Data, "m_vecAbsOrigin", flPpos); 
	GetEntPropVector(npcentity, Prop_Data, "m_angRotation", flAngles); 
	flAngles[0] = 0.0;

	float vForward[3];
	GetAngleVectors(flAngles, vForward, NULL_VECTOR, NULL_VECTOR);
	flPos[0] -= (vForward[0] * 750);
	flPos[1] -= (vForward[1] * 750);
	flPos[2] -= (vForward[2] * 750);

	flPos[2] += 350.0;
	int gears = CreateEntityByName("prop_dynamic");
	if(IsValidEntity(gears)){
		DispatchKeyValueVector(gears, "origin", flPos);
		DispatchKeyValueVector(gears, "angles", flAngles);
		DispatchKeyValue(gears, "model", "models/props_halloween/hammer_gears_mechanism.mdl");
		DispatchSpawn(gears);
	}

	int hammer = CreateEntityByName("prop_dynamic");
	if(IsValidEntity(hammer)){
		DispatchKeyValueVector(hammer, "origin", flPos);
		DispatchKeyValueVector(hammer, "angles", flAngles);
		DispatchKeyValue(hammer, "model", "models/props_halloween/hammer_mechanism.mdl");
		DispatchSpawn(hammer);
	}

	int button = CreateEntityByName("prop_dynamic");
	if(IsValidEntity(button)){
		flPos[0] += (vForward[0] * 600);
		flPos[1] += (vForward[1] * 600);
		flPos[2] += (vForward[2] * 600);

		flPos[2] -= 100.0;
		flAngles[1] += 180.0;

		DispatchKeyValueVector(button, "origin", flPos);
		DispatchKeyValueVector(button, "angles", flAngles);
		DispatchKeyValue(button, "model", "models/props_halloween/bell_button.mdl");
		DispatchSpawn(button);

		Handle pack;
		CreateDataTimer(1.3, Timer_NecroMash_Hit, pack);
		WritePackFloat(pack, flPpos[0]); //Position of effects
		WritePackFloat(pack, flPpos[1]); //Position of effects
		WritePackFloat(pack, flPpos[2]); //Position of effects
		WritePackCell(pack, npcentity); //Position of effects

		Handle pack2;
		CreateDataTimer(1.0, Timer_NecroMash_Whoosh, pack2);
		WritePackFloat(pack2, flPpos[0]); //Position of effects
		WritePackFloat(pack2, flPpos[1]); //Position of effects
		WritePackFloat(pack2, flPpos[2]); //Position of effects

		EmitSoundToAll("misc/halloween/strongman_fast_swing_01.wav", _, _, _, _, _, _, _, flPpos);
	}

	SetVariantString("OnUser2 !self:SetAnimation:smash:0:1");
	AcceptEntityInput(gears, "AddOutput");
	AcceptEntityInput(gears, "FireUser2");

	SetVariantString("OnUser2 !self:SetAnimation:smash:0:1");
	AcceptEntityInput(hammer, "AddOutput");
	AcceptEntityInput(hammer, "FireUser2");

	SetVariantString("OnUser2 !self:SetAnimation:hit:1.3:1");
	AcceptEntityInput(button, "AddOutput");
	AcceptEntityInput(button, "FireUser2");

	
	CreateTimer(5.0, Timer_RemoveEntity, EntIndexToEntRef(gears), TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(5.0, Timer_RemoveEntity, EntIndexToEntRef(hammer), TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(5.0, Timer_RemoveEntity, EntIndexToEntRef(button), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_NecroMash_Hit(Handle timer, any pack){
	ResetPack(pack);

	float pos[3];
	pos[0] = ReadPackFloat(pack);
	pos[1] = ReadPackFloat(pack);
	pos[2] = ReadPackFloat(pack);
	
	int npcentity = ReadPackCell(pack);

	int shaker = CreateEntityByName("env_shake");
	if(shaker != -1){
		DispatchKeyValue(shaker, "amplitude", "10");
		DispatchKeyValue(shaker, "radius", "1500");
		DispatchKeyValue(shaker, "duration", "1");
		DispatchKeyValue(shaker, "frequency", "2.5");
		DispatchKeyValue(shaker, "spawnflags", "4");
		DispatchKeyValueVector(shaker, "origin", pos);

		DispatchSpawn(shaker);
		AcceptEntityInput(shaker, "StartShake");

		CreateTimer(1.0, Timer_RemoveEntity, EntIndexToEntRef(shaker), TIMER_FLAG_NO_MAPCHANGE);
	}

	EmitSoundToAll("ambient/explosions/explode_1.wav", _, _, _, _, _, _, _, pos);
	EmitSoundToAll("misc/halloween/strongman_fast_impact_01.wav", _, _, _, _, _, _, _, pos);

	float pos2[3], Vec[3], AngBuff[3];
	for(int i = 1; i <= MaxClients; i++){
		if(IsClientInGame(i) && IsPlayerAlive(i) && !IsFakeClient(i)){
			GetClientAbsOrigin(i, pos2);
			if(GetVectorDistance(pos, pos2) <= 500.0){
				MakeVectorFromPoints(pos, pos2, Vec);
				GetVectorAngles(Vec, AngBuff);
				AngBuff[0] -= 30.0;
				GetAngleVectors(AngBuff, Vec, NULL_VECTOR, NULL_VECTOR);
				NormalizeVector(Vec, Vec);
				ScaleVector(Vec, 500.0);
				Vec[2] += 250.0;
				TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, Vec);
			}

			if(GetVectorDistance(pos, pos2) <= 120.0)
			{
				if (IsValidEntity(npcentity))
					SDKHooks_TakeDamage(i, npcentity, npcentity, 100.0*RaidModeScaling, DMG_CLUB, -1, _, pos);
			}
		}
	}
	
	if (IsValidEntity(npcentity))
	{
		GetEntPropVector(npcentity, Prop_Data, "m_vecAbsOrigin", pos2);
		if(GetVectorDistance(pos, pos2) <= 120.0){
			TrueTocksick npc = view_as<TrueTocksick>(npcentity);
			SDKHooks_TakeDamage(npc.index, 0, 0, GetEntProp(npc.index, Prop_Data, "m_iMaxHealth")*0.05);
		}
	}

	pos[2] += 10.0;
	NecroMash_CreateParticle("hammer_impact_button", pos);
	NecroMash_CreateParticle("hammer_bones_kickup", pos);

	return Plugin_Stop;
}

public Action Timer_NecroMash_Whoosh(Handle timer, any pack){
	ResetPack(pack);

	float pos[3];
	pos[0] = ReadPackFloat(pack);
	pos[1] = ReadPackFloat(pack);
	pos[2] = ReadPackFloat(pack);

	EmitSoundToAll("misc/halloween/strongman_fast_whoosh_01.wav", _, _, _, _, _, _, _, pos);

	return Plugin_Stop;
}

stock void NecroMash_CreateParticle(char[] particle, float pos[3]){
	int tblidx = FindStringTable("ParticleEffectNames");
	char tmp[256];
	int count = GetStringTableNumStrings(tblidx);
	int stridx = INVALID_STRING_INDEX;

	for(int i = 0; i < count; i++){
		ReadStringTable(tblidx, i, tmp, sizeof(tmp));
		if(StrEqual(tmp, particle, false)){
			stridx = i;
			break;
		}
	}

	for(int i = 1; i <= MaxClients; i++){
		if(!IsValidEntity(i)) continue;
		if(!IsClientInGame(i)) continue;
		TE_Start("TFParticleEffect");
		TE_WriteFloat("m_vecOrigin[0]", pos[0]);
		TE_WriteFloat("m_vecOrigin[1]", pos[1]);
		TE_WriteFloat("m_vecOrigin[2]", pos[2]);
		TE_WriteNum("m_iParticleSystemIndex", stridx);
		TE_WriteNum("entindex", -1);
		TE_WriteNum("m_iAttachType", 2);
		TE_SendToClient(i, 0.0);
	}
}
