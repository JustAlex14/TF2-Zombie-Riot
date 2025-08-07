#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] = {
	"vo/mvm/norm/soldier_mvm_paincrticialdeath01.mp3",
	"vo/mvm/norm/soldier_mvm_paincrticialdeath02.mp3",
	"vo/mvm/norm/soldier_mvm_paincrticialdeath03.mp3",
};

static const char g_HurtSounds[][] = {
	"vo/mvm/norm/soldier_mvm_painsevere01.mp3",
	"vo/mvm/norm/soldier_mvm_painsevere02.mp3",
	"vo/mvm/norm/soldier_mvm_painsevere03.mp3",
	"vo/mvm/norm/soldier_mvm_painsevere04.mp3",
	"vo/mvm/norm/soldier_mvm_painsevere05.mp3",
	"vo/mvm/norm/soldier_mvm_painsevere06.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp01.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp02.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp03.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp04.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp05.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp06.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp07.mp3",
	"vo/mvm/norm/soldier_mvm_painsharp08.mp3",
};

static const char g_IdleSounds[][] = {
	"vo/mvm/norm/taunts/soldier_mvm_taunts01.mp3",
	"vo/mvm/norm/taunts/soldier_mvm_taunts09.mp3",
	"vo/mvm/norm/taunts/soldier_mvm_taunts14.mp3",
	
};

static const char g_IdleAlertedSounds[][] = {
	"vo/mvm/norm/taunts/soldier_mvm_taunts18.mp3",
	"vo/mvm/norm/taunts/soldier_mvm_taunts19.mp3",
	"vo/mvm/norm/taunts/soldier_mvm_taunts20.mp3",
	"vo/mvm/norm/taunts/soldier_mvm_taunts21.mp3",
};

static const char g_MeleeHitSounds[][] = {
	"weapons/bat_hit.wav",
};

static const char g_MeleeAttackSounds[][] = {
	"weapons/bison_main_shot_01.wav",
	"weapons/doom_sniper_smg.wav",
	"weapons/widow_maker_shot_03.wav",
};

static const char g_MeleeMissSounds[][] = {
	"weapons/bat_draw_swoosh1.wav",
	"weapons/bat_draw_swoosh2.wav",
};

static const char g_RangedReloadSound[][] = {
	"weapons/bison_reload.wav",
};

#define ENERGY_BALL_MODEL	"models/weapons/w_models/w_drg_ball.mdl"
#define SOUND_WAND_SHOT 	"weapons/capper_shoot.wav"
#define SOUND_ZAP "misc/halloween/spell_lightning_ball_impact.wav"



static int RND_BLASTER_WEAPON_MODE[MAXENTITIES];


static int RND_BLASTER_CAGE_OWNER[MAXENTITIES];
static int RND_BLASTER_CAGE_DUO[MAXENTITIES];
static int RND_BLASTER_CAGE_PARTICLE[MAXENTITIES];
static int RND_BLASTER_CAGE_LINK[MAXENTITIES];


void RND_Blaster_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));	   i++) { PrecacheSound(g_DeathSounds[i]);	   }
	for (int i = 0; i < (sizeof(g_HurtSounds));		i++) { PrecacheSound(g_HurtSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleSounds));		i++) { PrecacheSound(g_IdleSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	for (int i = 0; i < (sizeof(g_MeleeHitSounds));	i++) { PrecacheSound(g_MeleeHitSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds));	i++) { PrecacheSound(g_MeleeAttackSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeMissSounds));   i++) { PrecacheSound(g_MeleeMissSounds[i]);   }
	for (int i = 0; i < (sizeof(g_RangedReloadSound));   i++) { PrecacheSound(g_RangedReloadSound[i]);   }
	PrecacheModel("models/bots/soldier/bot_soldier.mdl");
}

methodmap RND_Blaster < CClotBody
{
	property int m_iWeaponMode
	{
		public get()							{ return RND_BLASTER_WEAPON_MODE[this.index]; }
		public set(int TempValueForProperty) 	{ RND_BLASTER_WEAPON_MODE[this.index] = TempValueForProperty; }
	}
	
	public void PlayIdleSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		EmitSoundToAll(g_IdleSounds[GetRandomInt(0, sizeof(g_IdleSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(NORMAL_ZOMBIE_SOUNDLEVEL, 100));
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(24.0, 48.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleSound()");
		#endif
	}
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(NORMAL_ZOMBIE_SOUNDLEVEL, 100));
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleAlertSound()");
		#endif
	}
	public void PlayHurtSound() {
		if(this.m_flNextHurtSound > GetGameTime(this.index))
			return;
			
		this.m_flNextHurtSound = GetGameTime(this.index) + 0.4;
		
		EmitSoundToAll(g_HurtSounds[GetRandomInt(0, sizeof(g_HurtSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(NORMAL_ZOMBIE_SOUNDLEVEL, 100));
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayHurtSound()");
		#endif
	}
	public void PlayDeathSound() {
	
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(NORMAL_ZOMBIE_SOUNDLEVEL, 100));
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayDeathSound()");
		#endif
	}
	public void PlayMeleeSound() {
		EmitSoundToAll(g_MeleeAttackSounds[this.m_iWeaponMode], this.index, SNDCHAN_VOICE, 80, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(NORMAL_ZOMBIE_SOUNDLEVEL, 100));
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
	public void PlayMeleeHitSound() {
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(NORMAL_ZOMBIE_SOUNDLEVEL, 100));
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
	public void PlayMeleeMissSound() {
		EmitSoundToAll(g_MeleeMissSounds[GetRandomInt(0, sizeof(g_MeleeMissSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, GetRandomInt(NORMAL_ZOMBIE_SOUNDLEVEL, 100));
		
		#if defined DEBUG_SOUND
		PrintToServer("CGoreFast::PlayMeleeMissSound()");
		#endif
	}
	public void PlayRangedReloadSound() {
		EmitSoundToAll(g_RangedReloadSound[GetRandomInt(0, sizeof(g_RangedReloadSound) - 1)], this.index, _, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 80);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayRangedSound()");
		#endif
	}
	
	public RND_Blaster(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		RND_Blaster npc = view_as<RND_Blaster>(CClotBody(vecPos, vecAng, "models/bots/soldier/bot_soldier.mdl", "1.3", "200000", ally));
		
		i_NpcInternalId[npc.index] = RND_BLASTER;
		
		FormatEx(c_HeadPlaceAttachmentGibName[npc.index], sizeof(c_HeadPlaceAttachmentGibName[]), "head");
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_SECONDARY");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		npc.m_flNextMeleeAttack = 0.0;
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;	
		npc.m_iNpcStepVariation = STEPTYPE_NORMAL;
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, RND_Blaster_ClotDamaged);
		SDKHook(npc.index, SDKHook_Think, RND_Blaster_ClotThink);
		
		//IDLE
		npc.m_flSpeed = 270.0;
		npc.m_iAttacksTillReload = 0;
		
		if(!ally)
		{
			b_thisNpcIsABoss[npc.index] = true;
		}
		
		npc.m_flGetClosestTargetTime = 0.0;
		npc.StartPathing();
		
		int skin = 1;
		SetEntProp(npc.index, Prop_Send, "m_nSkin", skin);
		
		npc.m_iWearable1 = npc.EquipItem("head", "models/workshop/weapons/c_models/c_drg_pomson/c_drg_pomson.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		npc.m_iWearable2 = npc.EquipItem("head", "models/workshop/player/items/all_class/bak_teufort_knight/bak_teufort_knight_soldier.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		npc.m_iWearable3 = npc.EquipItem("head", "models/workshop/player/items/all_class/bak_batarm/bak_batarm_soldier.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");		
		
		npc.StartPathing();
		
		return npc;
	}
}

//TODO 
//Rewrite
public void RND_Blaster_ClotThink(int iNPC)
{
	RND_Blaster npc = view_as<RND_Blaster>(iNPC);
	
	if(npc.m_flNextDelayTime > GetGameTime(npc.index))
	{
		return;
	}
	
	npc.m_flNextDelayTime = GetGameTime(npc.index) + DEFAULT_UPDATE_DELAY_FLOAT;
	
	npc.Update();
			
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
			/*
			int color[4];
			color[0] = 255;
			color[1] = 255;
			color[2] = 0;
			color[3] = 255;
		
			int xd = PrecacheModel("materials/sprites/laserbeam.vmt");
		
			TE_SetupBeamPoints(vPredictedPos, vecTarget, xd, xd, 0, 0, 0.25, 0.5, 0.5, 5, 5.0, color, 30);
			TE_SendToAllInRange(vecTarget, RangeType_Visibility);
			*/
			
			
			
			PF_SetGoalVector(npc.index, vPredictedPos);
		} else {
			PF_SetGoalEntity(npc.index, PrimaryThreatIndex);
		}
		
		if (npc.m_iWeaponMode==0)
		{
			if(npc.m_flReloadIn && npc.m_flReloadIn<GetGameTime(npc.index))
			{
				//Play attack anim
				npc.AddGesture("ACT_MP_RELOAD_STAND_PRIMARY");
				npc.m_flReloadIn = 0.0;
			}
		}
		
		if (npc.m_iAttacksTillReload<=0)
		{
			npc.m_iWeaponMode = GetRandomInt(0, 2);
			
			switch(npc.m_iWeaponMode)
			{
				case 0: {
					npc.m_iAttacksTillReload = 6;
					
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
					
					npc.m_iWearable1 = npc.EquipItem("head","models/workshop/weapons/c_models/c_drg_pomson/c_drg_pomson.mdl");
					
					SetEntProp(npc.m_iWearable1, Prop_Send, "m_nSkin", 1);
					
					//npc.PlayMeleeDrawSound();
				}
				case 1: {
					npc.m_iAttacksTillReload = 75;
					
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
					
					npc.m_iWearable1 = npc.EquipItem("head","models/workshop/weapons/c_models/c_pro_smg/c_pro_smg.mdl");
					
					SetEntProp(npc.m_iWearable1, Prop_Send, "m_nSkin", 1);
					
					//npc.PlayMeleeDrawSound();
				}
				case 2: {
					npc.m_iAttacksTillReload = 6;
					
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
					
					npc.m_iWearable1 = npc.EquipItem("head","models/weapons/c_models/c_dex_shotgun/c_dex_shotgun.mdl");
					
					SetEntProp(npc.m_iWearable1, Prop_Send, "m_nSkin", 1);
				}
			}
		}
		
		
		if (npc.m_iWeaponMode==0)
		{
			if(flDistanceToTarget < 600000)
			{
				int Enemy_I_See;
				
				Enemy_I_See = Can_I_See_Enemy(npc.index, PrimaryThreatIndex);
				//Target close enough to hit
				if(IsValidEnemy(npc.index, Enemy_I_See))
				{
					//Look at target so we hit.
					npc.FaceTowards(vecTarget, 20000.0);
					
					//Can we attack right now?
					if(npc.m_flNextMeleeAttack < GetGameTime(npc.index))
					{
						//Play attack anim
						npc.AddGesture("ACT_MP_ATTACK_STAND_SECONDARY");
						
						npc.m_iAttacksTillReload -= 1;
						npc.PlayMeleeSound();
						Weapon_NPC_Electric_Cage_Launcher(npc.index, PrimaryThreatIndex);
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 2.0;
						npc.m_flReloadIn = GetGameTime(npc.index) + 1.0;
					}
					PF_StopPathing(npc.index);
					npc.m_bPathing = false;
				}
				else
				{
					npc.StartPathing();
				}
			}
			else
			{
				npc.StartPathing();
			}
		}
		else if (npc.m_iWeaponMode==1)
		{
			if(flDistanceToTarget < 300000)
			{
				int Enemy_I_See;
				
				Enemy_I_See = Can_I_See_Enemy(npc.index, PrimaryThreatIndex);
				//Target close enough to hit
				if(IsValidEnemy(npc.index, Enemy_I_See))
				{
					//Look at target so we hit.
					npc.FaceTowards(vecTarget, 20000.0);
					
					//Can we attack right now?
					if(npc.m_flNextMeleeAttack < GetGameTime(npc.index))
					{
						npc.PlayMeleeSound();
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 0.1;
						npc.m_iAttacksTillReload -= 1;
						
						
						float vecSpread = 0.1;
				
						float eyePitch[3];
						GetEntPropVector(npc.index, Prop_Data, "m_angRotation", eyePitch);
						
						
						float x, y;
						x = GetRandomFloat( -0.15, 0.15 ) + GetRandomFloat( -0.15, 0.15 );
						y = GetRandomFloat( -0.15, 0.15 ) + GetRandomFloat( -0.15, 0.15 );
						
						float vecDirShooting[3], vecRight[3], vecUp[3];
						
						vecTarget[2] += 15.0;
						MakeVectorFromPoints(WorldSpaceCenter(npc.index), vecTarget, vecDirShooting);
						GetVectorAngles(vecDirShooting, vecDirShooting);
						vecDirShooting[1] = eyePitch[1];
						GetAngleVectors(vecDirShooting, vecDirShooting, vecRight, vecUp);
						
						npc.AddGesture("ACT_MP_ATTACK_STAND_SECONDARY");
						float vecDir[3];
						vecDir[0] = vecDirShooting[0] + x * vecSpread * vecRight[0] + y * vecSpread * vecUp[0]; 
						vecDir[1] = vecDirShooting[1] + x * vecSpread * vecRight[1] + y * vecSpread * vecUp[1]; 
						vecDir[2] = vecDirShooting[2] + x * vecSpread * vecRight[2] + y * vecSpread * vecUp[2]; 
						NormalizeVector(vecDir, vecDir);
						
						FireBullet(npc.index, npc.m_iWearable1, WorldSpaceCenter(npc.index), vecDir, 10.0, 9000.0, DMG_BULLET, "bullet_tracer01_red");
						
					}
					PF_StopPathing(npc.index);
					npc.m_bPathing = false;
				}
				else
				{
					npc.StartPathing();
				}
			}
			else
			{
				npc.StartPathing();
			}
		}
		else if (npc.m_iWeaponMode==2)
		{
			if(flDistanceToTarget < 150000)
			{
				int Enemy_I_See;
				
				Enemy_I_See = Can_I_See_Enemy(npc.index, PrimaryThreatIndex);
				//Target close enough to hit
				if(IsValidEnemy(npc.index, Enemy_I_See))
				{
					//Look at target so we hit.
					npc.FaceTowards(vecTarget, 20000.0);
					
					//Can we attack right now?
					if(npc.m_flNextMeleeAttack < GetGameTime(npc.index))
					{
						npc.PlayMeleeSound();
						npc.m_flNextMeleeAttack = GetGameTime(npc.index) + 1.0;
						npc.m_iAttacksTillReload -= 1;
						
						
						float vecSpread = 0.1;
				
						float eyePitch[3];
						GetEntPropVector(npc.index, Prop_Data, "m_angRotation", eyePitch);
						
						npc.AddGesture("ACT_MP_ATTACK_STAND_SECONDARY");
						vecTarget[2] += 15.0;
						
						for (int iBullet = 0; iBullet < 10; iBullet++)
						{
							float x, y;
							x = GetRandomFloat( -0.2, 0.2 ) + GetRandomFloat( -0.5, 0.5 );
							y = GetRandomFloat( -0.2, 0.2 ) + GetRandomFloat( -0.5, 0.5 );
							
							float vecDirShooting[3], vecRight[3], vecUp[3];
							
							
							MakeVectorFromPoints(WorldSpaceCenter(npc.index), vecTarget, vecDirShooting);
							GetVectorAngles(vecDirShooting, vecDirShooting);
							vecDirShooting[1] = eyePitch[1];
							GetAngleVectors(vecDirShooting, vecDirShooting, vecRight, vecUp);
							
							
							float vecDir[3];
							vecDir[0] = vecDirShooting[0] + x * vecSpread * vecRight[0] + y * vecSpread * vecUp[0]; 
							vecDir[1] = vecDirShooting[1] + x * vecSpread * vecRight[1] + y * vecSpread * vecUp[1]; 
							vecDir[2] = vecDirShooting[2] + x * vecSpread * vecRight[2] + y * vecSpread * vecUp[2]; 
							NormalizeVector(vecDir, vecDir);
							
							FireBullet(npc.index, npc.m_iWearable1, WorldSpaceCenter(npc.index), vecDir, 35.0, 2000.0, DMG_BULLET, "bullet_tracer01_red");
						}
						
					}
					PF_StopPathing(npc.index);
					npc.m_bPathing = false;
				}
				else
				{
					npc.StartPathing();
				}
			}
			else
			{
				npc.StartPathing();
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
}


public Action RND_Blaster_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	RND_Blaster npc = view_as<RND_Blaster>(victim);
		
	if(attacker <= 0)
		return Plugin_Continue;
		
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	return Plugin_Changed;
}

public void RND_Blaster_NPCDeath(int entity)
{
	RND_Blaster npc = view_as<RND_Blaster>(entity);
	if(!npc.m_bGib)
	{
		npc.PlayDeathSound();	
	}
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, RND_Blaster_ClotDamaged);
	SDKUnhook(npc.index, SDKHook_Think, RND_Blaster_ClotThink);
		
	
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
}

public void OnEntityDestroyed_Blaster(int entity)
{
	RND_BLASTER_CAGE_OWNER[entity] = -1;
	
	RND_BLASTER_CAGE_DUO[entity] = -1;
	
	int beam = EntRefToEntIndex(RND_BLASTER_CAGE_LINK[entity]);
	if(IsValidEdict(beam) && beam>MaxClients)
	{
		RemoveEntity(beam);
	}
	RND_BLASTER_CAGE_LINK[entity] = -1;
}

stock int CreateWandSpecialProjectile(int NPCIdx, float flSpeed, float flPos[3], float flAng[3], float flDuration)
{
	int iRot = CreateEntityByName("func_door_rotating");
	if(iRot == -1) return -1;

	DispatchKeyValueVector(iRot, "origin", flPos);
	DispatchKeyValue(iRot, "distance", "99999");
	DispatchKeyValueFloat(iRot, "speed", flSpeed);
	DispatchKeyValue(iRot, "spawnflags", "12288"); // passable|silent
	DispatchSpawn(iRot);
	SetEntityCollisionGroup(iRot, 27);

	SetVariantString("!activator");
	AcceptEntityInput(iRot, "Open");
	
	
	int iCarrier = CreateEntityByName("prop_physics_override");
	if(iCarrier == -1) return -1;

	float fVel[3], fBuf[3];
	GetAngleVectors(flAng, fBuf, NULL_VECTOR, NULL_VECTOR);
	fVel[0] = fBuf[0]*flSpeed;
	fVel[1] = fBuf[1]*flSpeed;
	fVel[2] = fBuf[2]*flSpeed;

	SetEntPropEnt(iCarrier, Prop_Send, "m_hOwnerEntity", NPCIdx);
	DispatchKeyValue(iCarrier, "model", ENERGY_BALL_MODEL);
	DispatchKeyValue(iCarrier, "modelscale", "0");
	DispatchSpawn(iCarrier);

	TeleportEntity(iCarrier, flPos, NULL_VECTOR, fVel);
	SetEntityMoveType(iCarrier, MOVETYPE_FLY);
	
	SetEntProp(iCarrier, Prop_Send, "m_iTeamNum", GetEntProp(NPCIdx, Prop_Send, "m_iTeamNum"));
	SetEntProp(iRot, Prop_Send, "m_iTeamNum", GetEntProp(NPCIdx, Prop_Send, "m_iTeamNum"));
	RequestFrame(See_Projectile_Team, EntIndexToEntRef(iCarrier));
	RequestFrame(See_Projectile_Team, EntIndexToEntRef(iRot));
	
	SetVariantString("!activator");
	AcceptEntityInput(iRot, "SetParent", iCarrier, iRot, 0);
	SetEntityCollisionGroup(iCarrier, 27);
	
	float position[3];
	GetEntPropVector(iCarrier, Prop_Data, "m_vecAbsOrigin", position);
	int particle = ParticleEffectAt(position, "drg_cow_rockettrail_normal_blue", flDuration);
	
	
	
	TeleportEntity(particle, NULL_VECTOR, flAng, NULL_VECTOR);
	TeleportEntity(iCarrier, NULL_VECTOR, flAng, NULL_VECTOR);
	TeleportEntity(iRot, NULL_VECTOR, flAng, NULL_VECTOR);	
	SetParent(iCarrier, particle);	
	
	RND_BLASTER_CAGE_PARTICLE[iCarrier] = EntIndexToEntRef(particle);
	
	SetEntityRenderMode(iCarrier, RENDER_TRANSCOLOR);
	SetEntityRenderColor(iCarrier, 255, 255, 255, 0);
	SetEntProp(iCarrier, Prop_Send, "m_usSolidFlags", 200);
	SetEntProp(iCarrier, Prop_Data, "m_nSolidType", 0);
	SetEntityCollisionGroup(iCarrier, 0);
	
	DataPack pack;
	CreateDataTimer(15.0, Timer_RemoveEntity_CustomProjectile, pack, TIMER_FLAG_NO_MAPCHANGE);
	pack.WriteCell(EntIndexToEntRef(iCarrier));
	pack.WriteCell(EntIndexToEntRef(particle));
	pack.WriteCell(EntIndexToEntRef(iRot));
	
	return iCarrier;
}

// Yeah, I know, that's iem launcher code, but I love recyclin 
public void Weapon_NPC_Electric_Cage_Launcher(int NPCIdx, int PrimaryThreatIndex)
{
	RND_Blaster npc = view_as<RND_Blaster>(NPCIdx);
	
	EmitSoundToAll(SOUND_WAND_SHOT, NPCIdx, _, 65, _, 0.45);
	
	float fPos[3];
	fPos = WorldSpaceCenter(NPCIdx);
	fPos[2] += 30.0;
	
	
	int iPitch = npc.LookupPoseParameter("body_pitch");
	if(iPitch < 0)
		return;        
	
	//Body pitch
	float v[3], fAng[3];
	SubtractVectors(WorldSpaceCenter(npc.index), WorldSpaceCenter(PrimaryThreatIndex), v); 
	v[0] *= -1.0;
	v[1] *= -1.0;
	v[2] *= -1.0;
	NormalizeVector(v, v);
	GetVectorAngles(v, fAng); 
	
	float flPitch = npc.GetPoseParameter(iPitch);
	
	//    ang[0] = clamp(ang[0], -44.0, 89.0);
	npc.SetPoseParameter(iPitch, ApproachAngle(fAng[0], flPitch, 10.0));


	float nfAng1[3], nfAng2[3];

	nfAng1[0] = fAng[0];
	nfAng1[1] = fAng[1] - 10.0;
	nfAng1[2] = fAng[2];
	
	nfAng2[0] = fAng[0];
	nfAng2[1] = fAng[1] + 10.0;
	nfAng2[2] = fAng[2];
	
	int iCarrier1 = CreateWandSpecialProjectile(NPCIdx, 500.0, fPos, nfAng1, 15.0);
	RND_BLASTER_CAGE_OWNER[iCarrier1] = EntIndexToEntRef(NPCIdx);
	
	int iCarrier2 = CreateWandSpecialProjectile(NPCIdx, 500.0, fPos, nfAng2, 15.0);
	RND_BLASTER_CAGE_OWNER[iCarrier2] = EntIndexToEntRef(NPCIdx);
	
	RND_BLASTER_CAGE_DUO[iCarrier1] = EntIndexToEntRef(iCarrier2);
	RND_BLASTER_CAGE_DUO[iCarrier2] = EntIndexToEntRef(iCarrier1);
	
	int beam = EntIndexToEntRef(ConnectWithBeam(iCarrier1, iCarrier2, 50, 50, 250, 3.0, 3.0, 1.35, "materials/sprites/lgtning.vmt"));					
	CreateTimer(15.0, Timer_RemoveEntityBeam, beam, TIMER_FLAG_NO_MAPCHANGE);
	
	RND_BLASTER_CAGE_LINK[iCarrier1] = beam;
	RND_BLASTER_CAGE_LINK[iCarrier2] = beam;
	
	CreateTimer(0.2, Timer_Electric_Cage_Think, iCarrier1, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	CreateTimer(0.1, Timer_Electric_Cage_Think_Next, iCarrier2, TIMER_FLAG_NO_MAPCHANGE);
	
	SDKHook(iCarrier1, SDKHook_StartTouch, Event_Electric_Cage_OnHatTouch);
	SDKHook(iCarrier2, SDKHook_StartTouch, Event_Electric_Cage_OnHatTouch);
}

public Action Timer_Electric_Cage_Think_Next(Handle timer, int iCarrier)
{
	CreateTimer(0.2, Timer_Electric_Cage_Think, iCarrier, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	return Plugin_Continue;
}

public Action Event_Electric_Cage_OnHatTouch(int entity, int other)
{
	int target = Target_Hit_Wand_Detection(entity, other);
	if (target > 0)	
	{
		//Code to do damage position and ragdolls
		static float angles[3];
		GetEntPropVector(entity, Prop_Send, "m_angRotation", angles);
		float vecForward[3];
		GetAngleVectors(angles, vecForward, NULL_VECTOR, NULL_VECTOR);
		static float Entity_Position[3];
		Entity_Position = WorldSpaceCenter(target);
		//Code to do damage position and ragdolls
		
		SDKHooks_TakeDamage(other, EntRefToEntIndex(RND_BLASTER_CAGE_OWNER[entity]), EntRefToEntIndex(RND_BLASTER_CAGE_OWNER[entity]), 100.0, DMG_PLASMA, -1, CalculateDamageForce(vecForward, 10000.0), Entity_Position, _ , ZR_DAMAGE_LASER_NO_BLAST);	// 2048 is DMG_NOGIB?
	}
	else if(target == 0)
	{
		int particle = EntRefToEntIndex(RND_BLASTER_CAGE_PARTICLE[entity]);
		if(IsValidEntity(particle) && particle != 0)
		{
			EmitSoundToAll(SOUND_ZAP, entity, SNDCHAN_STATIC, 70, _, 0.9);
			RemoveEntity(particle);
		}
		RemoveEntity(entity);
	}
	return Plugin_Handled;
}

public Action Timer_Electric_Cage_Think(Handle timer, int iCarrier)
{
	int NPCIdx = EntRefToEntIndex(RND_BLASTER_CAGE_OWNER[iCarrier]);
	int particle = EntRefToEntIndex(RND_BLASTER_CAGE_PARTICLE[iCarrier]);
	
	int otherCarier = EntRefToEntIndex(RND_BLASTER_CAGE_DUO[iCarrier]);
	int beam = EntRefToEntIndex(RND_BLASTER_CAGE_LINK[iCarrier]);
	
	if (!IsValidEdict(iCarrier) || iCarrier<=MaxClients)
	{
		
		if(IsValidEdict(particle) && particle>MaxClients)
		{
			RemoveEntity(particle);
		}
		
		if(IsValidEdict(iCarrier) && iCarrier>MaxClients)
		{
			RemoveEntity(iCarrier);
		}
		
		if(IsValidEdict(beam) && beam>MaxClients)
		{
			RemoveEntity(beam);
		}
		
		KillTimer(timer);
		return Plugin_Stop;
	}
	
	if (!IsValidEdict(otherCarier))
	{
		
		if(IsValidEdict(particle) && particle>MaxClients)
		{
			RemoveEntity(particle);
		}
		
		if(IsValidEdict(iCarrier) && iCarrier>MaxClients)
		{
			RemoveEntity(iCarrier);
		}
		
		if(IsValidEdict(beam) && beam>MaxClients)
		{
			RemoveEntity(beam);
		}
		
		KillTimer(timer);
		return Plugin_Stop;
	}
	
	if (!IsValidEntity(NPCIdx))
	{
		
		if(IsValidEdict(particle) && particle>MaxClients)
		{
			RemoveEntity(particle);
		}
		
		if(IsValidEdict(iCarrier) && iCarrier>MaxClients)
		{
			RemoveEntity(iCarrier);
		}
		
		if(IsValidEdict(beam) && beam>MaxClients)
		{
			RemoveEntity(beam);
		}
		
		KillTimer(timer);
		return Plugin_Stop;
	}
	
	float flCarrierPos[3], targPos[3];
	GetEntPropVector(iCarrier, Prop_Send, "m_vecOrigin", flCarrierPos);
	GetEntPropVector(otherCarier, Prop_Send, "m_vecOrigin", targPos);

	float flAngle[3];
	MakeVectorFromPoints(flCarrierPos, targPos, flAngle);
	GetVectorAngles(flAngle, flAngle);
	
	static float hullMin[3];
	static float hullMax[3];
	
	hullMin[0] = -100.0;
	hullMin[1] = hullMin[0];
	hullMin[2] = hullMin[0];
	hullMax[0] = -hullMin[0];
	hullMax[1] = -hullMin[1];
	hullMax[2] = -hullMin[2];
	Handle trace = TR_TraceHullFilterEx(flCarrierPos, targPos, hullMin, hullMax, 1073741824, Blaster_Cage_TraceUsers, NPCIdx);	// 1073741824 is CONTENTS_LADDER?
	delete trace;


	/*
	int r = 125;
	int g = 125;
	int b = 250;
	float diameter = 15.0;
		
	int colorLayer4[4];
	SetColorRGBA(colorLayer4, r, g, b, 60);
	int colorLayer3[4];
	SetColorRGBA(colorLayer3, colorLayer4[0] * 7 + 255 / 8, colorLayer4[1] * 7 + 255 / 8, colorLayer4[2] * 7 + 255 / 8, 60);
	int colorLayer2[4];
	SetColorRGBA(colorLayer2, colorLayer4[0] * 6 + 510 / 8, colorLayer4[1] * 6 + 510 / 8, colorLayer4[2] * 6 + 510 / 8, 60);
	int colorLayer1[4];
	SetColorRGBA(colorLayer1, colorLayer4[0] * 5 + 765 / 8, colorLayer4[1] * 5 + 765 / 8, colorLayer4[2] * 5 + 765 / 8, 60);
	TE_SetupBeamPoints(flCarrierPos, targPos, Beam_Laser, 0, 0, 0, 0.11, ClampBeamWidth(diameter * 0.3 * 1.28), ClampBeamWidth(diameter * 0.3 * 1.28), 0, 1.0, colorLayer1, 3);
	TE_SendToAll(0.0);
	TE_SetupBeamPoints(flCarrierPos, targPos, Beam_Laser, 0, 0, 0, 0.22, ClampBeamWidth(diameter * 0.5 * 1.28), ClampBeamWidth(diameter * 0.5 * 1.28), 0, 1.0, colorLayer2, 3);
	TE_SendToAll(0.0);
	TE_SetupBeamPoints(flCarrierPos, targPos, Beam_Laser, 0, 0, 0, 0.22, ClampBeamWidth(diameter * 0.8 * 1.28), ClampBeamWidth(diameter * 0.8 * 1.28), 0, 1.0, colorLayer3, 3);
	TE_SendToAll(0.0);
	TE_SetupBeamPoints(flCarrierPos, targPos, Beam_Laser, 0, 0, 0, 0.33, ClampBeamWidth(diameter * 1.28), ClampBeamWidth(diameter * 1.28), 0, 1.0, colorLayer4, 3);
	int glowColor[4];
	SetColorRGBA(glowColor, r, g, b, 200);
	TE_SetupBeamPoints(flCarrierPos, targPos, Beam_Glow, 0, 0, 0, 0.33, ClampBeamWidth(diameter * 1.28), ClampBeamWidth(diameter * 1.28), 0, 5.0, glowColor, 0);
	TE_SendToAll(0.0);
	*/
	
	return Plugin_Continue;
}

public Action Timer_RemoveEntityBeamBlaster(Handle timer, any entid)
{
	int entity = EntRefToEntIndex(entid);
	if (IsValidEdict(entity) && entity > MaxClients)
	{
		AcceptEntityInput(entity, "Kill", -1, -1, 0);
	}
	return Plugin_Continue;
}

public bool Blaster_Cage_TraceWallsOnly(int entity, int contentsMask)
{
	return !entity;
}


public bool Blaster_Cage_TraceUsers(int entity, int contentsMask, int NPCIdx)
{
	if (!IsEntityAlive(entity))
		return false;
		
	if (GetEntProp(NPCIdx, Prop_Send, "m_iTeamNum")==GetEntProp(entity, Prop_Send, "m_iTeamNum"))
		return false;
		
	SDKHooks_TakeDamage(entity, NPCIdx, NPCIdx, 20.0, DMG_PLASMA, -1);
	
	return false;
}