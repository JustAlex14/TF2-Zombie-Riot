#pragma semicolon 1
#pragma newdecls required

#define QUEUE_TIME	90.0

enum struct ModEnum
{
	char Desc[128];
	int Tier;
	int Unlock;
	int Slot;

	Function OnSpawn;
	Function OnWaves;

	void SetupEnum(KeyValues kv)
	{
		kv.GetString("func_onspawn", this.Desc, 128);
		this.OnSpawn = GetFunctionByName(null, this.Desc);

		kv.GetString("func_onwaves", this.Desc, 128);
		this.OnWaves = GetFunctionByName(null, this.Desc);

		kv.GetString("desc", this.Desc, 128);
		this.Tier = kv.GetNum("tier");
		this.Unlock = kv.GetNum("unlock");
		this.Slot = kv.GetNum("slot");
	}

	void CallOnSpawn(int entity)
	{
		if(this.OnSpawn != INVALID_FUNCTION)
		{
			Call_StartFunction(null, this.OnSpawn);
			Call_PushCell(entity);
			Call_Finish();
		}
	}

	void CallOnWaves(ArrayList list)
	{
		if(this.OnSpawn != INVALID_FUNCTION)
		{
			Call_StartFunction(null, this.OnSpawn);
			Call_PushCell(list);
			Call_Finish();
		}
	}
}

enum struct WaveEnum
{
	float Delay;
	int Index;
	float Pos[3];
	float Angle;

	bool Boss;
	int Level;
	int Health;

	void SetupEnum(KeyValues kv, char[] buffer, int length)
	{
		kv.GetSectionName(buffer, length);
		this.Delay = StringToFloat(buffer);

		kv.GetString("name", buffer, length);
		this.Index = StringToInt(buffer);
		if(!this.Index)
			this.Index = GetIndexByPluginName(buffer);

		kv.GetVector("pos", this.Pos);
		this.Angle = kv.GetFloat("angle", -1.0);
		this.Boss = view_as<bool>(kv.GetNum("boss"));
		this.Level = kv.GetNum("level");
		this.Health = kv.GetNum("health");
	}
}

enum struct StageEnum
{
	float StartPos[3];
	int XP;
	int Cash;

	char DropName1[48];
	float DropChance1;
	int DropTier1;

	char DropName2[48];
	float DropChance2;
	int DropTier2;

	char DropName3[48];
	float DropChance3;
	int DropTier3;

	char DropName4[48];
	float DropChance4;
	int DropTier4;

	char MusicEasy[PLATFORM_MAX_PATH];
	int MusicEasyTime;
	float MusicEasyVolume;

	int MusicTier;
	char MusicHard[PLATFORM_MAX_PATH];
	int MusicHardTime;
	float MusicHardVolume;

	StringMap ModList;
	ArrayList WaveList;

	void Delete()
	{
		delete this.ModList;
		delete this.WaveList;
	}

	void SetupEnum(KeyValues kv, char[] buffer, int length)
	{
		kv.GetVector("pos", this.StartPos);
		this.XP = kv.GetNum("xp");
		this.Cash = kv.GetNum("cash");

		kv.GetString("drop_name_1", this.DropName1, 48);
		this.DropChance1 = kv.GetFloat("drop_chance_1", 1.0);
		this.DropTier1 = kv.GetNum("drop_tier_1");

		kv.GetString("drop_name_2", this.DropName2, 48);
		this.DropChance2 = kv.GetFloat("drop_chance_2", 1.0);
		this.DropTier2 = kv.GetNum("drop_tier_2");

		kv.GetString("drop_name_3", this.DropName3, 48);
		this.DropChance3 = kv.GetFloat("drop_chance_3", 1.0);
		this.DropTier3 = kv.GetNum("drop_tier_3");

		kv.GetString("drop_name_4", this.DropName4, 48);
		this.DropChance4 = kv.GetFloat("drop_chance_4", 1.0);
		this.DropTier4 = kv.GetNum("drop_tier_4");

		kv.GetString("music_easy_file", this.MusicEasy, PLATFORM_MAX_PATH);
		if(this.MusicEasy[0])
			PrecacheSound(this.MusicEasy);
		
		this.MusicEasyTime = kv.GetNum("music_easy_duration");
		this.MusicEasyVolume = kv.GetFloat("music_easy_volume", 1.0);
		
		if(kv.GetNum("music_easy_download"))
		{
			Format(buffer, length, "sound/%s", this.MusicEasy);
			ReplaceString(buffer, length, "#", "");
			if(FileExists(buffer, true))
			{
				AddFileToDownloadsTable(buffer);
			}
			else
			{
				LogError("'%s' is missing from files", buffer);
			}
		}

		kv.GetString("music_hard_file", this.MusicHard, PLATFORM_MAX_PATH);
		if(this.MusicHard[0])
			PrecacheSound(this.MusicHard);
		
		this.MusicHardTime = kv.GetNum("music_hard_duration");
		this.MusicHardVolume = kv.GetFloat("music_hard_volume", 1.0);
		this.MusicTier = kv.GetNum("music_hard_cap", 99999);
		
		if(kv.GetNum("download"))
		{
			Format(buffer, length, "sound/%s", this.MusicHard);
			ReplaceString(buffer, length, "#", "");
			if(FileExists(buffer, true))
			{
				AddFileToDownloadsTable(buffer);
			}
			else
			{
				LogError("'%s' is missing from files", buffer);
			}
		}

		if(kv.JumpToKey("Mods"))
		{
			if(kv.GotoFirstSubKey())
			{
				ModEnum mod;
				this.ModList = new StringMap();

				do
				{
					kv.GetSectionName(buffer, length);
					mod.SetupEnum(kv);
					this.ModList.SetArray(buffer, mod, sizeof(mod));
				}
				while(kv.GotoNextKey());

				kv.GoBack();
			}

			kv.GoBack();
		}
		else
		{
			this.ModList = null;
		}

		WaveEnum wave;
		this.WaveList = new ArrayList(sizeof(WaveEnum));

		if(kv.JumpToKey("Waves"))
		{
			if(kv.GotoFirstSubKey())
			{
				do
				{
					wave.SetupEnum(kv, buffer, length);
					this.WaveList.PushArray(wave);
				}
				while(kv.GotoNextKey());

				kv.GoBack();
			}

			kv.GoBack();
		}
	}
}

enum struct DungeonEnum
{
	char Model[PLATFORM_MAX_PATH];
	char Idle[64];
	float Pos[3];
	float Ang[3];
	float Scale;
	
	char Wear1[PLATFORM_MAX_PATH];
	char Wear2[PLATFORM_MAX_PATH];
	char Wear3[PLATFORM_MAX_PATH];

	float RespawnPos[3];
	
	int EntRef;

	StringMap StageList;

	ArrayList ModList;
	ArrayList WaveList;
	char CurrentStage[64];
	float StartTime;
	int PlayerCount;
	int CurrentHost;

	int TierLevel()
	{
		int tier;
		if(ModList && this.CurrentStage[0])
		{
			static StageEnum stage;
			if(StageList.GetArray(this.CurrentStage, stage, sizeof(stage)))
			{
				int length = ModList.Length;
				for(int i; i < length; i++)
				{
					static ModEnum mod;
					ModList.GetString(i, mod.MusicEasy, sizeof(mod.MusicEasy));
					if(stage.ModList.GetArray(mod.MusicEasy, mod, sizeof(mod)))
						tier += mod.Tier;
				}
			}
		}
		return tier;
	}

	void Delete()
	{
		delete this.ModList;
		delete this.WaveList;

		StageEnum stage;
		StringMapSnapshot snap = this.StageList.Snapshot();
		int length = snap.Length;
		for(int i; i < length; i++)
		{
			int size = snap.KeyBufferSize(i) + 1;
			char[] name = new char[size];
			this.StageList.GetArray(name, stage, sizeof(stage));
			stage.Delete();
		}

		delete snap;
		delete this.StageList;
	}
	
	void SetupEnum(KeyValues kv, char[] buffer, int length)
	{
		kv.GetString("model", this.Model, PLATFORM_MAX_PATH);
		if(!this.Model[0])
			SetFailState("Missing model in dungeon.cfg");
		
		this.Scale = kv.GetFloat("scale", 1.0);
		
		kv.GetString("anim_idle", this.Idle, 64);
		
		kv.GetVector("pos", this.Pos);
		kv.GetVector("ang", this.Ang);
		
		kv.GetString("wear1", this.Wear1, PLATFORM_MAX_PATH);
		if(this.Wear1[0])
			PrecacheModel(this.Wear1);
		
		kv.GetString("wear2", this.Wear2, PLATFORM_MAX_PATH);
		if(this.Wear2[0])
			PrecacheModel(this.Wear2);
		
		kv.GetString("wear3", this.Wear3, PLATFORM_MAX_PATH);
		if(this.Wear3[0])
			PrecacheModel(this.Wear3);
		
		kv.GetVector("deathpos", this.RespawnPos);

		StageEnum stage;
		this.StageList = new StringMap();

		if(kv.GotoFirstSubKey())
		{
			do
			{
				stage.SetupEnum(kv, buffer, length);
				kv.GetSectionName(buffer, length);
				this.StageList.SetArray(buffer, stage, sizeof(stage));
			}
			while(kv.GotoNextKey());

			kv.GoBack();
		}
	}
	
	void Despawn()
	{
		if(this.EntRef != INVALID_ENT_REFERENCE)
		{
			int entity = EntRefToEntIndex(this.EntRef);

			int brush = EntRefToEntIndex(b_OwnerToBrush[entity]);
			if(IsValidEntity(brush))
			{
				RemoveEntity(brush);
			}

			if(entity != -1)
				RemoveEntity(entity);
			
			this.EntRef = INVALID_ENT_REFERENCE;
		}
	}
	
	void Spawn()
	{
		if(EntRefToEntIndex(this.EntRef) == INVALID_ENT_REFERENCE)
		{
			int entity = CreateEntityByName("prop_dynamic_override");
			if(IsValidEntity(entity))
			{
				DispatchKeyValue(entity, "targetname", "rpg_fortress");
				DispatchKeyValue(entity, "model", this.Model);
				
				
				TeleportEntity(entity, this.Pos, this.Ang, NULL_VECTOR);
				
				DispatchSpawn(entity);
				SetEntityCollisionGroup(entity, 2);

				int brush = SpawnSeperateCollisionBox(entity);
				//Just reuse it.
				b_BrushToOwner[brush] = EntIndexToEntRef(entity);
				b_OwnerToBrush[entity] = EntIndexToEntRef(brush);
				
				if(this.Wear1[0])
					GivePropAttachment(entity, this.Wear1);
				
				if(this.Wear2[0])
					GivePropAttachment(entity, this.Wear2);
				
				if(this.Wear3[0])
					GivePropAttachment(entity, this.Wear3);
				
				SetEntPropFloat(entity, Prop_Send, "m_flModelScale", this.Scale);
				
				SetVariantString(this.Idle);
				AcceptEntityInput(entity, "SetDefaultAnimation", entity, entity);
				
				SetVariantString(this.Idle);
				AcceptEntityInput(entity, "SetAnimation", entity, entity);
				
				this.EntRef = EntIndexToEntRef(entity);
			}
		}
	}
}

static ConVar mp_disable_respawn_times;
static StringMap DungeonList;
static char DungeonMenu[MAXTF2PLAYERS][64];
static bool AltMenu[MAXTF2PLAYERS];
static char InDungeon[MAXENTITIES][64];

void Dungeon_PluginStart()
{
	mp_disable_respawn_times = FindConVar("mp_disable_respawn_times");
}

void Dungeon_ConfigSetup(KeyValues map)
{
	KeyValues kv = map;
	if(kv)
	{
		kv.Rewind();
		if(!kv.JumpToKey("Dungeon"))
			kv = null;
	}
	
	char buffer[PLATFORM_MAX_PATH];
	if(!kv)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), CONFIG_CFG, "dungeon");
		kv = new KeyValues("Dungeon");
		kv.ImportFromFile(buffer);
	}

	if(DungeonList)
	{
		DungeonEnum dungeon;
		StringMapSnapshot snap = DungeonList.Snapshot();
		int length = snap.Length;
		for(int i; i < length; i++)
		{
			int size = snap.KeyBufferSize(i) + 1;
			char[] name = new char[size];
			DungeonList.GetArray(name, dungeon, sizeof(dungeon));
			dungeon.Delete();
		}

		delete snap;
		delete DungeonList;
	}
	
	DungeonList = new StringMap();

	DungeonEnum dungeon;
	dungeon.EntRef = INVALID_ENT_REFERENCE;

	if(kv.GotoFirstSubKey())
	{
		do
		{
			dungeon.SetupEnum(kv, buffer, sizeof(buffer));
			kv.GetSectionName(buffer, sizeof(buffer));
			DungeonList.SetArray(buffer, dungeon, sizeof(dungeon));
		}
		while(kv.GotoNextKey());
	}

	if(kv != map)
		delete kv;
}

void Dungeon_EnableZone(const char[] name)
{
	static DungeonEnum dungeon;
	if(DungeonList.GetArray(name, dungeon, sizeof(dungeon)))
	{
		dungeon.Spawn();
		DungeonList.SetArray(name, dungeon, sizeof(dungeon));
	}
}

void Dungeon_DisableZone(const char[] name)
{
	static DungeonEnum dungeon;
	if(DungeonList.GetArray(name, dungeon, sizeof(dungeon)))
	{
		dungeon.Despawn();
		DungeonList.SetArray(name, dungeon, sizeof(dungeon));
	}
}

bool Dungeon_Interact(int client, int entity, int weapon)
{
	StringMapSnapshot snap = DungeonList.Snapshot();

	bool result;
	int length = snap.Length;
	for(int i; i < length; i++)
	{
		int size = snap.KeyBufferSize(i) + 1;
		char[] name = new char[size];
		snap.GetKey(i, name, size);

		static DungeonEnum dungeon;
		DungeonList.GetArray(name, dungeon, sizeof(dungeon));
		if(EntRefToEntIndex(dungeon.EntRef) == entity)
		{
			strcopy(DungeonMenu[client], sizeof(DungeonMenu[]), name);
			ShowMenu(client, 0);
			result = true;
			break;
		}
	}

	delete snap;
	return result;
}

static void ShowMenu(int client, int page)
{
	static DungeonEnum dungeon;
	if(DungeonList.GetArray(DungeonMenu[client], dungeon, sizeof(dungeon)))
	{
		Menu menu = new Menu(Dungeon_Menu);

		int leader = Party_GetPartyLeader(client);
		if(!leader)
			leader = client;
		
		if(dungeon.CurrentStage[0])
		{
			int time = RoundToFloor(GetGameTime() - dungeon.StartTime);
			if(time >= 0)
			{
				menu.SetTitle("RPG Fortress\n \nContingency Contract:\n%s △%d\nTime Elapsed: %d:%02d\n ", dungeon.CurrentStage, dungeon.TierLevel(), time / 60, time % 60);

				for(int target = 1; target <= MaxClients; target++)
				{
					if(StrEqual(InDungeon[target], DungeonMenu[client]))
					{
						if(client == target)
						{
							Format(dungeon.CurrentStage, sizeof(dungeon.CurrentStage), "%N (Leave)", client);
							menu.AddItem(NULL_STRING, dungeon.CurrentStage);
						}
						else if(IsPlayerAlive(target))
						{
							GetClientName(target, dungeon.CurrentStage, sizeof(dungeon.CurrentStage));
							menu.AddItem(NULL_STRING, dungeon.CurrentStage, ITEMDRAW_DISABLED);
						}
						else
						{
							Format(dungeon.CurrentStage, sizeof(dungeon.CurrentStage), "%N (Dead)", target);
							menu.AddItem(NULL_STRING, dungeon.CurrentStage, ITEMDRAW_DISABLED);
						}
					}
				}
			}
			else
			{
				time = -time;
				menu.SetTitle("RPG Fortress\n \nContingency Contract:\n%s △%d\nStarts In: %d:%02d\n ", dungeon.CurrentStage, dungeon.TierLevel(), time / 60, time % 60);

				static StageEnum stage;
				dungeon.StageList.GetArray(dungeon.CurrentStage, stage, sizeof(stage));

				if(AltMenu[client] || !stage.ModList)
				{
					AltMenu[client] = true;

					bool found;
					for(int target = 1; target <= MaxClients; target++)
					{
						if(client == target && client == leader)
						{
							Format(dungeon.CurrentStage, sizeof(dungeon.CurrentStage), "%N (Leave)\n ", client);
							
							if(menu.ItemCount)
							{
								menu.InsertItem(0, NULL_STRING, dungeon.CurrentStage);
							}
							else
							{
								menu.AddItem(NULL_STRING, dungeon.CurrentStage);
							}
							
							found = true;
						}
						else if(client != leader && target == leader)
						{
							Format(dungeon.CurrentStage, sizeof(dungeon.CurrentStage), "%N (Party Leader)", target);
							menu.AddItem(NULL_STRING, dungeon.CurrentStage, ITEMDRAW_DISABLED);
						}
						else if(dungeon.CurrentHost == target)
						{
							Format(dungeon.CurrentStage, sizeof(dungeon.CurrentStage), "%N (Host)", target);
							menu.AddItem(NULL_STRING, dungeon.CurrentStage, ITEMDRAW_DISABLED);
						}
						else if(StrEqual(InDungeon[target], DungeonMenu[client]))
						{
							GetClientName(target, dungeon.CurrentStage, sizeof(dungeon.CurrentStage));
							menu.AddItem(NULL_STRING, dungeon.CurrentStage, ITEMDRAW_DISABLED);
						}
					}

					if(!found)
					{
						if(client == leader)
						{
							menu.InsertItem(0, NULL_STRING, "Enter Queue\n ");
						}
						else
						{
							menu.InsertItem(0, NULL_STRING, "Party Leader Must Enter Queue\n ", ITEMDRAW_DISABLED);
						}
					}
				}
				else
				{
					StringMapSnapshot snap = stage.ModList.Snapshot();

					int length = snap.Length;
					for(int i; i < length; i++)
					{
						int size = snap.KeyBufferSize(i) + 1;
						char[] name = new char[size];

						static ModEnum mod;
						stage.ModList.GetArray(name, mod, sizeof(mod));
						Format(mod.Desc, sizeof(mod.Desc), "[%s] %s △%d\n%s\n ", dungeon.ModList.FindString(name) == -1 ? " " : "X", name, mod.Tier, mod.Desc);

						menu.AddItem(name, mod.Desc, client == dungeon.CurrentHost ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
					}

					delete snap;

					menu.Pagination = 3;
				}

				menu.ExitBackButton = view_as<bool>(stage.ModList);
			}
		}
		else
		{
			if(client == leader)
			{
				menu.SetTitle("RPG Fortress\n \nContingency Contract:");
			}
			else
			{
				menu.SetTitle("RPG Fortress\n \nContingency Contract:\nYour Party Leader is %N", leader);
			}

			StringMapSnapshot snap = dungeon.StageList.Snapshot();

			int length = snap.Length;
			for(int i; i < length; i++)
			{
				int size = snap.KeyBufferSize(i) + 1;
				char[] name = new char[size];
				menu.AddItem(name, name, client == leader ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
			}

			delete snap;
		}

		menu.DisplayAt(client, page, MENU_TIME_FOREVER);
	}
}

public int Dungeon_MenuHandle(Menu menu, MenuAction action, int client, int choice)
{
	switch(action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Cancel:
		{
			if(choice == MenuCancel_ExitBack)
			{
				AltMenu[client] = !AltMenu[client];
				ShowMenu(client, 0);
			}
		}
		case MenuAction_Select:
		{
			static DungeonEnum dungeon;
			if(DungeonList.GetArray(DungeonMenu[client], dungeon, sizeof(dungeon)))
			{
				if(dungeon.CurrentStage[0])
				{
					static StageEnum stage;
					if(dungeon.StageList.GetArray(dungeon.CurrentStage, stage, sizeof(stage)))
					{
						menu.GetItem(choice, dungeon.CurrentStage, sizeof(dungeon.CurrentStage));
						if(GetGameTime() < dungeon.StartTime && !AltMenu[client])	// Add/Remove Mod
						{
							if(!dungeon.CurrentStage[0])
							{
								ShowMenu(client, 0);
							}
							else
							{
								int pos = dungeon.ModList.FindString(dungeon.CurrentStage);
								if(pos != -1)
								{
									dungeon.ModList.Erase(pos);
								}
								else if(stage.ModList.HasKey(dungeon.CurrentStage))
								{
									dungeon.ModList.PushString(dungeon.CurrentStage);
								}

								ShowMenu(client, choice);
							}
						}
						else if(dungeon.CurrentStage[0])
						{
							ShowMenu(client, 0);
						}
						else	// Join/Leave Lobby
						{
							bool alreadyIn = StrEqual(InDungeon[client], DungeonMenu[client]);
							Dungeon_ClientDisconnect(client, true);

							if(!alreadyIn)
							{
								strcopy(InDungeon[client], sizeof(InDungeon[]), DungeonMenu[client]);
								ShowMenu(client, 0);
							}
						}
					}
				}
				else	// Create Lobby
				{
					menu.GetItem(choice, dungeon.CurrentStage, sizeof(dungeon.CurrentStage));
					if(dungeon.CurrentStage[0])
					{
						delete dungeon.ModList;
						dungeon.ModList = new ArrayList(ByteCountToCells(64));
						dungeon.CurrentHost = client;
						DungeonList.SetArray(DungeonMenu[client], dungeon, sizeof(dungeon));
					}

					ShowMenu(client, 0);
				}
			}
		}
	}
}

void Dungeon_ResetEntity(int entity)
{
	InDungeon[entity][0] = 0;
}

void Dungeon_ClientDisconnect(int client, bool alive = false)
{
	AltMenu[client] = false;

	if(InDungeon[client][0])
	{
		static DungeonEnum dungeon;
		if(DungeonList.GetArray(InDungeon[client], dungeon, sizeof(dungeon)) && dungeon.CurrentHost == client && !dungeon.WaveList)
		{
			dungeon.StartTime += 45.0;
			float maximum = GetGameTime() + QUEUE_TIME;
			if(dungeon.StartTime > maximum)
				dungeon.StartTime = maximum;
			
			dungeon.CurrentHost = 0;
			for(int target = 1; target <= MaxClients; target++)
			{
				if(target != client && StrEqual(InDungeon[client], InDungeon[target]))
				{
					if(!dungeon.CurrentHost)
						dungeon.CurrentHost = target;
					
					SPrintToChat(target, "%N left the lobby as the host, %N is the new host!", client, dungeon.CurrentHost);
				}
			}
		}

		if(alive)
			mp_disable_respawn_times.ReplicateToClient(client, "0");

		InDungeon[client][0] = 0;
		Dungeon_CheckAlivePlayers();
	}
}

void Dungeon_CheckAlivePlayers()
{
	StringMapSnapshot snap = DungeonList.Snapshot();

	int length = snap.Length;
	for(int i; i < length; i++)
	{
		int size = snap.KeyBufferSize(i) + 1;
		char[] name = new char[size];
		snap.GetKey(i, name, size);

		bool found;
		for(int client = 1; client <= MaxClients; client++)
		{
			if(StrEqual(InDungeon[client], name) && IsPlayerAlive(client))
			{
				found = true;
				break;
			}
		}

		CleanDungeon(name);
	}

	delete snap;
}

static void StartDungeon(const char[] name)
{
	static DungeonEnum dungeon;
	if(DungeonList.GetArray(name, dungeon, sizeof(dungeon)) && dungeon.CurrentStage[0])
	{
		static StageEnum stage;
		if(dungeon.StageList.GetArray(dungeon.CurrentStage, stage, sizeof(stage)))
		{
			dungeon.PlayerCount = 0;

			int[] clients = new int[MaxClients];
			for(int client = 1; client <= MaxClients; client++)
			{
				if(StrEqual(InDungeon[client], name))
				{
					InDungeon[client][0] = 0;
					mp_disable_respawn_times.ReplicateToClient(client, "1");
					f3_SpawnPosition[client] = stage.StartPos;
					TF2_RespawnPlayer(client);
					clients[dungeon.PlayerCount++] = client;
				}
			}

			delete dungeon.WaveList;
			dungeon.WaveList = stage.WaveList.Clone();
			
			if(dungeon.ModList)
			{
				int length = dungeon.ModList.Length;
				for(int i; i < length; i++)
				{
					static ModEnum mod;
					dungeon.ModList.GetString(i, mod.Desc, sizeof(mod.Desc));
					if(stage.ModList.GetArray(mod.Desc, mod, sizeof(mod)))
					{
						for(int c; c < dungeon.PlayerCount; c++)
						{
							SPrintToChat(clients[c], mod.Desc);
						}

						mod.CallOnWaves(dungeon.WaveList);
					}

				}
			}
			
			dungeon.CurrentStage[0] = 0;
			dungeon.CurrentHost = 0;
			dungeon.StartTime = 0.0;
			delete dungeon.ModList;
			delete dungeon.WaveList;
			DungeonList.SetArray(name, dungeon, sizeof(dungeon));
		}
		else
		{
			ThrowError("Somehow got invalid stage '%s'", dungeon.CurrentStage);
		}
	}
	else
	{
		ThrowError("Somehow got invalid dungeon '%s'", name);
	}
}

static void CleanDungeon(const char[] name)
{
	static DungeonEnum dungeon;
	if(DungeonList.GetArray(name, dungeon, sizeof(dungeon)) && dungeon.CurrentStage[0])
	{
		for(int client = 1; client <= MaxClients; client++)
		{
			if(StrEqual(InDungeon[client], name))
			{
				InDungeon[client][0] = 0;
				mp_disable_respawn_times.ReplicateToClient(client, "0");
				f3_SpawnPosition[client] = dungeon.RespawnPos;
			}
		}

		int i = MaxClients + 1;
		while((i = FindEntityByClassname(i, "base_boss")) != -1)
		{
			if(StrEqual(InDungeon[i], name))
				NPC_Despawn(i);
		}
		
		dungeon.CurrentStage[0] = 0;
		dungeon.CurrentHost = 0;
		dungeon.StartTime = 0.0;
		delete dungeon.ModList;
		delete dungeon.WaveList;
		DungeonList.SetArray(name, dungeon, sizeof(dungeon));
	}
	else
	{
		ThrowError("Somehow got invalid dungeon '%s'", name);
	}
}

bool Dungeon_CanClientRespawn(int client)
{
	if(InDungeon[client][0])
	{
		static DungeonEnum dungeon;
		DungeonList.GetArray(InDungeon[client], dungeon, sizeof(dungeon));
		if(dungeon.WaveList)
			return false;
	}

	return true;
}