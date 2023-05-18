#pragma semicolon 1
#pragma newdecls required

methodmap EndSpeaker4 < EndSpeakerLarge
{
	public EndSpeaker4(bool ally)
	{
		float vecPos[3], vecAng[3];
		view_as<EndSpeaker>(0).GetSpawn(vecPos, vecAng);

		char health[12];
		IntToString(view_as<EndSpeaker>(0).m_iBaseHealth * 4, health, sizeof(health));

		EndSpeaker4 npc = view_as<EndSpeaker4>(CClotBody(vecPos, vecAng, "models/antlion_guard.mdl", "1.15", health, ally, false, true));
		
		i_NpcInternalId[npc.index] = ENDSPEAKER_4;
		npc.SetActivity("ACT_RUN");
		npc.AddGesture("ACT_ANTLIONGUARD_UNBURROW");
		
		npc.EatBuffs();
		npc.PlaySpawnSound();
		
		npc.m_iBleedType = BLEEDTYPE_SEABORN;
		npc.m_iStepNoiseType = STEPSOUND_GIANT;
		npc.m_iNpcStepVariation = STEPTYPE_SEABORN;
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, EndSpeaker_TakeDamage);
		SDKHook(npc.index, SDKHook_Think, EndSpeaker4_ClotThink);
		
		npc.m_flSpeed = 325.0;	// 0.8 + 0.5 x 250
		npc.m_flGetClosestTargetTime = 0.0;
		npc.m_flDoingAnimation = GetGameTime(npc.index) + 1.15;

		npc.m_flNextMeleeAttack = 0.0;
		npc.m_flAttackHappens = 0.0;
		
		SetEntityRenderMode(npc.index, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.index, 200, 200, 255, 255);
		return npc;
	}
}

public void EndSpeaker4_ClotThink(int iNPC)
{
	EndSpeaker4 npc = view_as<EndSpeaker4>(iNPC);

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
		npc.m_iTarget = GetClosestTarget(npc.index, npc.m_bIgnoreBuildings, _, true);
		npc.m_flGetClosestTargetTime = gameTime + 1.0;
	}
	
	if(npc.m_iTarget > 0)
	{
		float vecTarget[3]; vecTarget = WorldSpaceCenter(npc.m_iTarget);
		float distance = GetVectorDistance(vecTarget, WorldSpaceCenter(npc.index), true);
		
		if(npc.m_flAttackHappens)
		{
			npc.FaceTowards(vecTarget, 15000.0);
			
			if(npc.m_flAttackHappens < gameTime)
			{
				npc.m_flAttackHappens = 0.0;

				float attack = (npc.m_bHardMode ? 310.5 : 276.0) * npc.Attack(gameTime);
				// 800 x 1.15 x 0.3
				// 900 x 1.15 x 0.3

				bool failed = true;

				if(distance < 22500.0)
				{
					Handle swingTrace;
					if(npc.DoSwingTrace(swingTrace, npc.m_iTarget, _, _, _, _))
					{
						int target = TR_GetEntityIndex(swingTrace);	
						
						float vecHit[3];
						TR_GetEndPosition(vecHit, swingTrace);

						if(target > 0)
						{
							failed = false;

							if(ShouldNpcDealBonusDamage(target))
								attack *= 4.0;
							
							SDKHooks_TakeDamage(target, npc.index, npc.index, attack, DMG_CLUB);
							if(target <= MaxClients)
								Custom_Knockback(npc.index, target, attack * 2.0);
							
							CreateEarthquake(vecHit, 1.0, attack, 16.0, 255.0);
							npc.PlayMeleeHitSound();
						}
					}

					delete swingTrace;
				}

				if(failed)
				{
					vecTarget = PredictSubjectPositionForProjectiles(npc, npc.m_iTarget, 1200.0);
					
					int entity = -1;
					if(npc.m_hBuffs & BUFF_SPEWER)
					{
						npc.FireRocket(vecTarget, attack, 1200.0, "models/weapons/w_bugbait.mdl");
					}
					else
					{
						entity = npc.FireArrow(vecTarget, attack, 1200.0, "models/weapons/w_bugbait.mdl");
					}

					if(entity != -1)
					{
						if(IsValidEntity(f_ArrowTrailParticle[entity]))
							RemoveEntity(f_ArrowTrailParticle[entity]);
						
						SetEntityRenderMode(entity, RENDER_TRANSCOLOR);
						SetEntityRenderColor(entity, 100, 100, 255, 255);
						
						vecTarget = WorldSpaceCenter(entity);
						f_ArrowTrailParticle[entity] = ParticleEffectAt(vecTarget, "rockettrail_bubbles", 3.0);
						SetParent(entity, f_ArrowTrailParticle[entity]);
						f_ArrowTrailParticle[entity] = EntIndexToEntRef(f_ArrowTrailParticle[entity]);
					}
				}
			}
		}

		if(npc.m_flNextMeleeAttack < gameTime)
		{
			if(distance < 129600.0)	// 1.8 * 200
			{
				int target = Can_I_See_Enemy(npc.index, npc.m_iTarget);
				if(IsValidEnemy(npc.index, target, true))
				{
					npc.m_iTarget = target;

					npc.PlayMeleeSound();
					npc.AddGesture("ACT_MELEE_ATTACK1");
					
					npc.m_flAttackHappens = gameTime + 0.25;

					npc.m_flDoingAnimation = gameTime + 0.85;
					npc.m_flNextMeleeAttack = gameTime + 2.0;
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

			if(npc.m_bIgnoreBuildings)
				npc.SetActivity("ACT_ANTLIONGUARD_RUN_HURT");
		}
	}
	else
	{
		npc.StopPathing();
	}
}

void EndSpeaker4_NPCDeath(int entity)
{
	EndSpeaker4 npc = view_as<EndSpeaker4>(entity);
	
	if(!npc.m_bGib)
		npc.PlayDeathSound();

	SDKUnhook(npc.index, SDKHook_OnTakeDamage, EndSpeaker_TakeDamage);
	SDKUnhook(npc.index, SDKHook_Think, EndSpeaker4_ClotThink);
}