#pragma semicolon 1
#pragma newdecls required
 
static const char g_DeathSounds[][] =
{
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/no02.wav",
};

static const char g_IdleAlertedSounds[][] =
{
	"vo/npc/male01/ohno.wav",
	"vo/npc/male01/overthere01.wav",
	"vo/npc/male01/overthere02.wav",
};

static const char g_AngerSounds[][] =
{
	"npc/roller/mine/rmine_taunt2.wav"
};

static const char g_MeleeAttackSounds[][] =
{
	"weapons/bow_shoot.wav",
};

static int HitEnemies[16];

void FirstToTalk_MapStart()
{
	PrecacheSoundArray(g_DeathSounds);
	PrecacheSoundArray(g_IdleAlertedSounds);
	PrecacheSoundArray(g_AngerSounds);
}

methodmap FirstToTalk < CClotBody
{
	public void PlayIdleSound()
	{
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME, 100);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
	}
	public void PlayDeathSound() 
	{
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME, 100);
	}
	public void PlayAngerSound()
 	{
		EmitSoundToAll(g_AngerSounds[GetRandomInt(0, sizeof(g_AngerSounds) - 1)], this.index, SNDCHAN_AUTO, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayMeleeSound()
 	{
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_AUTO, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	
	public FirstToTalk(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		FirstToTalk npc = view_as<FirstToTalk>(CClotBody(vecPos, vecAng, COMBINE_CUSTOM_MODEL, "1.15", "3150", ally, false));
		// 21000 x 0.15

		SetVariantInt(4);
		AcceptEntityInput(npc.index, "SetBodyGroup");

		i_NpcInternalId[npc.index] = FIRSTTOTALK;
		npc.SetActivity("ACT_CUSTOM_WALK_SPEAR");
		
		npc.m_iBleedType = BLEEDTYPE_SEABORN;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;
		npc.m_iNpcStepVariation = STEPTYPE_SEABORN;
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, FirstToTalk_TakeDamage);
		SDKHook(npc.index, SDKHook_Think, FirstToTalk_ClotThink);
		
		npc.m_flSpeed = 200.0;	// 0.8 x 250
		npc.m_flGetClosestTargetTime = 0.0;

		npc.m_flNextMeleeAttack = 0.0;
		npc.m_flNextRangedAttack = GetGameTime(npc.index) + 10.0;
		
		SetEntityRenderMode(npc.index, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.index, 100, 100, 255, 255);

		float vecMe[3]; vecMe = WorldSpaceCenter(npc.index);
		npc.m_iWearable1 = ParticleEffectAt(vecMe, "env_rain_128", -1.0);
		SetParent(npc.index, npc.m_iWearable1);
		return npc;
	}
}

public void FirstToTalk_ClotThink(int iNPC)
{
	FirstToTalk npc = view_as<FirstToTalk>(iNPC);

	float gameTime = GetGameTime(npc.index);
	if(npc.m_flNextDelayTime > gameTime)
		return;
	
	npc.m_flNextDelayTime = gameTime + DEFAULT_UPDATE_DELAY_FLOAT;
	npc.Update();
	
	if(npc.m_flNextThinkTime > gameTime)
		return;
	
	npc.m_flNextThinkTime = gameTime + 0.1;

	if(npc.m_iTarget && !IsValidEnemy(npc.index, npc.m_iTarget, true))
		npc.m_iTarget = 0;
	
	if(!npc.m_iTarget || npc.m_flGetClosestTargetTime < gameTime)
	{
		npc.m_iTarget = GetClosestTarget(npc.index, _, _, true);
		npc.m_flGetClosestTargetTime = gameTime + 1.0;
	}
	
	if(npc.m_iTarget > 0)
	{
		float vecTarget[3]; vecTarget = WorldSpaceCenter(npc.m_iTarget);
		float distance = GetVectorDistance(vecTarget, WorldSpaceCenter(npc.index), true);
		
		if(npc.m_flAttackHappens)
		{
			if(npc.m_flAttackHappens < gameTime)
			{
				npc.m_flAttackHappens = 0.0;
				
				npc.FaceTowards(vecTarget, 15000.0);

				npc.PlayMeleeSound();
				int entity = npc.FireArrow(vecTarget, 90.0, 1200.0);
				// 600 x 0.15
				SDKUnhook(entity, SDKHook_StartTouch, ArrowStartTouch);
				SDKHook(entity, SDKHook_StartTouch, ArrowStartTouchFirstTalk);
				// 600 x 0.4 x 0.15

				if(entity != -1)
				{
					if(IsValidEntity(f_ArrowTrailParticle[entity]))
						RemoveEntity(f_ArrowTrailParticle[entity]);
					
					vecTarget = WorldSpaceCenter(entity);
					f_ArrowTrailParticle[entity] = ParticleEffectAt(vecTarget, "water_playerdive_bubbles", 3.0);
					SetParent(entity, f_ArrowTrailParticle[entity]);
					f_ArrowTrailParticle[entity] = EntIndexToEntRef(f_ArrowTrailParticle[entity]);
				}
			}
		}

		if(distance < 250000.0 && npc.m_flNextMeleeAttack < gameTime)	// 2.5 * 200
		{
			int target = Can_I_See_Enemy(npc.index, npc.m_iTarget);
			if(IsValidEnemy(npc.index, target, true))
			{
				npc.m_iTarget = target;

				if(npc.m_flNextRangedAttack < gameTime)
				{
					npc.PlayAngerSound();
					npc.SetActivity("ACT_MUDROCK_RAGE");
					b_NpcIsInvulnerable[npc.index] = true;
					
					vecTarget[2] += 10.0;

					DataPack pack = new DataPack();
					pack.WriteCell(EntIndexToEntRef(npc.index));
					pack.WriteFloat(vecTarget[0]);
					pack.WriteFloat(vecTarget[1]);
					pack.WriteFloat(vecTarget[2]);

					CreateTimer(1.0, FirstToTalk_TimerShoot, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(1.5, FirstToTalk_TimerShoot, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(2.0, FirstToTalk_TimerShoot, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(2.5, FirstToTalk_TimerShoot, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(3.0, FirstToTalk_TimerShoot, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(3.5, FirstToTalk_TimerShoot, pack, TIMER_FLAG_NO_MAPCHANGE);

					CreateTimer(5.0, FirstToTalk_TimerAttack, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(5.75, FirstToTalk_TimerAttack, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(6.5, FirstToTalk_TimerAttack, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(7.25, FirstToTalk_TimerAttack, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(8.0, FirstToTalk_TimerAttack, pack, TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(8.75, FirstToTalk_TimerAttack, pack, TIMER_FLAG_NO_MAPCHANGE|TIMER_DATA_HNDL_CLOSE);

					spawnRing_Vectors(vecTarget, 650.0, 0.0, 0.0, 0.0, "materials/sprites/laserbeam.vmt", 50, 50, 255, 200, 1, 9.0, 6.0, 0.1, 1);

					npc.m_flDoingAnimation = gameTime + 8.0;
					npc.m_flNextMeleeAttack = gameTime + 10.0;
					npc.m_flNextRangedAttack = gameTime + 40.0;
				}
				else
				{
					npc.AddGesture("ACT_CUSTOM_ATTACK_SPEAR");
					
					npc.m_flAttackHappens = gameTime + 0.35;

					npc.m_flDoingAnimation = gameTime + 1.0;
					npc.m_flNextMeleeAttack = gameTime + 3.0;
				}
			}
		}
		
		if(npc.m_flDoingAnimation > gameTime)
		{
			npc.StopPathing();
		}
		else
		{
			if(distance < npc.GetLeadRadius())
			{
				float vPredictedPos[3]; vPredictedPos = PredictSubjectPosition(npc, npc.m_iTarget);
				PF_SetGoalVector(npc.index, vPredictedPos);
			}
			else 
			{
				PF_SetGoalEntity(npc.index, npc.m_iTarget);
			}

			npc.StartPathing();

			if(b_NpcIsInvulnerable[npc.index])
			{
				b_NpcIsInvulnerable[npc.index] = false;
				npc.SetActivity("ACT_CUSTOM_WALK_SPEAR");
			}
		}
	}
	else
	{
		npc.StopPathing();
	}

	npc.PlayIdleSound();
}

public Action FirstToTalk_TimerShoot(Handle timer, DataPack pack)
{
	pack.Reset();
	FirstToTalk npc = view_as<FirstToTalk>(EntRefToEntIndex(pack.ReadCell()));
	if(npc.index != INVALID_ENT_REFERENCE)
	{
		float vecPos[3]; vecPos = WorldSpaceCenter(npc.index);
		vecPos[2] += 100.0;

		npc.PlayMeleeSound();

		int entity = npc.FireArrow(vecPos, 90.0, 2000.0);
		if(entity != -1)
		{
			if(IsValidEntity(f_ArrowTrailParticle[entity]))
				RemoveEntity(f_ArrowTrailParticle[entity]);
			
			vecPos = WorldSpaceCenter(entity);
			f_ArrowTrailParticle[entity] = ParticleEffectAt(vecPos, "water_playerdive_bubbles", 3.0);
			SetParent(entity, f_ArrowTrailParticle[entity]);
			f_ArrowTrailParticle[entity] = EntIndexToEntRef(f_ArrowTrailParticle[entity]);
		}
	}
	return Plugin_Stop;
}

public Action FirstToTalk_TimerAttack(Handle timer, DataPack pack)
{
	pack.Reset();
	FirstToTalk npc = view_as<FirstToTalk>(EntRefToEntIndex(pack.ReadCell()));
	if(npc.index != INVALID_ENT_REFERENCE)
	{
		float vecPos[3];
		vecPos[0] = pack.ReadFloat();
		vecPos[1] = pack.ReadFloat();
		vecPos[2] = pack.ReadFloat();

		//spawnRing_Vectors(vecPos, 10.0, 0.0, 0.0, 0.0, "materials/sprites/laserbeam.vmt", 255, 50, 50, 200, 1, 0.4, 6.0, 0.1, 1, 650.0);

		Zero(HitEnemies);
		TR_EnumerateEntitiesSphere(vecPos, 325.0, PARTITION_NON_STATIC_EDICTS, FirstToTalk_EnumerateEntitiesInRange, npc.index);

		// Hits the target with the highest armor within range

		int victim;
		int armor = -9999999;
		for(int i; i < sizeof(HitEnemies); i++)
		{
			if(!HitEnemies[i])
				break;
			
			int myArmor = 1;
			if(HitEnemies[i] <= MaxClients)
				myArmor = Armor_Charge[HitEnemies[i]];
			
			if(myArmor > armor)
			{
				victim = HitEnemies[i];
				armor = myArmor;
			}
		}

		if(victim)
		{
			vecPos = WorldSpaceCenter(npc.index);
			ParticleEffectAt(vecPos, "water_splash01", 3.0);

			vecPos[2] += 250.0;

			int entity = npc.FireArrow(vecPos, 90.0, 3000.0);
			if(entity != -1)
			{
				TeleportEntity(entity, vecPos, {90.0, 0.0, 0.0}, {0.0, 0.0, -3000.0});

				if(IsValidEntity(f_ArrowTrailParticle[entity]))
					RemoveEntity(f_ArrowTrailParticle[entity]);
				
				vecPos = WorldSpaceCenter(entity);
				f_ArrowTrailParticle[entity] = ParticleEffectAt(vecPos, "water_playerdive_bubbles", 3.0);
				SetParent(entity, f_ArrowTrailParticle[entity]);
				f_ArrowTrailParticle[entity] = EntIndexToEntRef(f_ArrowTrailParticle[entity]);
			}

			//SDKHooks_TakeDamage(victim, npc.index, npc.index, 90.0, DMG_BULLET);
			// 600 x 0.15
			
			SeaSlider_AddNeuralDamage(victim, npc.index, 36);
			// 600 x 0.4 x 0.15
		}
	}
	return Plugin_Stop;
}

public bool FirstToTalk_EnumerateEntitiesInRange(int victim, int attacker)
{
	if(IsValidEnemy(attacker, victim, true))
	{
		for(int i; i < sizeof(HitEnemies); i++)
		{
			if(!HitEnemies[i])
			{
				HitEnemies[i] = victim;
				return true;
			}
		}

		return false;
	}

	return true;
}

public Action FirstToTalk_TakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if(attacker < 1)
		return Plugin_Continue;
	
	FirstToTalk npc = view_as<FirstToTalk>(victim);
	if(b_NpcIsInvulnerable[npc.index])
		damage = 0.0;
	
	return Plugin_Changed;
}

void FirstToTalk_NPCDeath(int entity)
{
	FirstToTalk npc = view_as<FirstToTalk>(entity);
	if(!npc.m_bGib)
		npc.PlayDeathSound();
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, FirstToTalk_TakeDamage);
	SDKUnhook(npc.index, SDKHook_Think, FirstToTalk_ClotThink);

	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
}



public void ArrowStartTouchFirstTalk(int arrow, int entity)
{
	if(entity > 0 && entity < MAXENTITIES)
	{
		int arrow_particle = EntRefToEntIndex(f_ArrowTrailParticle[arrow]);
		if(ShouldNpcDealBonusDamage(entity))
		{
			f_ArrowDamage[arrow] *= 3.0;
		}

		int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
		if(owner == -1)
			owner = arrow;

		int inflictor = h_ArrowInflictorRef[arrow];
		if(inflictor != -1)
			inflictor = EntRefToEntIndex(h_ArrowInflictorRef[arrow]);

		if(inflictor == -1)
			inflictor = owner;

		SeaSlider_AddNeuralDamage(entity, owner, 36);
		SDKHooks_TakeDamage(entity, owner, inflictor, f_ArrowDamage[arrow], DMG_BULLET|DMG_PREVENT_PHYSICS_FORCE, -1);
		EmitSoundToAll(g_ArrowHitSoundSuccess[GetRandomInt(0, sizeof(g_ArrowHitSoundSuccess) - 1)], arrow, _, 80, _, 0.8, 100);
		if(IsValidEntity(arrow_particle))
		{
			DispatchKeyValue(arrow_particle, "parentname", "none");
			AcceptEntityInput(arrow_particle, "ClearParent");
			float f3_PositionTemp[3];
			GetEntPropVector(arrow_particle, Prop_Data, "m_vecAbsOrigin", f3_PositionTemp);
			TeleportEntity(arrow_particle, f3_PositionTemp, NULL_VECTOR, {0.0,0.0,0.0});
			CreateTimer(0.5, Timer_RemoveEntity, EntIndexToEntRef(arrow_particle), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	else
	{
		int arrow_particle = EntRefToEntIndex(f_ArrowTrailParticle[arrow]);
		EmitSoundToAll(g_ArrowHitSoundMiss[GetRandomInt(0, sizeof(g_ArrowHitSoundMiss) - 1)], arrow, _, 80, _, 0.8, 100);
		if(IsValidEntity(arrow_particle))
		{
			DispatchKeyValue(arrow_particle, "parentname", "none");
			AcceptEntityInput(arrow_particle, "ClearParent");
			float f3_PositionTemp[3];
			GetEntPropVector(arrow_particle, Prop_Data, "m_vecAbsOrigin", f3_PositionTemp);
			TeleportEntity(arrow_particle, f3_PositionTemp, NULL_VECTOR, {0.0,0.0,0.0});
			CreateTimer(0.5, Timer_RemoveEntity, EntIndexToEntRef(arrow_particle), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	RemoveEntity(arrow);
}