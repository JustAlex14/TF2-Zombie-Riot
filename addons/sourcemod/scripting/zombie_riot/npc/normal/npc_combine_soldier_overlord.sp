static const char g_DeathSounds[][] = {
	"npc/dog/dog_straining1.wav",
	"npc/dog/dog_straining2.wav",
	"npc/dog/dog_straining3.wav",
};

static const char g_HurtSounds[][] = {
	"npc/combine_soldier/pain1.wav",
	"npc/combine_soldier/pain2.wav",
	"npc/combine_soldier/pain3.wav",
};

static const char g_IdleSounds[][] = {
	"npc/dog/dog_playfull1.wav",
	"npc/dog/dog_playfull2.wav",
	"npc/dog/dog_playfull3.wav",
	"npc/dog/dog_playfull4.wav",
	"npc/dog/dog_playfull5.wav",
};

static const char g_IdleAlertedSounds[][] = {
	"npc/dog/dog_playfull1.wav",
	"npc/dog/dog_playfull3.wav",
	"npc/dog/dog_playfull4.wav",
	"npc/dog/dog_playfull5.wav",
};
static const char g_MeleeHitSounds[][] = {
	"weapons/halloween_boss/knight_axe_hit.wav",
};

static const char g_ChargeSounds[][] = {
	"npc/dog/dog_angry1.wav",
	"npc/dog/dog_angry2.wav",
	"npc/dog/dog_angry3.wav",
};

static const char g_MeleeAttackSounds[][] = {
	"weapons/demo_sword_swing1.wav",
	"weapons/demo_sword_swing2.wav",
	"weapons/demo_sword_swing3.wav",
};


static const char g_RangedAttackSounds[][] = {
	"weapons/ar2/fire1.wav",
};

static const char g_RangedAttackSoundsSecondary[][] = {
	"weapons/physcannon/energy_sing_explosion2.wav",
};

static const char g_RangedReloadSound[][] = {
	"weapons/ar2/npc_ar2_reload.wav",
};

static const char g_MeleeMissSounds[][] = {
	"weapons/cbar_miss1.wav",
};

void CombineOverlord_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));	   i++) { PrecacheSound(g_DeathSounds[i]);	   }
	for (int i = 0; i < (sizeof(g_HurtSounds));		i++) { PrecacheSound(g_HurtSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleSounds));		i++) { PrecacheSound(g_IdleSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	for (int i = 0; i < (sizeof(g_MeleeHitSounds));	i++) { PrecacheSound(g_MeleeHitSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds));	i++) { PrecacheSound(g_MeleeAttackSounds[i]);	}
	for (int i = 0; i < (sizeof(g_MeleeMissSounds));   i++) { PrecacheSound(g_MeleeMissSounds[i]);   }
	for (int i = 0; i < (sizeof(g_RangedAttackSounds));   i++) { PrecacheSound(g_RangedAttackSounds[i]);   }
	for (int i = 0; i < (sizeof(g_RangedReloadSound));   i++) { PrecacheSound(g_RangedReloadSound[i]);   }
	for (int i = 0; i < (sizeof(g_RangedAttackSoundsSecondary));   i++) { PrecacheSound(g_RangedAttackSoundsSecondary[i]);   }
	for (int i = 0; i < (sizeof(g_ChargeSounds));   i++) { PrecacheSound(g_ChargeSounds[i]);   }
	PrecacheModel("models/zombie_riot/bosses/overlord_1.mdl");
}

methodmap CombineOverlord < CClotBody
{
	public void PlayIdleSound() {
		if(this.m_flNextIdleSound > GetGameTime())
			return;
		EmitSoundToAll(g_IdleSounds[GetRandomInt(0, sizeof(g_IdleSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		this.m_flNextIdleSound = GetGameTime() + GetRandomFloat(24.0, 48.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleSound()");
		#endif
	}
	
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetGameTime())
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		this.m_flNextIdleSound = GetGameTime() + GetRandomFloat(12.0, 24.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleAlertSound()");
		#endif
	}
	
	public void PlayHurtSound() {
		if(this.m_flNextHurtSound > GetGameTime())
			return;
			
		this.m_flNextHurtSound = GetGameTime() + 0.4;
		
		EmitSoundToAll(g_HurtSounds[GetRandomInt(0, sizeof(g_HurtSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayHurtSound()");
		#endif
	}
	
	public void PlayDeathSound() {
	
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayDeathSound()");
		#endif
	}
	
	public void PlayMeleeSound() {
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, _, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
	
	public void PlayRangedSound() {
		EmitSoundToAll(g_RangedAttackSounds[GetRandomInt(0, sizeof(g_RangedAttackSounds) - 1)], this.index, _, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayRangedSound()");
		#endif
	}
	public void PlayRangedReloadSound() {
		EmitSoundToAll(g_RangedReloadSound[GetRandomInt(0, sizeof(g_RangedReloadSound) - 1)], this.index, _, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayRangedSound()");
		#endif
	}
	public void PlayRangedAttackSecondarySound() {
		EmitSoundToAll(g_RangedAttackSoundsSecondary[GetRandomInt(0, sizeof(g_RangedAttackSoundsSecondary) - 1)], this.index, _, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayRangedSound()");
		#endif
	}
	
	public void PlayMeleeHitSound() {
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, _, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}
	
	public void PlaySpecialChargeSound() {
		EmitSoundToAll(g_ChargeSounds[GetRandomInt(0, sizeof(g_ChargeSounds) - 1)], this.index, _, 110, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayMeleeHitSound()");
		#endif
	}

	public void PlayMeleeMissSound() {
		EmitSoundToAll(g_MeleeMissSounds[GetRandomInt(0, sizeof(g_MeleeMissSounds) - 1)], this.index, _, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CGoreFast::PlayMeleeMissSound()");
		#endif
	}
	
	public CombineOverlord(int client, float vecPos[3], float vecAng[3])
	{
		CombineOverlord npc = view_as<CombineOverlord>(CClotBody(vecPos, vecAng, "models/zombie_riot/bosses/overlord_1.mdl", "1.0", "35000"));
		
		i_NpcInternalId[npc.index] = COMBINE_OVERLORD;
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE_ALLCLASS");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
		
		
		npc.m_flNextMeleeAttack = 0.0;
		
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;	
		npc.m_iNpcStepVariation = STEPTYPE_COMBINE;
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, CombineOverlord_ClotDamaged);
		SDKHook(npc.index, SDKHook_Think, CombineOverlord_ClotThink);
		
		npc.m_bDissapearOnDeath = true;
		npc.m_bThisNpcIsABoss = true;
		npc.m_iState = 0;
		npc.m_flSpeed = 250.0;
		npc.m_flNextRangedAttack = 0.0;
		npc.m_flNextRangedSpecialAttack = 0.0;
		npc.m_flAttackHappenswillhappen = false;
		npc.m_fbRangedSpecialOn = false;
		npc.m_flNextChargeSpecialAttack = GetGameTime() + 5.0;

		SetEntProp(npc.index, Prop_Send, "m_bGlowEnabled", true);
		/*
		npc.m_iWearable2 = npc.EquipItem("weapon_bone", "models/weapons/c_models/c_claymore/c_claymore.mdl");
		SetVariantString("0.7");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		
		SetEntProp(npc.m_iWearable2, Prop_Send, "m_nSkin", 2);
		
		npc.m_iWearable1 = npc.EquipItem("partyhat", "models/player/items/demo/crown.mdl");
		SetVariantString("1.25");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		*/
		return npc;
	}
	
	
}

//TODO 
//Rewrite
public void CombineOverlord_ClotThink(int iNPC)
{
	CombineOverlord npc = view_as<CombineOverlord>(iNPC);
	
	SetVariantInt(1);
	AcceptEntityInput(iNPC, "SetBodyGroup");
	
	if(npc.m_flNextDelayTime > GetGameTime())
	{
		return;
	}
	
	npc.m_flNextDelayTime = GetGameTime() + 0.04;
	
	npc.Update();
	
	//Think throttling
	if(npc.m_flNextThinkTime > GetGameTime()) {
		return;
	}
	
	npc.m_flNextThinkTime = GetGameTime() + 0.10;

	if(npc.m_flGetClosestTargetTime < GetGameTime())
	{
		npc.m_iTarget = GetClosestTarget(npc.index);
		npc.m_flGetClosestTargetTime = GetGameTime() + 1.0;
	}
	
	int PrimaryThreatIndex = npc.m_iTarget;
	
	if(IsValidEnemy(npc.index, PrimaryThreatIndex, true))
	{
			float vecTarget[3]; vecTarget = WorldSpaceCenter(PrimaryThreatIndex);
			if (npc.m_flReloadDelay < GetGameTime())
			{
				if (npc.m_flmovedelay < GetGameTime() && npc.m_flAngerDelay < GetGameTime())
				{
					int iActivity_melee = npc.LookupActivity("ACT_MP_RUN_MELEE_ALLCLASS");
					if(iActivity_melee > 0) npc.StartActivity(iActivity_melee);
					npc.m_flmovedelay = GetGameTime() + 1.0;
					npc.m_flSpeed = 330.0;
				}
				if (npc.m_flmovedelay < GetGameTime() && npc.m_flAngerDelay > GetGameTime())
				{
					int iActivity_melee = npc.LookupActivity("ACT_MP_RUN_MELEE");
					if(iActivity_melee > 0) npc.StartActivity(iActivity_melee);
					npc.m_flmovedelay = GetGameTime() + 1.0;
					npc.m_flSpeed = 380.0;
				}
			//	npc.FaceTowards(vecTarget);
			}
			
		//	npc.FaceTowards(vecTarget, 1000.0);
			
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
			
			if(npc.m_flNextChargeSpecialAttack < GetGameTime() && npc.m_flReloadDelay < GetGameTime() && flDistanceToTarget < 422500)
			{
				npc.m_flNextChargeSpecialAttack = GetGameTime() + 20.0;
				npc.m_flReloadDelay = GetGameTime() + 2.0;
				npc.m_flRangedSpecialDelay += GetGameTime() + 2.0;
				npc.m_flAngerDelay = GetGameTime() + 5.0;
				npc.DispatchParticleEffect(npc.index, "hightower_explosion", NULL_VECTOR, NULL_VECTOR, NULL_VECTOR, npc.FindAttachment("anim_attachment_LH"), PATTACH_POINT_FOLLOW, true);
				npc.PlaySpecialChargeSound();
				int iActivity_melee = npc.LookupActivity("OVERLORD_RAGE");
				if(iActivity_melee > 0) npc.StartActivity(iActivity_melee);
				npc.m_flmovedelay = GetGameTime() + 0.5;
				PF_StopPathing(npc.index);
				npc.m_bPathing = false;
			}
	
			if(npc.m_flNextRangedSpecialAttack < GetGameTime() && flDistanceToTarget < 22500 && npc.m_flAngerDelay < GetGameTime() || npc.m_fbRangedSpecialOn)
			{
			//	npc.FaceTowards(vecTarget, 2000.0);
				if(!npc.m_fbRangedSpecialOn)
				{
					PF_StopPathing(npc.index);
					npc.m_bPathing = false;
					npc.AddGesture("ACT_ATTACK_HAND");
					npc.m_flRangedSpecialDelay = GetGameTime() + 0.3;
					npc.m_fbRangedSpecialOn = true;
					npc.m_flReloadDelay = GetGameTime() + 0.4;
				}
				if(npc.m_flRangedSpecialDelay < GetGameTime())
				{
					npc.m_fbRangedSpecialOn = false;
					npc.m_flNextRangedSpecialAttack = GetGameTime() + 2.0;
					npc.PlayRangedAttackSecondarySound();

					float vecSpread = 0.1;
					
					npc.FaceTowards(vecTarget, 20000.0);
					
					float eyePitch[3];
					GetEntPropVector(npc.index, Prop_Data, "m_angRotation", eyePitch);
							
					//
					//
					
					
					float x, y;
					x = GetRandomFloat( -0.01, 0.01 ) + GetRandomFloat( -0.01, 0.01 );
					y = GetRandomFloat( -0.01, 0.01 ) + GetRandomFloat( -0.01, 0.01 );
					
					float vecDirShooting[3], vecRight[3], vecUp[3];
					//GetAngleVectors(eyePitch, vecDirShooting, vecRight, vecUp);
					
					vecTarget[2] += 15.0;
					MakeVectorFromPoints(WorldSpaceCenter(npc.index), vecTarget, vecDirShooting);
					GetVectorAngles(vecDirShooting, vecDirShooting);
					vecDirShooting[1] = eyePitch[1];
					GetAngleVectors(vecDirShooting, vecDirShooting, vecRight, vecUp);
					
					//add the spray
					float vecDir[3];
					vecDir[0] = vecDirShooting[0] + x * vecSpread * vecRight[0] + y * vecSpread * vecUp[0]; 
					vecDir[1] = vecDirShooting[1] + x * vecSpread * vecRight[1] + y * vecSpread * vecUp[1]; 
					vecDir[2] = vecDirShooting[2] + x * vecSpread * vecRight[2] + y * vecSpread * vecUp[2]; 
					NormalizeVector(vecDir, vecDir);
					
					npc.DispatchParticleEffect(npc.index, "mvm_soldier_shockwave", NULL_VECTOR, NULL_VECTOR, NULL_VECTOR, npc.FindAttachment("anim_attachment_LH"), PATTACH_POINT_FOLLOW, true);
					
					FireBullet(npc.index, npc.index, WorldSpaceCenter(npc.index), vecDir, 50.0, 150.0, DMG_BULLET, "bullet_tracer02_blue");
				}
			}
			
			//Target close enough to hit
			if(flDistanceToTarget < 10000 && npc.m_flReloadDelay < GetGameTime() || npc.m_flAttackHappenswillhappen)
			{
				PF_StartPathing(npc.index);
				npc.m_bPathing = true;
				
			//	npc.FaceTowards(vecTarget, 1000.0);
				
				if(npc.m_flAngerDelay > GetGameTime() && npc.m_flReloadDelay < GetGameTime())
				{
					
					npc.FaceTowards(vecTarget, 20000.0);
					Handle swingTrace;
					if(npc.DoSwingTrace(swingTrace, PrimaryThreatIndex))
					{
						
						int target = TR_GetEntityIndex(swingTrace);	
						
						float vecHit[3];
						TR_GetEndPosition(vecHit, swingTrace);
						
						if(target > 0) 
						{
							if(target <= MaxClients)
								SDKHooks_TakeDamage(target, npc.index, npc.index, 25.0, DMG_SLASH|DMG_CLUB);
							else
								SDKHooks_TakeDamage(target, npc.index, npc.index, 50.0, DMG_SLASH|DMG_CLUB);
								
							Custom_Knockback(npc.index, target, 200.0);
							// Hit particle
							npc.DispatchParticleEffect(npc.index, "blood_impact_backscatter", vecHit, NULL_VECTOR, NULL_VECTOR);
							
							// Hit sound
							npc.PlayMeleeHitSound();
						} 
					}
					delete swingTrace;
				}
				else
				{
					if(npc.m_flNextMeleeAttack < GetGameTime())
					{
						if (!npc.m_flAttackHappenswillhappen)
						{
							if(npc.m_flAngerDelay < GetGameTime())
							{
								npc.m_flNextRangedSpecialAttack = GetGameTime() + 2.0;
								npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE");
								npc.PlayMeleeSound();
								npc.m_flAttackHappens = GetGameTime()+0.4;
								npc.m_flAttackHappens_bullshit = GetGameTime()+0.54;
								npc.m_flAttackHappenswillhappen = true;
							}
							else
							{
								npc.m_flNextRangedSpecialAttack = GetGameTime() + 2.0;
								npc.m_flAttackHappens = GetGameTime()+0.0;
								npc.m_flAttackHappens_bullshit = GetGameTime()+0.14;
								npc.m_flAttackHappenswillhappen = true;		
								
							}
						}
							
						if (npc.m_flAttackHappens < GetGameTime() && npc.m_flAttackHappens_bullshit >= GetGameTime() && npc.m_flAttackHappenswillhappen)
						{
							npc.FaceTowards(vecTarget, 20000.0);
							Handle swingTrace;
							if(npc.DoSwingTrace(swingTrace, PrimaryThreatIndex))
								{
									
									int target = TR_GetEntityIndex(swingTrace);	
									
									float vecHit[3];
									TR_GetEndPosition(vecHit, swingTrace);
									
									if(target > 0) 
									{
										if(npc.m_flAngerDelay < GetGameTime())
										{
											if(target <= MaxClients)
												SDKHooks_TakeDamage(target, npc.index, npc.index, 100.0, DMG_SLASH|DMG_CLUB);
											else
												SDKHooks_TakeDamage(target, npc.index, npc.index, 400.0, DMG_SLASH|DMG_CLUB);
												
											Custom_Knockback(npc.index, target, 450.0);
										}
										
										else if(npc.m_flAngerDelay > GetGameTime())
										{
											if(target <= MaxClients)
												SDKHooks_TakeDamage(target, npc.index, npc.index, 25.0, DMG_SLASH|DMG_CLUB);
											else
												SDKHooks_TakeDamage(target, npc.index, npc.index, 50.0, DMG_SLASH|DMG_CLUB);
												
											Custom_Knockback(npc.index, target, 200.0);
										}
										
										// Hit particle
										npc.DispatchParticleEffect(npc.index, "blood_impact_backscatter", vecHit, NULL_VECTOR, NULL_VECTOR);
										
										// Hit sound
										npc.PlayMeleeHitSound();
									} 
								}
							delete swingTrace;
							npc.m_flNextMeleeAttack = GetGameTime() + 0.4;
							npc.m_flAttackHappenswillhappen = false;
						}
						else if (npc.m_flAttackHappens_bullshit < GetGameTime() && npc.m_flAttackHappenswillhappen)
						{
							npc.m_flAttackHappenswillhappen = false;
							npc.m_flNextMeleeAttack = GetGameTime() + 0.4;
						}
					}
				}
			}
			if (npc.m_flReloadDelay < GetGameTime())
			{
				PF_StartPathing(npc.index);
				npc.m_bPathing = true;
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

public Action CombineOverlord_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	//Valid attackers only.
	if(attacker <= 0)
		return Plugin_Continue;
		
	CombineOverlord npc = view_as<CombineOverlord>(victim);
	
	
	if (npc.m_flHeadshotCooldown < GetGameTime())
	{
		npc.m_flHeadshotCooldown = GetGameTime() + 0.25;
	//	npc.AddGesture("OVERLORD_STAGGER");
		npc.PlayHurtSound();
		
	}
	
	if(npc.m_flAngerDelay > GetGameTime())
		damage *= 0.25;
		
	if(npc.m_fbRangedSpecialOn)
		damage *= 0.75;
		
	
	return Plugin_Changed;
}

public void CombineOverlord_NPCDeath(int entity)
{
	CombineOverlord npc = view_as<CombineOverlord>(entity);
	if(!npc.m_bGib)
	{
		npc.PlayDeathSound();	
	}
	
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, CombineOverlord_ClotDamaged);
	SDKUnhook(npc.index, SDKHook_Think, CombineOverlord_ClotThink);
		
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
		
	int entity_death = CreateEntityByName("prop_dynamic_override");
	if(IsValidEntity(entity_death))
	{
		float pos[3];
		float Angles[3];
		GetEntPropVector(entity, Prop_Data, "m_angRotation", Angles);

		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
		TeleportEntity(entity_death, pos, Angles, NULL_VECTOR);
		
//		GetEntPropString(client, Prop_Data, "m_ModelName", model, sizeof(model));
		DispatchKeyValue(entity_death, "model", "models/zombie_riot/bosses/overlord_1.mdl");

		DispatchSpawn(entity_death);
		
		SetEntPropFloat(entity_death, Prop_Send, "m_flModelScale", 1.0); 
		SetEntityCollisionGroup(entity_death, 2);
		SetVariantString("OVERLORD_DEATH");
		AcceptEntityInput(entity_death, "SetAnimation");
		
		pos[2] += 20.0;
		
		CreateTimer(2.0, Timer_RemoveEntityOverlord, EntIndexToEntRef(entity_death), TIMER_FLAG_NO_MAPCHANGE);

	}
}