#pragma semicolon 1
#pragma newdecls required

static const char g_ExplosionSound[][] = {
	"mvm/sentrybuster/mvm_sentrybuster_explode.wav",
	"mvm/sentrybuster/mvm_sentrybuster_spin.wav",
};

static const char g_IdleAlertedSounds[][] = {
	"mvm/sentrybuster/mvm_sentrybuster_intro.wav",
};

static const char g_IdleSounds[][] = {
	"mvm/mvm_bought_upgrade.wav",
};

static bool Sentry_Buster_Kabeeew[MAXENTITIES + 1] = {false, ...};

void SentryBuster_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_ExplosionSound));	   i++) { PrecacheSound(g_ExplosionSound[i]);	   }
	for (int i = 0; i < (sizeof(g_IdleSounds));		i++) { PrecacheSound(g_IdleSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	PrecacheModel("models/bots/demo/bot_sentry_buster.mdl");
}

methodmap SentryBuster < CClotBody
{
	property bool m_bGonnaBlowUp
	{
		public get()							{ return Sentry_Buster_Kabeeew[this.index]; }
		public set(bool TempValueForProperty) 	{ Sentry_Buster_Kabeeew[this.index] = TempValueForProperty; }
	}
	
	public void PlayIdleSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		EmitSoundToAll(g_IdleSounds[GetRandomInt(0, sizeof(g_IdleSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(80, 85));
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(24.0, 48.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleSound()");
		#endif
	}
	
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(80, 85));
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleAlertSound()");
		#endif
	}
	
	public void PlayIdleExplodeSound(bool start = true) {
		
		EmitSoundToAll(g_ExplosionSound[start ? 1 : 0], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(80, 85));
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayExplodeAlertSound()");
		#endif
	}
	
	public SentryBuster(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		SentryBuster npc = view_as<SentryBuster>(CClotBody(vecPos, vecAng, "models/bots/demo/bot_sentry_buster.mdl", "1.0", "5000", ally));
		
		i_NpcInternalId[npc.index] = RND_SENTRY_BUSTER;
		
		FormatEx(c_HeadPlaceAttachmentGibName[npc.index], sizeof(c_HeadPlaceAttachmentGibName[]), "head");
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		
		npc.m_bGonnaBlowUp = false;
		npc.m_flNextMeleeAttack = 0.0;
		
		npc.m_iBleedType = BLEEDTYPE_METAL;
		npc.m_iStepNoiseType = STEPSOUND_GIANT;	
		npc.m_iNpcStepVariation = STEPTYPE_TANK;
		
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, SentryBuster_ClotDamaged);
		SDKHook(npc.index, SDKHook_Think, SentryBuster_ClotThink);		
		

		npc.m_flSpeed = 400.0;
		//IDLE
		npc.m_iState = 0;
		
		npc.m_flGetClosestTargetTime = 0.0;
		npc.StartPathing();
		
		return npc;
	}
	
	
}

//TODO 
//Rewrite
public void SentryBuster_ClotThink(int iNPC)
{
	SentryBuster npc = view_as<SentryBuster>(iNPC);
	
	if(npc.m_flNextDelayTime > GetGameTime(npc.index))
	{
		return;
	}
	
	npc.m_flNextDelayTime = GetGameTime(npc.index) + DEFAULT_UPDATE_DELAY_FLOAT;
	
	npc.Update();
	
	if(npc.m_flNextThinkTime > GetGameTime(npc.index))
	{
		return;
	}
	
	npc.m_flNextThinkTime = GetGameTime(npc.index) + 0.1;

	if (npc.m_bGonnaBlowUp)
		return;
	
	
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

			npc.StartPathing();
			
			//Target close enough to hit
			if(flDistanceToTarget < 10000)
			{
				npc.m_bGonnaBlowUp = true;
				npc.AddGestureViaSequence("sentry_buster_preExplode");
				npc.PlayIdleExplodeSound();
				
				npc.m_flSpeed = 0.0;
				PF_StopPathing(npc.index);
				npc.m_bPathing = false;
				
				CreateTimer(1.8, Sentry_Buster_Explode, EntIndexToEntRef(iNPC), TIMER_FLAG_NO_MAPCHANGE);
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

public Action Sentry_Buster_Explode(Handle timer, int refNPC) {
	int iNPC = EntRefToEntIndex(refNPC);
	
	if (!IsValidEntity(iNPC))
		return Plugin_Continue;
	
	SentryBuster npc = view_as<SentryBuster>(iNPC);
	float startPosition[3];
	GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", startPosition); 
	startPosition[2] += 45;
	makeexplosion(npc.index, npc.index, startPosition, "", 2300, 200); // Actually sentry's buster dmg
	npc.PlayIdleExplodeSound(false);
	SDKHooks_TakeDamage(npc.index, 0, 0, 99999.0, DMG_CLUB, -1, _, startPosition);

	return Plugin_Continue;
}

public Action SentryBuster_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	SentryBuster npc = view_as<SentryBuster>(victim);
	
	if(attacker <= 0)
		return Plugin_Continue;
	
	if (attacker==0)
		return Plugin_Continue;
	
	if (npc.m_bGonnaBlowUp) {
		damage = 0.0;
		return Plugin_Changed;
	}
	
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	if (GetEntProp(npc.index, Prop_Data, "m_iHealth")<=damage) {
		npc.m_bGonnaBlowUp = true;
		npc.AddGestureViaSequence("sentry_buster_preExplode");
		npc.PlayIdleExplodeSound();
		
		npc.m_flSpeed = 0.0;
		PF_StopPathing(npc.index);
		npc.m_bPathing = false;
		
		CreateTimer(1.8, Sentry_Buster_Explode, EntIndexToEntRef(victim), TIMER_FLAG_NO_MAPCHANGE);
		damage = 0.0;
	}
	
	return Plugin_Changed;
}

public void SentryBuster_NPCDeath(int entity)
{
	SentryBuster npc = view_as<SentryBuster>(entity);
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, SentryBuster_ClotDamaged);
	SDKUnhook(npc.index, SDKHook_Think, SentryBuster_ClotThink);
}

