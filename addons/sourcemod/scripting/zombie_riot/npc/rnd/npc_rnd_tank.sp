#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] = {
	"mvm/mvm_tank_smash.wav",
	"mvm/mvm_tank_explode.wav",
};

static const char g_SpawnSounds[][] = {
	"mvm/mvm_tele_deliver.wav",
};

static const char g_StartSounds[][] = {
	"mvm/mvm_tank_start.wav",
	"mvm/mvm_tank_end.wav",
};

static const char g_IdleSounds[][] = {
	"mvm/mvm_tank_horn.wav",
};

static const char g_DeploySounds[][] = {
	"mvm/mvm_tank_deploy.wav",
};

static const char g_ExplodeSounds[][] = {
	"mvm/mvm_bomb_explode.wav",
};

static const char g_WarningSounds[][] = {
	"mvm/mvm_bomb_warning.wav",
};

static int RND_TANK_SHELTER[MAXENTITIES];
static float RND_TANK_NEXT_WARNING[MAXENTITIES];
static float RND_TANK_NEXT_SUMMON[MAXENTITIES];
//static float RND_TANK_NEXT_SUMMON_EXPLOIT[MAXENTITIES];
static float RND_TANK_NEXT_SUMMON_DAMAGED[MAXENTITIES];

void RND_Tank_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));	   i++) { PrecacheSound(g_DeathSounds[i]);	   }
	for (int i = 0; i < (sizeof(g_SpawnSounds));		i++) { PrecacheSound(g_SpawnSounds[i]);		}
	for (int i = 0; i < (sizeof(g_IdleSounds));		i++) { PrecacheSound(g_IdleSounds[i]);		}
	for (int i = 0; i < (sizeof(g_DeploySounds)); i++) { PrecacheSound(g_DeploySounds[i]); }
	for (int i = 0; i < (sizeof(g_StartSounds));	i++) { PrecacheSound(g_StartSounds[i]);	}
	for (int i = 0; i < (sizeof(g_ExplodeSounds));	i++) { PrecacheSound(g_ExplodeSounds[i]);	}
	for (int i = 0; i < (sizeof(g_WarningSounds));	i++) { PrecacheSound(g_WarningSounds[i]);	}
	
	PrecacheModel("models/bots/boss_bot/boss_tank.mdl");
	PrecacheModel("models/bots/boss_bot/tank_track_l.mdl");
	PrecacheModel("models/bots/boss_bot/tank_track_r.mdl");
	PrecacheModel("models/bots/boss_bot/bomb_mechanism.mdl");
	PrecacheModel("models/props_mvm/mann_hatch.mdl");
	
}

methodmap RND_Tank < CClotBody
{
	property int m_iShelterEnt
	{
		public get()							{ return RND_TANK_SHELTER[this.index]; }
		public set(int TempValueForProperty) 	{ RND_TANK_SHELTER[this.index] = TempValueForProperty; }
	}
	
	property float m_fNextWarning
	{
		public get()							{ return RND_TANK_NEXT_WARNING[this.index]; }
		public set(float TempValueForProperty) 	{ RND_TANK_NEXT_WARNING[this.index] = TempValueForProperty; }
	}
	
	property float m_fNextSummonS
	{
		public get()							{ return RND_TANK_NEXT_SUMMON[this.index]; }
		public set(float TempValueForProperty) 	{ RND_TANK_NEXT_SUMMON[this.index] = TempValueForProperty; }
	}
	/*
	property float m_fNextSummonExploit
	{
		public get()							{ return RND_TANK_NEXT_SUMMON_EXPLOIT[this.index]; }
		public set(float TempValueForProperty) 	{ RND_TANK_NEXT_SUMMON_EXPLOIT[this.index] = TempValueForProperty; }
	}
	*/
	
	property float m_fNextSummonDamaged
	{
		public get()							{ return RND_TANK_NEXT_SUMMON_DAMAGED[this.index]; }
		public set(float TempValueForProperty) 	{ RND_TANK_NEXT_SUMMON_DAMAGED[this.index] = TempValueForProperty; }
	}
	
	public void PlayIdleSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		EmitSoundToAll(g_IdleSounds[GetRandomInt(0, sizeof(g_IdleSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(8.0, 10.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleSound()");
		#endif
	}
	
	public void PlayStartSound() {
	
		EmitSoundToAll(g_StartSounds[GetRandomInt(0, sizeof(g_StartSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayStartSound()");
		#endif
	}
	
	public void PlayDeathSound() {
	
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayDeathSound()");
		#endif
	}
	
	public void PlayWarningSound() {
	
		if(this.m_fNextWarning > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_WarningSounds[GetRandomInt(0, sizeof(g_WarningSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		this.m_fNextWarning = GetGameTime(this.index) + 2.0;
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayWarningSound()");
		#endif
	}
	
	public void PlayExplodeSound() {
	
		EmitSoundToAll(g_ExplodeSounds[GetRandomInt(0, sizeof(g_ExplodeSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayExplodeSound()");
		#endif
	}
	
	public void PlayDeploySound() {
	
		this.m_flNextIdleSound = GetGameTime(this.index) + 2100.0;
		this.m_fNextWarning = GetGameTime(this.index) + 2100.0;
		
		for (int i = 0; i < (sizeof(g_IdleSounds)); i++) { StopSound(this.index, SNDCHAN_VOICE, g_IdleSounds[i]); }
		for (int i = 0; i < (sizeof(g_WarningSounds)); i++) { StopSound(this.index, SNDCHAN_VOICE, g_WarningSounds[i]); }
		
		EmitSoundToAll(g_DeploySounds[GetRandomInt(0, sizeof(g_DeploySounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayDeploySound()");
		#endif
	}
	
	public void PlaySpawnSound() {
	
		EmitSoundToAll(g_SpawnSounds[GetRandomInt(0, sizeof(g_SpawnSounds) - 1)], this.index, SNDCHAN_VOICE, BOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlaySpawnSound()");
		#endif
	}
	
	public RND_Tank(int client, float vecPos[3], float vecAng[3], bool ally)
	{
		RND_Tank npc = view_as<RND_Tank>(CClotBody(vecPos, vecAng, "models/bots/boss_bot/boss_tank.mdl", "0.5", "5000", ally));
		
		i_NpcInternalId[npc.index] = RND_TANK;
		
		npc.AddActivityViaSequence("movement");
		
		npc.m_iBleedType = BLEEDTYPE_METAL;
		
		npc.m_iWearable1 = npc.EquipItem("smoke_attachment", "models/bots/boss_bot/tank_track_l.mdl", "forward");
		SetVariantString("0.5");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		npc.m_iWearable2 = npc.EquipItem("smoke_attachment", "models/bots/boss_bot/tank_track_r.mdl", "forward");
		SetVariantString("0.5");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		
		npc.m_iWearable3 = npc.EquipItem("smoke_attachment", "models/bots/boss_bot/bomb_mechanism.mdl");
		SetVariantString("0.5");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		
		SDKHook(npc.index, SDKHook_OnTakeDamage, RND_Tank_ClotDamaged);
		SDKHook(npc.index, SDKHook_Think, RND_Tank_ClotThink);
		SDKHook(npc.index, SDKHook_StartTouch, Event_OnTankTouch);
		
		npc.Anger = false;
		npc.m_bDissapearOnDeath = true;
		npc.m_flSpeed = 100.0;
		//IDLE
		npc.m_iState = 0;
		
		npc.m_fNextSummonS = GetGameTime(npc.index) + GetRandomFloat(10.0, 20.0);
		npc.m_fNextSummonDamaged = GetGameTime(npc.index) + GetRandomFloat(7.0, 12.0);
		/*
		npc.m_flGetClosestTargetTime = 0.0;
		npc.StartPathing();
		*/
		
		//TODO: make a spawn for each map
		
		npc.m_iShelterEnt = EntIndexToEntRef(getFarestPositionForEachMap(npc.index));
		
		float shelterPos[3];
		GetEntPropVector(EntRefToEntIndex(npc.m_iShelterEnt), Prop_Data, "m_vecAbsOrigin", shelterPos);
		PF_SetGoalVector(npc.index, shelterPos);
		PF_StartPathing(npc.index);
		
		npc.m_flNextIdleSound = GetGameTime(npc.index) + 8.0;
		npc.PlayStartSound();
		
		return npc;
	}
	
	
}

public Action Event_OnTankTouch(int entity, int other)
{
	if (IsValidClient(other))
	{
		RND_Tank npc = view_as<RND_Tank>(entity);
		
		Handle swingTrace;
		if(npc.DoSwingTrace(swingTrace, other))
		{
			/*
			npc.PlaySpawnSound();
			
			float pos[3]; GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", pos);
			float ang[3]; GetEntPropVector(npc.index, Prop_Data, "m_angRotation", ang);
			for (int c = 0; c <= 10; c++)
			{
				Npc_Create(GetRandomInt(ALT_MECHA_ENGINEER, ALT_MECHA_SCOUT), -1, pos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
				Zombies_Currently_Still_Ongoing += 1;
			}
			*/
			
			Custom_Knockback(npc.index, other, 1500.0, true);
			TF2_AddCondition(other, TFCond_LostFooting, 0.5);
			TF2_AddCondition(other, TFCond_AirCurrent, 0.5);
		}
	}
	return Plugin_Continue;
}


//Rewrite
public void RND_Tank_ClotThink(int iNPC)
{
	RND_Tank npc = view_as<RND_Tank>(iNPC);
	
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
	
	/*
	if (npc.m_fNextSummonS<=GetGameTime(npc.index))
	{
		npc.PlaySpawnSound();
		npc.m_fNextSummonS = GetGameTime(npc.index) + GetRandomFloat(10.0, 20.0);
		
		float pos[3]; GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", pos);
		float ang[3]; GetEntPropVector(npc.index, Prop_Data, "m_angRotation", ang);
		for (int c = 0; c <= 10; c++)
		{
			Npc_Create(GetRandomInt(ALT_MECHA_ENGINEER, ALT_MECHA_SCOUT), -1, pos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
			Zombies_Currently_Still_Ongoing += 1;
		}
	}
	*/

	float shelterPos[3];
	GetEntPropVector(EntRefToEntIndex(npc.m_iShelterEnt), Prop_Data, "m_vecAbsOrigin", shelterPos);
	
	float npcPos[3];
	GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", npcPos);
	float distance = GetVectorDistance(shelterPos, npcPos, true);
	
	if (distance<=250000.0)
	{
		npc.PlayWarningSound();
	}
	
	if (distance<=10000.0 && !npc.Anger)
	{
		PF_StopPathing(npc.index);
		npc.AddActivityViaSequence("deploy");
		npc.Anger = true;
		
		
		if(IsValidEntity(npc.m_iWearable1))
			RemoveEntity(npc.m_iWearable1);
			
		if(IsValidEntity(npc.m_iWearable2))
			RemoveEntity(npc.m_iWearable2);
		
		if(IsValidEntity(npc.m_iWearable3))
			RemoveEntity(npc.m_iWearable3);
		
		npc.m_iWearable1 = npc.EquipItem("smoke_attachment", "models/bots/boss_bot/tank_track_l.mdl");
		SetVariantString("0.5");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		npc.m_iWearable2 = npc.EquipItem("smoke_attachment", "models/bots/boss_bot/tank_track_r.mdl");
		SetVariantString("0.5");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
			
		npc.m_iWearable3 = npc.EquipItem("smoke_attachment", "models/bots/boss_bot/bomb_mechanism.mdl", "deploy");
		SetVariantString("0.5");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		
		npc.PlayDeploySound();
		
		CreateTimer(7.5, TIMER_Explode_And_Spawn, EntIndexToEntRef(npc.index), TIMER_FLAG_NO_MAPCHANGE);
	}
	npc.PlayIdleSound();
}

public Action TIMER_Explode_And_Spawn(Handle timer, int entref)
{
	int iNPC = EntRefToEntIndex(entref);
	
	if (!IsValidEntity(iNPC))
		return Plugin_Continue;
	
	RND_Tank npc = view_as<RND_Tank>(iNPC);
	npc.PlayExplodeSound();
	
	SpawnNpcByCalcShitForTank(npc); // I hate maths, but just for balancing, overall I love them
	
	float shelterPos[3];
	GetEntPropVector(EntRefToEntIndex(npc.m_iShelterEnt), Prop_Data, "m_vecAbsOrigin", shelterPos);
	CreateParticle("fluidSmokeExpl_ring_mvm", shelterPos, view_as<float>({0.0, 0.0, 0.0}));
	
	SDKHooks_TakeDamage(npc.index, 0, 0, 99999.0, DMG_CLUB, -1);
	
	return Plugin_Continue;
}

public void SpawnNpcByCalcShitForTank(RND_Tank npc)
{
	float pos[3]; GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", pos);
	float ang[3]; GetEntPropVector(npc.index, Prop_Data, "m_angRotation", ang);
	
	for (int c = 0; c < 25; c++)
	{
		float rpos[3];
		rpos[0] = pos[0] + GetRandomFloat(-50.0, 50.0);
		rpos[1] = pos[1] + GetRandomFloat(-50.0, 50.0);
		rpos[2] = pos[2];
		
		int spawn_index = Npc_Create(RND_MINI_TOCKSICK, -1, rpos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
		Zombies_Currently_Still_Ongoing += 1;
		if(spawn_index > MaxClients)	//Currently always spawns.
		{
			SetEntProp(spawn_index, Prop_Data, "m_iHealth", 2000);
			SetEntProp(spawn_index, Prop_Data, "m_iMaxHealth", 2000);
		}
	}
}

public Action RND_Tank_ClotDamaged(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	RND_Tank npc = view_as<RND_Tank>(victim);
		
	if(attacker <= 0)
		return Plugin_Continue;
		
	if (npc.m_fNextSummonDamaged<=GetGameTime(npc.index))
	{
		npc.PlaySpawnSound();
		npc.m_fNextSummonDamaged = GetGameTime(npc.index) + GetRandomFloat(5.0, 10.0);
		
		float pos[3]; GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", pos);
		float ang[3]; GetEntPropVector(npc.index, Prop_Data, "m_angRotation", ang);
		for (int c = 0; c <= 10; c++)
		{
			Npc_Create(GetRandomInt(ALT_MECHA_ENGINEER, ALT_MECHA_SCOUT), -1, pos, ang, GetEntProp(npc.index, Prop_Send, "m_iTeamNum") == 2);
			Zombies_Currently_Still_Ongoing += 1;
		}
	}
	
	return Plugin_Changed;
}

public void RND_Tank_NPCDeath(int entity)
{
	RND_Tank npc = view_as<RND_Tank>(entity);
	if(!npc.m_bGib)
	{
		npc.PlayDeathSound();	
	}
	
	SDKUnhook(npc.index, SDKHook_OnTakeDamage, RND_Tank_ClotDamaged);
	SDKUnhook(npc.index, SDKHook_Think, RND_Tank_ClotThink);
	SDKUnhook(npc.index, SDKHook_StartTouch, Event_OnTankTouch);	
		
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);
		
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
		
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
		
	if(IsValidEntity(EntRefToEntIndex(npc.m_iShelterEnt)))
		RemoveEntity(EntRefToEntIndex(npc.m_iShelterEnt));
		
	
}

stock int getFarestPositionForEachMap(int entity) {
	char mapName[124];
	GetCurrentMap(mapName, 124);
	
	
	float lastPos[3];
	float entPos[3];
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
	
	if (StrContains(mapName, "evil_pumpkin_farm")!=-1)
	{
		float farestPos[3];
		farestPos = { 4900.0, -4250.0, 35.0};
		float farestDistance = GetVectorDistance(entPos, farestPos, true);
		
		float otherPos[3];
		otherPos = { 3580.0, -2800.0, 440.0};
		
		if (GetVectorDistance(entPos, otherPos, true)>farestDistance)
		{
			farestPos = otherPos;
			farestDistance = GetVectorDistance(entPos, otherPos, true);
		}
		
		otherPos = { 2200.0, -3700.0, 35.0};
		if (GetVectorDistance(entPos, otherPos, true)>farestDistance)
		{
			farestPos = otherPos;
			farestDistance = GetVectorDistance(entPos, otherPos, true);
		}
		
		lastPos = farestPos;
	}
	
	int item = CreateEntityByName("prop_physics_multiplayer");
	DispatchKeyValue(item, "model", "models/props_mvm/mann_hatch.mdl");

	DispatchSpawn(item);
	SetEntityMoveType(item, MOVETYPE_NONE);
	
	SetEntityCollisionGroup(item, 1);
	TeleportEntity(item, lastPos, NULL_VECTOR, NULL_VECTOR);
	
	return item;
}


bool CloneWeapon(Weapon newWeapon)
{
	char Classname[64];
	strcopy(newWeapon.Classname, 64, this.Classname);
	
	newWeapon.AttributeNumber = this.AttributeNumber;
	for(int c=0 ; c < this.AttributeNumber ; c++)
    {
    	newWeapon.AttributesIdx[c] = this.AttributesIdx[c];
    	newWeapon.AttributeValue[c] = this.AttributeValue[c];
    }
    
    newWeapon.Index = this.Index;
    newWeapon.Quality = this.Quality;
    newWeapon.Level = this.Level;
    
    
    newWeapon.Ammo = this.Ammo;
    newWeapon.clip = this.Clip;
	return true;
}