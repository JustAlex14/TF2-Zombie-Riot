#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] = {
	"vo/medic_paincrticialdeath01.mp3",
	"vo/medic_paincrticialdeath02.mp3",
	"vo/medic_paincrticialdeath03.mp3",
};

static const char g_HurtSounds[][] = {
	"vo/medic_painsharp01.mp3",
	"vo/medic_painsharp02.mp3",
	"vo/medic_painsharp03.mp3",
	"vo/medic_painsharp04.mp3",
};

static const char g_IdleAlertedSounds[][] = {
	"vo/medic_battlecry01.mp3",
	"vo/medic_battlecry02.mp3",
	"vo/medic_battlecry03.mp3",
	"vo/medic_battlecry04.mp3",
};

static char g_MeleeHitSounds[][] = {
	"weapons/ubersaw_hit3.wav",
	"weapons/pan/melee_frying_pan_02.wav",
	"weapons/metal_gloves_hit_crit2.wav",
	"weapons/halloween_boss/knight_axe_hit.wav",
	"weapons/bottle_hit_flesh2.wav",
	"weapons/batsaber_hit_flesh1.wav",
};

static char g_MeleeDrawSound[][] = {
	"weapons/draw_machete_sniper.wav",
};

static const char g_MeleeAttackSounds[][] = {
	"weapons/knife_swing.wav",
};

static const char g_MeleeMissSounds[][] = {
	"weapons/cbar_miss1.wav",
};

static float Tocksick_InFlameSlashFor[MAXENTITIES];
static float Tocksick_NextFlameCheck[MAXENTITIES]; // I need to hardcode that
static float Tocksick_InHachetMannFor[MAXENTITIES];
static float Tocksick_InKacrackleSlashFor[MAXENTITIES];
static float Tocksick_InThwackFor[MAXENTITIES];
static float Tocksick_InMetalSlashFor[MAXENTITIES];
static float Tocksick_Next_Melee[MAXENTITIES];

void CTocksick_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));	   i++) { PrecacheSound(g_DeathSounds[i]);	   }
	for (int i = 0; i < (sizeof(g_HurtSounds));		i++) { PrecacheSound(g_HurtSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	for (int i = 0; i < (sizeof(g_MeleeHitSounds));	i++) { PrecacheSound(g_MeleeHitSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds));	i++) { PrecacheSound(g_MeleeAttackSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeMissSounds));   i++) { PrecacheSound(g_MeleeMissSounds[i]);   }
	for (int i = 0; i < (sizeof(g_MeleeDrawSound));   i++) { PrecacheSound(g_MeleeDrawSound[i]);   }
}

methodmap CTocksick < CClotBody
{
	property float m_flNextEventMelee
	{
		public get()							{ return Tocksick_Next_Melee[this.index]; }
		public set(float TempValueForProperty) 	{ Tocksick_Next_Melee[this.index] = TempValueForProperty; }
	}
	
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
	
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleAlertSound()");
		#endif
	}
	
	public void PlayHurtSound() {
		if(this.m_flNextHurtSound > GetGameTime(this.index))
			return;
			
		this.m_flNextHurtSound = GetGameTime(this.index) + 0.4;
		
		EmitSoundToAll(g_HurtSounds[GetRandomInt(0, sizeof(g_HurtSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayHurtSound()");
		#endif
	}
	
	public void PlayDeathSound() {
	
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayDeathSound()");
		#endif
	}
	
	public void PlayMeleeSound() {
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
	
	public void PlayMeleeDrawSound() {
		EmitSoundToAll(g_MeleeDrawSound[GetRandomInt(0, sizeof(g_MeleeDrawSound) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeDrawSound()");
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

	public void PlayMeleeMissSound() {
		EmitSoundToAll(g_MeleeMissSounds[GetRandomInt(0, sizeof(g_MeleeMissSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CGoreFast::PlayMeleeMissSound()");
		#endif
	}
	
	public void ResetMelee(){
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/weapons/c_models/c_ubersaw/c_ubersaw_xmas.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		this.PlayMeleeDrawSound();
	}
	
	public void GiveFS() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/weapons/c_models/c_frying_pan/c_frying_pan.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		this.PlayMeleeDrawSound();
	}
	
	public void GiveHM() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/workshop/weapons/c_models/c_croc_knife/c_croc_knife.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		
		this.PlayMeleeDrawSound();
	}
	
	public void GiveKS() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/weapons/c_models/c_8mm_camera/c_8mm_camera.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
			
		this.PlayMeleeDrawSound();
	}
	
	public void GiveThwack() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/workshop/weapons/c_models/c_skullbat/c_skullbat.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
			
		this.PlayMeleeDrawSound();
	}
	
	public void GiveMS() {
		
		if(IsValidEntity(this.m_iWearable5))
			RemoveEntity(this.m_iWearable5);
		
		this.m_iWearable5 = this.EquipItem("head","models/workshop/weapons/c_models/c_crossing_guard/c_crossing_guard.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(this.m_iWearable5, "SetModelScale");
		SetEntProp(this.m_iWearable5, Prop_Send, "m_nSkin", 1);
		
		SetEntityRenderMode(this.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(this.m_iWearable5, 192, 192, 192, 255);
		
		this.PlayMeleeDrawSound();
	}
	
	
	public CTocksick(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		CTocksick npc = view_as<CTocksick>(CClotBody(vecPos, vecAng, "models/player/medic.mdl", "1.0", "25000", ally));
		
		i_NpcInternalId[npc.index] = RND_MINI_TOCKSICK;
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;	
		npc.m_iNpcStepVariation = STEPTYPE_NORMAL;
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, CTocksick_ClotDamaged);
		SDKHook(npc.index, SDKHook_Think, CTocksick_ClotThink);
			
		
		//IDLE
		npc.m_flSpeed = 350.0;
		
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
		
		
		npc.StartPathing();
		
		
		npc.m_flFlameCheck = GetGameTime(npc.index) + 2.0;
		npc.m_bInFlameSlash = false;
		npc.m_bInHachetMann = false;
		npc.m_bInKacrackleSlash = false;
		npc.m_bInThwack = false;
		npc.m_bInMetalSlash = false;
		npc.m_flNextEventMelee = GetGameTime(npc.index) + 4.0;
		
		return npc;
	}
	
	
}

//TODO 
//Rewrite
public void CTocksick_ClotThink(int iNPC)
{
	CTocksick npc = view_as<CTocksick>(iNPC);
	
	float GameTime = GetGameTime(npc.index);

	if(npc.m_flNextDelayTime > GameTime)
	{
		return;
	}
	
	npc.m_flNextDelayTime = GameTime + DEFAULT_UPDATE_DELAY_FLOAT;
	npc.Update();
			
	if(npc.m_blPlayHurtAnimation)
	{
		npc.AddGesture("ACT_MP_GESTURE_FLINCH_CHEST", false);
		npc.m_blPlayHurtAnimation = false;
		npc.PlayHurtSound();
	}
	
	if(npc.m_flNextThinkTime > GameTime)
	{
		return;
	}
	
	npc.m_flNextThinkTime = GameTime + 0.1;

	if (npc.m_flNextEventMelee<=GameTime)
	{
		switch(GetRandomInt(0, 4))
		{
			case 0: npc.m_flFlameSlashDuration = GetGameTime(npc.index) + 4.0;
			case 1: npc.m_flHachetMannDuration = GetGameTime(npc.index) + 4.0;
			case 2: npc.m_flKacrackleSlashDuration = GetGameTime(npc.index) + 4.0;
			case 3: npc.m_flThwackDuration = GetGameTime(npc.index) + 4.0;
			case 4: npc.m_flMetalSlashDuration = GetGameTime(npc.index) + 4.0;
		}
		npc.m_flNextEventMelee = GameTime + 8.0;
	}
	else {
		bool stillIn = false;
		stillIn = npc.m_bInFlameSlash;
		stillIn = npc.m_bInHachetMann;
		stillIn = npc.m_bInKacrackleSlash;
		stillIn = npc.m_bInMetalSlash;
		stillIn = npc.m_bInThwack;
		
		if (!stillIn) {
			npc.m_flSpeed = 350.0;
		}
		else {
			npc.m_flSpeed = 330.0;
		}
	}
	
	if (npc.m_flFlameCheck<=GameTime)
	{
		npc.m_flFlameCheck = GameTime + 1.0;
			
		for(int client_check=1; client_check<=MaxClients; client_check++)
		{
			if(IsClientInGame(client_check) && !IsFakeClient(client_check))
			{
				if (TF2_IsPlayerInCondition(client_check, TFCond_OnFire) || TF2_IsPlayerInCondition(client_check, TFCond_BurningPyro)) // I see you pyro
				{
					SDKHooks_TakeDamage(client_check, npc.index, npc.index, 10.0, DMG_SLOWBURN, -1);
				}
			}
		}
	}
	
	if(npc.m_flGetClosestTargetTime < GameTime)
	{
		npc.m_iTarget = GetClosestTarget(npc.index);
		npc.m_flGetClosestTargetTime = GameTime + 1.0;
	}
	
	int PrimaryThreatIndex = npc.m_iTarget;
	
	if(IsValidEnemy(npc.index, PrimaryThreatIndex))
	{
		float vecTarget[3]; vecTarget = WorldSpaceCenter(PrimaryThreatIndex);
	
		float flDistanceToTarget = GetVectorDistance(vecTarget, WorldSpaceCenter(npc.index), true);
		
		//Predict their pos.
		if(flDistanceToTarget < npc.GetLeadRadius()) {
			
			float vPredictedPos[3]; vPredictedPos = PredictSubjectPosition(npc, PrimaryThreatIndex);
			
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
			PF_SetGoalEntity(npc.index, PrimaryThreatIndex);
		}
		
		
		//Target close enough to hit
		if(flDistanceToTarget < 10000 || npc.m_flAttackHappenswillhappen)
		{
			//Look at target so we hit.
		//	npc.FaceTowards(vecTarget, 1000.0);
			
			//Can we attack right now?
			if(npc.m_flNextMeleeAttack < GameTime)
			{
				//Play attack ani
				if (!npc.m_flAttackHappenswillhappen)
				{
					npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE");
					npc.PlayMeleeSound();
					npc.m_flAttackHappens = GameTime+0.4;
					npc.m_flAttackHappens_bullshit = GameTime+0.54;
					npc.m_flAttackHappenswillhappen = true;
				}
					
				if (npc.m_flAttackHappens < GameTime && npc.m_flAttackHappens_bullshit >= GameTime && npc.m_flAttackHappenswillhappen)
				{
					Handle swingTrace;
					npc.FaceTowards(vecTarget, 20000.0);
					if(npc.DoSwingTrace(swingTrace, PrimaryThreatIndex))
					{
						int target = TR_GetEntityIndex(swingTrace);	
						
						float vecHit[3];
						TR_GetEndPosition(vecHit, swingTrace);
						
						if(target > 0) 
						{
							// Hit sound
							npc.PlayMeleeHitSound();
							
							float baseDmg = 100.0; // this needs to be low, too much dmg mult
							if (ShouldNpcDealBonusDamage(target))
								baseDmg = 150.0;
								
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
							
							
							SDKHooks_TakeDamage(target, npc.index, npc.index, baseDmg, DMG_CLUB, -1, _, vecHit);
							
							if(IsValidClient(target))
							{
								if (npc.m_bInFlameSlash)
								{
									TF2_AddCondition(target, TFCond_BurningPyro, 8.0);
									TF2_IgnitePlayer(target, target, 8.0);
									npc.m_bInFlameSlash = false;
								}
								
								if (npc.m_bInKacrackleSlash)
								{
									TF2_StunPlayer(target, 1.0, 0.5, TF_STUNFLAG_LIMITMOVEMENT);
									npc.m_bInKacrackleSlash = false;
								}
							}
						} 
					}
					delete swingTrace;
					npc.m_flNextMeleeAttack = GameTime + 0.6;
					npc.m_flAttackHappenswillhappen = false;
				}
				else if (npc.m_flAttackHappens_bullshit < GameTime && npc.m_flAttackHappenswillhappen)
				{
					npc.m_flAttackHappenswillhappen = false;
					npc.m_flNextMeleeAttack = GameTime + 0.6;
				}
			}
		}
		else
		{
			npc.StartPathing();
			
		}
	}
	else
	{
		PF_StopPathing(npc.index);
		npc.m_bPathing = false;
		npc.m_flGetClosestTargetTime = 0.0;
		npc.m_iTarget = GetClosestTarget(npc.index);
	}
	npc.PlayIdleAlertSound();
}

public Action CTocksick_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	CTocksick npc = view_as<CTocksick>(victim);
		
	if(attacker <= 0)
		return Plugin_Continue;
	
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	return Plugin_Changed;
}

public void CTocksick_NPCDeath(int entity)
{
	CTocksick npc = view_as<CTocksick>(entity);
	if(!npc.m_bGib)
	{
		npc.PlayDeathSound();	
	}
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, CTocksick_ClotDamaged);
	SDKUnhook(npc.index, SDKHook_Think, CTocksick_ClotThink);
		
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
}

