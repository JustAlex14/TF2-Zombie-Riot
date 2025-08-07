
#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] = {
	"vo/sniper_paincrticialdeath01.mp3",
	"vo/sniper_paincrticialdeath02.mp3",
	"vo/sniper_paincrticialdeath03.mp3",
};

static const char g_HurtSounds[][] = {
	"vo/sniper_painsharp01.mp3",
	"vo/sniper_painsharp02.mp3",
	"vo/sniper_painsharp03.mp3",
	"vo/sniper_painsharp04.mp3",
};
static const char g_IdleAlertedSounds[][] = {
	"vo/sniper_battlecry01.mp3",
	"vo/sniper_battlecry02.mp3",
	"vo/sniper_battlecry03.mp3",
	"vo/sniper_battlecry04.mp3",
};

static const char g_MeleeHitSounds[][] = {
	"weapons/cbar_hitbod1.wav",
	"weapons/cbar_hitbod2.wav",
	"weapons/cbar_hitbod3.wav",
};
static const char g_MeleeAttackSounds[][] = {
	"weapons/machete_swing.wav",
};

static const char g_RangedAttackSounds[][] = {
	"weapons/sniper_shoot_crit.wav",
};

static const char g_MeleeMissSounds[][] = {
	"weapons/cbar_miss1.wav",
};

static const char g_FineShotSounds[][] = {
	"vo/sniper_niceshot01.mp3",
	"vo/sniper_niceshot02.mp3",
	"vo/sniper_niceshot03.mp3",
};

static float RND_Cheater_Sniper_X_Angles[MAXENTITIES];
static float RND_Cheater_Sniper_Y_Angles[MAXENTITIES];
static float RND_Cheater_Sniper_X_Angles_Add[MAXENTITIES];
static float RND_Cheater_Sniper_Y_Angles_Add[MAXENTITIES];
static float RND_Cheater_NoSpin_Duration[MAXENTITIES];
static float RND_Cheater_Next_Fine_Shot[MAXENTITIES];

void CheaterSniper_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));	   i++) { PrecacheSound(g_DeathSounds[i]);	   }
	for (int i = 0; i < (sizeof(g_HurtSounds));		i++) { PrecacheSound(g_HurtSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	for (int i = 0; i < (sizeof(g_MeleeHitSounds));	i++) { PrecacheSound(g_MeleeHitSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds));	i++) { PrecacheSound(g_MeleeAttackSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeMissSounds));   i++) { PrecacheSound(g_MeleeMissSounds[i]);   }
	for (int i = 0; i < (sizeof(g_RangedAttackSounds));   i++) { PrecacheSound(g_RangedAttackSounds[i]);   }
	for (int i = 0; i < (sizeof(g_FineShotSounds));   i++) { PrecacheSound(g_FineShotSounds[i]);   }
	PrecacheModel("models/player/sniper.mdl");
}

methodmap CheaterSniper < CClotBody
{
	property float m_flNoSpinDuration
	{
		public get()							{ return RND_Cheater_NoSpin_Duration[this.index]; }
		public set(float TempValueForProperty) 	{ RND_Cheater_NoSpin_Duration[this.index] = TempValueForProperty; }
	}
	
	property float m_flNextFineShot
	{
		public get()							{ return RND_Cheater_Next_Fine_Shot[this.index]; }
		public set(float TempValueForProperty) 	{ RND_Cheater_Next_Fine_Shot[this.index] = TempValueForProperty; }
	}
	
	property float m_flLastXAngle
	{
		public get()							{ return RND_Cheater_Sniper_X_Angles[this.index]; }
		public set(float TempValueForProperty) 	{ RND_Cheater_Sniper_X_Angles[this.index] = TempValueForProperty; }
	}
	property float m_flAddXAngle
	{
		public get()							{ return RND_Cheater_Sniper_X_Angles_Add[this.index]; }
		public set(float TempValueForProperty) 	{ RND_Cheater_Sniper_X_Angles_Add[this.index] = TempValueForProperty; }
	}
	
	property float m_flLastYAngle
	{
		public get()							{ return RND_Cheater_Sniper_Y_Angles[this.index]; }
		public set(float TempValueForProperty) 	{ RND_Cheater_Sniper_Y_Angles[this.index] = TempValueForProperty; }
	}
	property float m_flAddYAngle
	{
		public get()							{ return RND_Cheater_Sniper_Y_Angles_Add[this.index]; }
		public set(float TempValueForProperty) 	{ RND_Cheater_Sniper_Y_Angles_Add[this.index] = TempValueForProperty; }
	}
	
	public void PlayFineShotSound() {
		if(this.m_flNextFineShot > GetGameTime(this.index))
			return;
		
		this.AddGesture("ACT_MP_GESTURE_VC_THUMBSUP_PRIMARY");
		
		EmitSoundToAll(g_FineShotSounds[GetRandomInt(0, sizeof(g_FineShotSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		this.m_flNextFineShot = GetGameTime(this.index) + GetRandomFloat(3.0, 5.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayFineShotSound()");
		#endif
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
	public void PlayMeleeHitSound() {
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
		
	public void PlayRangedSound() {
		EmitSoundToAll(g_RangedAttackSounds[GetRandomInt(0, sizeof(g_RangedAttackSounds) - 1)], this.index, _, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayRangedSound()");
		#endif
	}

	public void PlayMeleeMissSound() {
		EmitSoundToAll(g_MeleeMissSounds[GetRandomInt(0, sizeof(g_MeleeMissSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CGoreFast::PlayMeleeMissSound()");
		#endif
	}
	
	
	
	public CheaterSniper(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		CheaterSniper npc = view_as<CheaterSniper>(CClotBody(vecPos, vecAng, "models/player/sniper.mdl", "1.0", "20000", ally));
		
		i_NpcInternalId[npc.index] = RND_CHEATER_SNIPER;

		FormatEx(c_HeadPlaceAttachmentGibName[npc.index], sizeof(c_HeadPlaceAttachmentGibName[]), "head");
		
		int iActivity = npc.LookupActivity("ACT_MP_DEPLOYED_PRIMARY");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		
		
		npc.m_flNextMeleeAttack = 0.0;
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;	
		npc.m_iNpcStepVariation = STEPTYPE_NORMAL;
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, CheaterSniper_ClotDamaged);
		SDKHook(npc.index, SDKHook_Think, CheaterSniper_ClotThink);
		
		//IDLE
		npc.m_flSpeed = 100.0;
		
		int skin = 5;
		SetEntProp(npc.index, Prop_Send, "m_nSkin", skin);
		
		npc.m_flGetClosestTargetTime = 0.0;
		npc.StartPathing();
		
		
		npc.Anger = false;
		
		npc.m_flLastXAngle = 90.0;
		npc.m_flLastYAngle = 0.0;
		npc.m_flAddXAngle = -15.0;
		npc.m_flAddYAngle = 15.0;
		npc.m_bAllowBackWalking = false;
		
		npc.m_flNoSpinDuration = -1.0;
		npc.m_flNextFineShot = GetGameTime(npc.index) + 6.0;

		
		npc.m_iWearable1 = npc.EquipItem("head", "models/player/items/sniper/sniper_zombie.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		SetEntProp(npc.m_iWearable1, Prop_Send, "m_nSkin", 1);
		
		npc.m_iWearable4 = npc.EquipItem("head", "models/weapons/c_models/c_sniperrifle/c_sniperrifle.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable4, "SetModelScale");
		
		npc.m_iWearable2 = npc.EquipItem("head", "models/workshop/player/items/all_class/robo_all_gibus/robo_all_gibus_sniper.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		
		npc.m_iWearable3 = npc.EquipItem("head", "models/player/items/all_class/pyrovision_goggles_sniper.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable3, "SetModelScale");
		
		SetEntProp(npc.m_iWearable3, Prop_Send, "m_nSkin", 1);
		return npc;
	}
	
	
}

//TODO 
//Rewrite
public void CheaterSniper_ClotThink(int iNPC)
{
	CheaterSniper npc = view_as<CheaterSniper>(iNPC);
	
	if(npc.m_flNextDelayTime > GetGameTime(npc.index))
	{
		return;
	}
	
	npc.m_flNextDelayTime = GetGameTime(npc.index) + DEFAULT_UPDATE_DELAY_FLOAT;
	
	npc.Update();
	
	float vecNPC[3]; vecNPC = WorldSpaceCenter(npc.index);
	
	if (npc.m_flNoSpinDuration<=GetGameTime(npc.index))
	{
		if (npc.m_flLastXAngle >= 90.0)
			npc.m_flAddXAngle = -15.0;
		else if (npc.m_flLastXAngle <= -90.0)
			npc.m_flAddXAngle = 15.0;
		
		if (npc.m_flLastYAngle >= 90.0)
			npc.m_flAddYAngle = -15.0;
		else if (npc.m_flLastYAngle <= -90.0)
			npc.m_flAddYAngle = 15.0;
			
		npc.m_flLastXAngle += npc.m_flAddXAngle;
		npc.m_flLastYAngle += npc.m_flAddYAngle;
			
		vecNPC[0] += npc.m_flLastXAngle;
		vecNPC[1] += npc.m_flLastYAngle;
		
		npc.FaceTowards(vecNPC, 10000.0);
	}
			
	if(npc.m_blPlayHurtAnimation)
	{
		npc.AddGesture("ACT_MP_GESTURE_FLINCH_CHEST", false);
		npc.m_blPlayHurtAnimation = false;
		npc.PlayHurtSound();
	}
	
	if(npc.m_flNextThinkTime > GetGameTime(npc.index))
	{
		return;
	}
	
	npc.m_flNextThinkTime = GetGameTime(npc.index) + 0.1;

	
	if(npc.m_flGetClosestTargetTime < GetGameTime(npc.index))
	{
		npc.m_iTarget = GetClosestTarget(npc.index);
		npc.m_flGetClosestTargetTime = GetGameTime(npc.index) + 1.0;
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
	//	npc.FaceTowards(vecTarget, 1000.0);
		
		int target;
		
		target = Can_I_See_Enemy(npc.index, PrimaryThreatIndex);
		bool isValidtarget = IsValidEnemy(npc.index, target);
		if(!isValidtarget)
		{
			npc.StartPathing();
		}
		else
		{
			PF_StopPathing(npc.index);
			npc.m_bPathing = false;
		}
		
		if(npc.m_flNextRangedAttack < GetGameTime(npc.index) && isValidtarget)
		{
			npc.FaceTowards(vecTarget, 10000.0);
			npc.FaceTowards(vecTarget, 10000.0);
			
			
			
			float vecSpread = 0.1;
			
			float eyePitch[3];
			GetEntPropVector(npc.index, Prop_Data, "m_angRotation", eyePitch);
			
			
			float x, y;
			x = GetRandomFloat( -0.05, 0.05 ) + GetRandomFloat( -0.05, 0.05 );
			y = GetRandomFloat( -0.05, 0.05 ) + GetRandomFloat( -0.05, 0.05 );
			
			float vecDirShooting[3], vecRight[3], vecUp[3];
			
			vecTarget[2] += 15.0;
			MakeVectorFromPoints(WorldSpaceCenter(npc.index), vecTarget, vecDirShooting);
			GetVectorAngles(vecDirShooting, vecDirShooting);
			vecDirShooting[1] = eyePitch[1];
			GetAngleVectors(vecDirShooting, vecDirShooting, vecRight, vecUp);
			
			
			npc.AddGesture("ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED");
			float vecDir[3];
			vecDir[0] = vecDirShooting[0] + x * vecSpread * vecRight[0] + y * vecSpread * vecUp[0]; 
			vecDir[1] = vecDirShooting[1] + x * vecSpread * vecRight[1] + y * vecSpread * vecUp[1]; 
			vecDir[2] = vecDirShooting[2] + x * vecSpread * vecRight[2] + y * vecSpread * vecUp[2]; 
			NormalizeVector(vecDir, vecDir);
			
			if (IsValidEntity(npc.index) && IsValidEntity(npc.m_iWearable4)) 
			{
				FireBullet(npc.index, npc.m_iWearable4, WorldSpaceCenter(npc.index), vecDir, 150.0, 9000.0, DMG_BULLET, "bullet_tracer01_red");
				npc.PlayRangedSound();
				npc.m_flNextRangedAttack = GetGameTime(npc.index) + 5.0;
				npc.m_flNoSpinDuration = GetGameTime(npc.index) + 1.0;
			}
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
	npc.PlayFineShotSound();
}

public Action CheaterSniper_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	CheaterSniper npc = view_as<CheaterSniper>(victim);
		
	if(attacker <= 0)
		return Plugin_Continue;

	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	return Plugin_Changed;
}

public void CheaterSniper_NPCDeath(int entity)
{
	CheaterSniper npc = view_as<CheaterSniper>(entity);
	if(!npc.m_bGib)
	{
		npc.PlayDeathSound();	
	}
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, CheaterSniper_ClotDamaged);
	SDKUnhook(npc.index, SDKHook_Think, CheaterSniper_ClotThink);	
	
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
	if(IsValidEntity(npc.m_iWearable4))
		RemoveEntity(npc.m_iWearable4);
}



