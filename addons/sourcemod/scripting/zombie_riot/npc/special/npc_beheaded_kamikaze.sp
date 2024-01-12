#pragma semicolon 1
#pragma newdecls required


static const char g_IdleAlertedSounds[][] = {
	"zombie_riot/miniboss/kamikaze/become_enraged56.wav",
};

static const char g_Spawn[][] = {
	"zombie_riot/miniboss/kamikaze/spawn.wav",
};

static float fl_AlreadyStrippedMusic[MAXTF2PLAYERS];
static float fl_KamikazeInitiate;
static float fl_KamikazeSpawnDelay;
static float fl_KamikazeSpawnRateDelay;
static float fl_KamikazeSpawnDuration;
static bool b_KamikazeEvent;
void BeheadedKamiKaze_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_Spawn));	   i++) { PrecacheSoundCustom(g_Spawn[i]);	   }
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSoundCustom(g_IdleAlertedSounds[i]); }
	PrecacheModel("models/zombie_riot/serious/kamikaze_3.mdl");
	PrecacheSoundCustom("#zombie_riot/miniboss/kamikaze/sam_rush_2.mp3");
		
	fl_KamikazeInitiate = 0.0;
	fl_KamikazeSpawnDelay = 0.0;
	fl_KamikazeSpawnDuration = 0.0;
	b_KamikazeEvent = false;
}


static char[] GetBeheadedKamiKazeHealth()
{
	int health = 3;
	
	health *= CountPlayersOnRed(); //yep its high! will need tos cale with waves expoentially.
	
	float temp_float_hp = float(health);
	
	health = RoundToCeil(Pow(((temp_float_hp + float(CurrentRound+1)) * float(CurrentRound+1)),1.15));

	health = health * 3 / 8;
	
	char buffer[16];
	IntToString(health, buffer, sizeof(buffer));
	return buffer;
}

methodmap BeheadedKamiKaze < CClotBody
{
	
	
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetEngineTime())
			return;
		

		EmitCustomToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, 75, _, BOSS_ZOMBIE_VOLUME, 100);
		this.m_flNextIdleSound = GetEngineTime() + 0.85;
		
	}
	
	public void PlaySpawnSound() {
		
		EmitCustomToAll(g_Spawn[GetRandomInt(0, sizeof(g_Spawn) - 1)], this.index, SNDCHAN_AUTO, BOSS_ZOMBIE_SOUNDLEVEL, _, 1.5, 100);
		
	}
	
	public BeheadedKamiKaze(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		BeheadedKamiKaze npc = view_as<BeheadedKamiKaze>(CClotBody(vecPos, vecAng, "models/zombie_riot/serious/kamikaze_3.mdl", "1.10", GetBeheadedKamiKazeHealth(), ally));
		
		i_NpcInternalId[npc.index] = MINI_BEHEADED_KAMI;
		i_NpcWeight[npc.index] = 2;
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN");
		if(iActivity > 0) npc.StartActivity(iActivity);
		KillFeed_SetKillIcon(npc.index, "bomb");
		
		npc.m_flNextMeleeAttack = 0.0;
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_NORMAL;
		npc.m_iNpcStepVariation = STEPSOUND_NORMAL;		
		npc.m_flSpeed = 500.0;
		
		SDKHook(npc.index, SDKHook_Think, BeheadedKamiKaze_ClotThink);
		
		npc.m_bDoSpawnGesture = true;
		
		for(int client_clear=1; client_clear<=MaxClients; client_clear++)
		{
			fl_AlreadyStrippedMusic[client_clear] = 0.0; //reset to 0
		}

		npc.m_iState = 0;
		npc.m_flNextRangedAttack = 0.0;
		npc.m_flNextRangedSpecialAttack = 0.0;
		npc.m_flNextMeleeAttack = 0.0;
		npc.m_flAttackHappenswillhappen = false;
		npc.m_fbRangedSpecialOn = false;
		
		float wave = float(ZR_GetWaveCount()+1); //Wave scaling
		
		wave *= 0.1;

		npc.m_flWaveScale = wave;

		if(!ally)
		{
			if(fl_KamikazeInitiate < GetGameTime())
			{
				//This is a kamikaze that was newly initiated!
				//add new kamikazies whenever possible.
				//this needs to happen every tick!
				DoGlobalMultiScaling();
				float SpawnRate = 0.5;
				fl_KamikazeSpawnRateDelay = 0.0;
				SpawnRate /= MultiGlobal;
				DataPack pack = new DataPack();
				pack.WriteFloat(SpawnRate);
				pack.WriteFloat(GetGameTime() + 10.0); //they took too long to kill that one. Spawn more regardless.
				pack.WriteCell(EntIndexToEntRef(npc.index));
				RequestFrame(SpawnBeheadedKamikaze, pack);
				b_KamikazeEvent = true;
			}

			fl_KamikazeInitiate = GetGameTime() + 15.0;

			npc.m_bDissapearOnDeath = true;
			if(!TeleportDiversioToRandLocation(npc.index,_,1750.0, 1250.0))
			{
				//incase their random spawn code fails, they'll spawn here.
				int Spawner_entity = GetRandomActiveSpawner();
				if(IsValidEntity(Spawner_entity))
				{
					float pos[3];
					float ang[3];
					GetEntPropVector(Spawner_entity, Prop_Data, "m_vecOrigin", pos);
					GetEntPropVector(Spawner_entity, Prop_Data, "m_angRotation", ang);
					TeleportEntity(npc.index, pos, ang, NULL_VECTOR);
				}
			}
					
		}

		npc.PlaySpawnSound();
		float pos[3]; pos = WorldSpaceCenter(npc.index);
		pos[2] -= 10.0;
		TE_Particle("teleported_blue", pos, NULL_VECTOR, NULL_VECTOR, _, _, _, _, _, _, _, _, _, _, 0.0);
		
		npc.StartPathing();
		
		return npc;
	}
	
	
}

//TODO 
//Rewrite
public void BeheadedKamiKaze_ClotThink(int iNPC)
{
	BeheadedKamiKaze npc = view_as<BeheadedKamiKaze>(iNPC);
	npc.PlayIdleAlertSound();
	
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

	if(npc.m_flGetClosestTargetTime < GetGameTime(npc.index))
	{
		for(int client=1; client<=MaxClients; client++)
		{
			if(IsClientInGame(client))
			{
				if(fl_AlreadyStrippedMusic[client] < GetEngineTime())
				{
					Music_Stop_All(client); //This is actually more expensive then i thought.
				}
				SetMusicTimer(client, GetTime() + 10);
				fl_AlreadyStrippedMusic[client] = GetEngineTime() + 10.0;
			}
		}
		npc.m_iTarget = GetClosestTarget(npc.index, true);
		npc.m_flGetClosestTargetTime = GetGameTime(npc.index) + GetRandomRetargetTime();
	}
	
	if(IsValidEnemy(npc.index, npc.m_iTarget))
	{
		npc.StartPathing();
		float vecTarget[3]; vecTarget = WorldSpaceCenter(npc.m_iTarget);
		
	
		float flDistanceToTarget = GetVectorDistance(vecTarget, WorldSpaceCenter(npc.index), true);
		
		if(flDistanceToTarget < npc.GetLeadRadius()) 
		{
			float vPredictedPos[3];
			vPredictedPos = PredictSubjectPosition(npc, npc.m_iTarget);
			NPC_SetGoalVector(npc.index, vPredictedPos);
		}
		else 
		{
			NPC_SetGoalEntity(npc.index, npc.m_iTarget);
		}
		
		//Target close enough to hit
		if(flDistanceToTarget < 9025.0 && !npc.m_flAttackHappenswillhappen)
		{
			Kamikaze_DeathExplosion(npc.index);
		}
	}
	else
	{
		NPC_StopPathing(npc.index);
		npc.m_bPathing = false;
		npc.m_flGetClosestTargetTime = 0.0;
		npc.m_iTarget = GetClosestTarget(npc.index);
	}
}

public Action BeheadedKamiKaze_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	//Valid attackers only.
	if(attacker <= 0)
		return Plugin_Continue;
		
		
		
	BeheadedKamiKaze npc = view_as<BeheadedKamiKaze>(victim);
	
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	return Plugin_Changed;
}

public void BeheadedKamiKaze_NPCDeath(int entity)
{
	BeheadedKamiKaze npc = view_as<BeheadedKamiKaze>(entity);
	
	SDKUnhook(npc.index, SDKHook_Think, BeheadedKamiKaze_ClotThink);
	StopSound(npc.index, SNDCHAN_VOICE, "zombie_riot/miniboss/kamikaze/become_enraged56.wav");
	Kamikaze_DeathExplosion(entity);
}


void Kamikaze_DeathExplosion(int entity)
{
	BeheadedKamiKaze npc = view_as<BeheadedKamiKaze>(entity);
	if(npc.m_flAttackHappenswillhappen)
	{
		return;
	}
	npc.m_flAttackHappenswillhappen = true;
	//change team to one that isnt existant.
	float startPosition[3];
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", startPosition); 
	startPosition[2] += 45.0;
	DataPack pack_boom = new DataPack();
	pack_boom.WriteFloat(startPosition[0]);
	pack_boom.WriteFloat(startPosition[1]);
	pack_boom.WriteFloat(startPosition[2]);
	pack_boom.WriteCell(1);
	RequestFrame(MakeExplosionFrameLaterKami, pack_boom);

	int TeamNum = GetEntProp(npc.index, Prop_Send, "m_iTeamNum");
	SetEntProp(npc.index, Prop_Send, "m_iTeamNum", 4);
	Explode_Logic_Custom(60.0 * npc.m_flWaveScale,
	npc.index,
	npc.index,
	-1,
	_,
	150.0,
	_,
	_,
	true,
	99,
	false,
	5.0,
	_,
	BeheadedKamiBoomInternal);
	SetEntProp(npc.index, Prop_Send, "m_iTeamNum", TeamNum);
	SmiteNpcToDeath(entity);
	/*

CTFPlayer::ChangeTeam( 4 ) - invalid team index.
CTFPlayer::ChangeTeam( 4 ) - invalid team index.
CTFPlayer::ChangeTeam( 4 ) - invalid team index.
??
	*/
}

float BeheadedKamiBoomInternal(int entity, int victim, float damage, int weapon)
{
	if(entity == victim)
		return 0.0;

	//instakill any be_headeads.
	if(i_NpcInternalId[victim] == MINI_BEHEADED_KAMI)
	{
		return 1000000000.0;
	}
	return damage;
}

void SpawnBeheadedKamikaze(DataPack pack)
{
	if(Waves_InSetup())
	{
		delete pack;
		return;
	}

	ResetPack(pack);
	float spawndelay = ReadPackFloat(pack);
	float ForceSpawn_Moretime = ReadPackFloat(pack);
	int FirstKamiKaze = EntRefToEntIndex(ReadPackCell(pack));

	bool InitiateSpawns = false;

	if(ForceSpawn_Moretime < GetGameTime())
		InitiateSpawns = true;

	if(!IsValidEntity(FirstKamiKaze))
	{
		InitiateSpawns = true;
	}
	else
	{
		if(b_NpcHasDied[FirstKamiKaze])
			InitiateSpawns = true;
	}

	if(!InitiateSpawns)
	{
		RequestFrame(SpawnBeheadedKamikaze, pack);
		return;
	}

	//This now means we initiate spawns!
	if(fl_KamikazeSpawnDuration == 0.0)
	{
		for(int client=1; client<=MaxClients; client++)
		{
			if(IsClientInGame(client))
			{
				if(IsValidClient(client))
				{
					EmitCustomToClient(client, "#zombie_riot/miniboss/kamikaze/sam_rush_2.mp3", client, SNDCHAN_AUTO, 90, _, 1.0);
				}
			}
		}
		fl_KamikazeSpawnDelay = GetGameTime() + 5.0;
		fl_KamikazeSpawnDuration = GetGameTime() + 18.0 + 5.0;
	}

	//can we still spawn
	if(fl_KamikazeSpawnDuration > GetGameTime())
	{
		if(fl_KamikazeSpawnDelay > GetGameTime())
		{
			RequestFrame(SpawnBeheadedKamikaze, pack);
			return;
		}
		if(fl_KamikazeSpawnRateDelay > GetGameTime())
		{
			RequestFrame(SpawnBeheadedKamikaze, pack);
			return;
		}
		fl_KamikazeSpawnRateDelay = GetGameTime() + spawndelay;
		int Kamikazies = 0;
		for(int entitycount; entitycount<i_MaxcountNpc; entitycount++)
		{
			int INpc = EntRefToEntIndex(i_ObjectsNpcs[entitycount]);
			if (IsValidEntity(INpc))
			{
				if(!b_NpcHasDied[INpc] && i_NpcInternalId[INpc] == MINI_BEHEADED_KAMI)
				{
					Kamikazies += 1;
				}
			}
		}
		if(Kamikazies < (MaxEnemiesAllowedSpawnNext()))
		{
			//spawn a kamikaze here!
			int Spawner_entity = GetRandomActiveSpawner();
			float pos[3];
			float ang[3];
			if(IsValidEntity(Spawner_entity))
			{
				GetEntPropVector(Spawner_entity, Prop_Data, "m_vecOrigin", pos);
				GetEntPropVector(Spawner_entity, Prop_Data, "m_angRotation", ang);
			}
			Zombies_Currently_Still_Ongoing += 1;
			Npc_Create(MINI_BEHEADED_KAMI, -1, pos, ang, false); //can only be enemy
		}
		RequestFrame(SpawnBeheadedKamikaze, pack);
		return;
	}
	//its over, no more spawning.
	b_KamikazeEvent = false;
	fl_KamikazeSpawnDuration = 0.0;
	delete pack;
}

bool KamikazeEventHappening()
{
	return b_KamikazeEvent;
}

public void MakeExplosionFrameLaterKami(DataPack pack)
{
	pack.Reset();
	float vec_pos[3];
	vec_pos[0] = pack.ReadFloat();
	vec_pos[1] = pack.ReadFloat();
	vec_pos[2] = pack.ReadFloat();
	int Do_Sound = pack.ReadCell();
	
	if(Do_Sound == 1)
	{		
		EmitAmbientSound("ambient/explosions/explode_3.wav", vec_pos, _, 75, _,0.7, GetRandomInt(75, 110));
	}
	SpawnSmallExplosionNotRandom(vec_pos);
	delete pack;
}