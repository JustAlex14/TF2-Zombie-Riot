#pragma semicolon 1
#pragma newdecls required

#define TINKER_LIMIT	4

enum struct TinkerEnum
{
	int AccountId;
	int StoreIndex;
	int Attrib[TINKER_LIMIT];
	float Value[TINKER_LIMIT];
	float Luck[TINKER_LIMIT];
}

static const int SupportBuildings[] = { 2, 5, 9, 14, 14, 15 };
static const int MetalGain[] = { 10, 25, 50, 100, 200, 300 };
static const float Cooldowns[] = { 180.0, 150.0, 120.0, 90.0, 60.0, 30.0 };
static int SmithLevel[MAXTF2PLAYERS] = {-1, ...};
static int i_AdditionalSupportBuildings[MAXTF2PLAYERS] = {0, ...};

static int ParticleRef[MAXTF2PLAYERS] = {-1, ...};
static Handle EffectTimer[MAXTF2PLAYERS];

static ArrayList Tinkers;

void Blacksmith_RoundStart()
{
	Zero(i_AdditionalSupportBuildings);
	delete Tinkers;
}

int Blacksmith_Additional_SupportBuildings(int client)
{
	return i_AdditionalSupportBuildings[client];
}

bool Blacksmith_HasTinker(int client, int index)
{
	if(Tinkers)
	{
		int account = GetSteamAccountID(client, false);
		if(account)
		{
			static TinkerEnum tinker;
			int length = Tinkers.Length;
			for(int a; a < length; a++)
			{
				Tinkers.GetArray(a, tinker);
				if(tinker.AccountId == account && tinker.StoreIndex == index)
					return true;
			}
		}
	}
	
	return false;
}

void Blacksmith_ExtraDesc(int client, int index)
{
	if(Tinkers)
	{
		int account = GetSteamAccountID(client, false);
		if(account)
		{
			static TinkerEnum tinker;
			int length = Tinkers.Length;
			for(int a; a < length; a++)
			{
				Tinkers.GetArray(a, tinker);
				if(tinker.AccountId == account && tinker.StoreIndex == index)
				{
					for(int b; b < sizeof(tinker.Attrib); b++)
					{
						if(!tinker.Attrib[b])
							break;
						
						PrintAttribValue(client, tinker.Attrib[b], tinker.Value[b], tinker.Luck[b]);
					}

					break;
				}
			}
		}
	}
}

void Blacksmith_Enable(int client, int weapon)
{
	if(i_CustomWeaponEquipLogic[weapon] == WEAPON_BLACKSMITH)
	{
		SmithLevel[client] = RoundFloat(Attributes_Get(weapon, 868, 0.0));

		if(SmithLevel[client] >= sizeof(MetalGain))
			SmithLevel[client] = sizeof(MetalGain) - 1;

		delete EffectTimer[client];
		EffectTimer[client] = CreateTimer(0.5, Blacksmith_TimerEffect, client, TIMER_REPEAT);

		i_AdditionalSupportBuildings[client] = SupportBuildings[SmithLevel[client]];
	}

	if(Tinkers)
	{
		int account = GetSteamAccountID(client, false);
		if(account)
		{
			static TinkerEnum tinker;
			int length = Tinkers.Length;
			for(int a; a < length; a++)
			{
				Tinkers.GetArray(a, tinker);
				if(tinker.AccountId == account && tinker.StoreIndex == StoreWeapon[weapon])
				{
					for(int b; b < sizeof(tinker.Attrib); b++)
					{
						if(!tinker.Attrib[b])
							break;
						
						Attributes_SetMulti(weapon, tinker.Attrib[b], tinker.Value[b]);
					}

					break;
				}
			}
		}
	}
}

public Action Blacksmith_TimerEffect(Handle timer, int client)
{
	if(IsClientInGame(client))
	{
		if(!dieingstate[client] && IsPlayerAlive(client) && TeutonType[client] == TEUTON_NONE && i_HealthBeforeSuit[client] == 0)
		{
			int weapon = GetPlayerWeaponSlot(client, TFWeaponSlot_Secondary);
			if(weapon != -1)
			{
				if(i_CustomWeaponEquipLogic[weapon] == WEAPON_BLACKSMITH)
				{
					if(!Waves_InSetup() && GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == weapon)
					{
						SetAmmo(client, Ammo_Metal, GetAmmo(client, Ammo_Metal) + MetalGain[SmithLevel[client]]);
					}

					i_AdditionalSupportBuildings[client] = SupportBuildings[SmithLevel[client]];

					if(ParticleRef[client] == -1)
					{
						float pos[3]; GetClientAbsOrigin(client, pos);
						pos[2] += 1.0;

						int entity = ParticleEffectAt(pos, "utaunt_hellpit_firering", -1.0);
						if(entity > MaxClients)
						{
							SetParent(client, entity);
							ParticleRef[client] = EntIndexToEntRef(entity);
						}
					}
					
					return Plugin_Continue;
				}
			}
			i_AdditionalSupportBuildings[client] = 0;
			SmithLevel[client] = -1;
		}
		
		if(ParticleRef[client] != -1)
		{
			int entity = EntRefToEntIndex(ParticleRef[client]);
			if(entity > MaxClients)
			{
				TeleportEntity(entity, OFF_THE_MAP);
				RemoveEntity(entity);
			}

			ParticleRef[client] = -1;
		}

		return Plugin_Continue;
	}

	SmithLevel[client] = -1;
		
	if(ParticleRef[client] != -1)
	{
		int entity = EntRefToEntIndex(ParticleRef[client]);
		if(entity > MaxClients)
		{
			TeleportEntity(entity, OFF_THE_MAP);
			RemoveEntity(entity);
		}
		
		ParticleRef[client] = -1;
	}
	i_AdditionalSupportBuildings[client] = 0;
	EffectTimer[client] = null;
	return Plugin_Stop;
}

public void Weapon_BlacksmithMelee_M2(int client, int weapon, bool crit, int slot)
{
	if(dieingstate[client] != 0 || Ability_Check_Cooldown(client, slot) > 0.0)
	{
		ClientCommand(client, "playgamesound items/medshotno1.wav");
		SetDefaultHudPosition(client);
		SetGlobalTransTarget(client);
		ShowSyncHudText(client,  SyncHud_Notifaction, "%t", "Ability has cooldown", Ability_Check_Cooldown(client, slot));
		return;
	}

	Rogue_OnAbilityUse(weapon);
	Ability_Apply_Cooldown(client, slot, 10.0);

	ClientCommand(client, "playgamesound weapons/gunslinger_three_hit.wav");

	ApplyTempAttrib(weapon, 2, 2.0, 2.0);
	ApplyTempAttrib(weapon, 6, 0.25, 2.0);
}

public Action Blacksmith_BuildingTimer(Handle timer, int ref)
{
	int entity = EntRefToEntIndex(ref);
	if(entity == -1)
		return Plugin_Stop;
	
	int maxRepair = Building_Max_Health[entity] * 2;

	if(Building_cannot_be_repaired[entity])
	{
		int maxhealth = GetEntProp(entity, Prop_Data, "m_iMaxHealth") + (maxRepair / 1500);
		if(maxhealth >= Building_Max_Health[entity])
		{
			Building_Repair_Health[entity] += Building_Max_Health[entity] - maxhealth;
			if(Building_Repair_Health[entity] >= maxRepair)
				Building_Repair_Health[entity] = maxRepair - 1;
			
			maxhealth = Building_Max_Health[entity];
			Building_cannot_be_repaired[entity] = false;
		}

		SetEntProp(entity, Prop_Data, "m_iMaxHealth", maxhealth);
	}
	else if(Building_Repair_Health[entity] < maxRepair)
	{
		Building_Repair_Health[entity] += (maxRepair / 1500);
		if(Building_Repair_Health[entity] > maxRepair)
			Building_Repair_Health[entity] = maxRepair;
		
		int progress = (Building_Repair_Health[entity] - 1) * 100 / Building_Max_Health[entity];
		SetEntProp(entity, Prop_Send, "m_iUpgradeMetal", progress + 1);
	}

	return Plugin_Continue;
}

void Blacksmith_BuildingUsed(int entity, int client, int owner)
{
	if(owner == -1 || SmithLevel[owner] < 0)
	{
		ClientCommand(client, "playgamesound items/medshotno1.wav");
		ApplyBuildingCollectCooldown(entity, client, FAR_FUTURE);
		return;
	}

	int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(weapon == -1)
	{
		ClientCommand(client, "playgamesound items/medshotno1.wav");
		ApplyBuildingCollectCooldown(entity, client, 1.0);
		return;
	}
	
	int account = GetSteamAccountID(client, false);
	if(!account)
	{
		ClientCommand(client, "playgamesound items/medshotno1.wav");
		ApplyBuildingCollectCooldown(entity, client, 3.0);
		return;
	}

	TinkerEnum tinker;
	int found = -1;
	if(Tinkers)
	{
		int length = Tinkers.Length;
		for(int a; a < length; a++)
		{
			Tinkers.GetArray(a, tinker);
			if(tinker.AccountId == account && tinker.StoreIndex == StoreWeapon[weapon])
			{
				found = a;
				break;
			}
		}
	}

	if(found == -1)
	{
		tinker.AccountId = account;
		tinker.StoreIndex = StoreWeapon[weapon];
	}
	
	Zero(tinker.Attrib);

	int rarity;
	if(GetClientButtons(client) & IN_DUCK)
	{
		SetGlobalTransTarget(client);
		
		if(found == -1)
		{
			ClientCommand(client, "playgamesound items/medshotno1.wav");
			SetDefaultHudPosition(client);
			ShowSyncHudText(client, SyncHud_Notifaction, "%t", "Blacksmith No Attribs");

			ApplyBuildingCollectCooldown(entity, client, 2.0);
			return;
		}

		rarity = -1;
		Tinkers.Erase(found);
		PrintToChat(client, "%t", "Removed Tinker Attributes");
	}
	else
	{
		switch(SmithLevel[owner])
		{
			case 0, 1:
			{
				
			}
			case 2:
			{
				if((GetURandomInt() % 4) == 0)
					rarity = 1;
			}
			case 3:
			{
				int rand = GetURandomInt();
				if((rand % 7) == 0)
				{
					rarity = 2;
				}
				else if((rand % 3) == 0)
				{
					rarity = 1;
				}
			}
			case 4:
			{
				int rand = GetURandomInt();
				if((rand % 5) == 0)
				{
					rarity = 2;
				}
				else if((rand % 2) == 0)
				{
					rarity = 1;
				}
			}
			default:
			{
				if((GetURandomInt() % 3) == 0)
				{
					rarity = 2;
				}
				else
				{
					rarity = 1;
				}
			}
		}

		for(int i; i < sizeof(tinker.Luck); i++)
		{
			tinker.Luck[i] = GetURandomFloat();
		}

		char classname[64];
		GetEntityClassname(weapon, classname, sizeof(classname));
		int slot = TF2_GetClassnameSlot(classname);
		if(i_IsWandWeapon[weapon])
		{
			// Mage Weapon
			switch(GetURandomInt() % 4)
			{
				case 0:
					TinkerHastyMage(rarity, tinker);
				case 1:
					TinkerHeavyMage(rarity, tinker);
				case 2:
					TinkerConcentrationMage(rarity, tinker);
				case 3:
					TinkerTankMage(rarity, tinker);
			}
		}
		else if(Attributes_Get(weapon, 8, 0.0) != 0.0)
		{
			//mediguns, they work uniqurely
			if(StrEqual(classname, "tf_weapon_medigun"))
			{
				switch(GetURandomInt() % 3)
				{
					case 0:
						TinkerMedigun_FastHeal(rarity, tinker);
					case 1:
						TinkerMedigun_Overhealer(rarity, tinker);
					case 2:
						TinkerMedigun_Uberer(rarity, tinker);
				}
			}
			else
			{
				if(slot == TFWeaponSlot_Melee)
				{
					TinkerMedicWeapon_GlassyMedic(rarity, tinker);
				}
				else
				{
					switch(GetURandomInt() % 2)
					{
						case 0:
							TinkerMedicWeapon_GlassyMedic(rarity, tinker);
						case 1:
							TinkerMedicWeapon_BurstHealMedic(rarity, tinker);
					}					
				}

				//anything else.
			}
		}
		else if(i_IsWrench[weapon] && slot != TFWeaponSlot_Melee)
		{
			//any wrench weapon that isnt melee?
			TinkerBuilderRepairMaster(rarity, tinker);
		}
		else if(slot == TFWeaponSlot_Melee)
		{
			if(i_IsWrench[weapon])
			{
				if(Attributes_Get(weapon, 264, 0.0) != 0.0)
				{
					switch(GetURandomInt() % 2)
					{
						case 0:
							TinkerBuilderRepairMaster(rarity, tinker);
						case 1:
							TinkerBuilderLongSwing(rarity, tinker);
					}
				}
				else
				{
					switch(GetURandomInt() % 2)
					{
						case 0:
							TinkerBuilderRepairMaster(rarity, tinker);
						case 1:
							TinkerBuilderLongSwing(rarity, tinker);
					}					
				}
				// Wrench Weapon
			}
			else
			{
				// Melee Weapon
				switch(GetURandomInt() % 4)
				{
					case 0:
						TinkerMeleeGlassy(rarity, tinker);
					case 1:
						TinkerMeleeRapidSwing(rarity, tinker);
					case 2:
						TinkerMeleeHeavySwing(rarity, tinker);
					case 3:
						TinkerMeleeLongSwing(rarity, tinker);
				}
			}
		}

		else if(slot < TFWeaponSlot_Melee)
		{
			if(Attributes_Has(weapon, 101) || Attributes_Has(weapon, 102) || Attributes_Has(weapon, 103) || Attributes_Has(weapon, 104))
			{
				//infinite fire
				if(Attributes_Has(weapon, 303))
				{
					switch(GetURandomInt() % 4)
					{
						case 0:
							TinkerMeleeRapidSwing(rarity, tinker);
						case 1:
							TinkerRangedSlowHeavyProj(rarity, tinker);
						case 2:
							TinkerRangedFastProj(rarity, tinker);
						case 3:
							TinkerHeavyTrigger(rarity, tinker);
					}
				}
				else
				{
					switch(GetURandomInt() % 6)
					{
						case 0:
							TinkerMeleeRapidSwing(rarity, tinker);
						case 1:
							TinkerRangedSlowHeavyProj(rarity, tinker);
						case 2:
							TinkerRangedFastProj(rarity, tinker);
						case 3:
							TinkerIntensiveClip(rarity, tinker);
						case 4:
							TinkerConcentratedClip(rarity, tinker);
						case 5:
							TinkerHeavyTrigger(rarity, tinker);
						case 6:
							TinkerSmallerSmarterBullets(rarity, tinker);
					}
				}
				// Projectile Weapon
			}
			else
			{
				//infinite fire
				if(Attributes_Has(weapon, 303))
				{
					for(int RetryTillWin; RetryTillWin < 10; RetryTillWin++)
					{
						switch(GetURandomInt() % 3)
						{
							case 0:
							{
								TinkerMeleeRapidSwing(rarity, tinker);
								RetryTillWin = 11;
							}
							case 1:
							{
								TinkerHeavyTrigger(rarity, tinker);
								RetryTillWin = 11;
							}
							case 2:
							{
								if(Attributes_Get(weapon, 45, 0.0) > 0.0)
								{
									RetryTillWin = 11;
									TinkerSprayAndPray(rarity, tinker);
								}
							}
						}	
					}
				}
				else
				{
					for(int RetryTillWin; RetryTillWin < 10; RetryTillWin++)
					{
						switch(GetURandomInt() % 6)
						{
							case 0:
							{
								TinkerMeleeRapidSwing(rarity, tinker);
								RetryTillWin = 11;
							}
							case 1:
							{
								TinkerIntensiveClip(rarity, tinker);
								RetryTillWin = 11;
							}
							case 2:
							{
								TinkerConcentratedClip(rarity, tinker);
								RetryTillWin = 11;
							}
							case 3:
							{
								TinkerHeavyTrigger(rarity, tinker);
								RetryTillWin = 11;
							}
							case 4:
							{
								TinkerSmallerSmarterBullets(rarity, tinker);
								RetryTillWin = 11;
							}
							case 5:
							{
								if(Attributes_Get(weapon, 45, 0.0) > 0.0)
								{
									RetryTillWin = 11;
									TinkerSprayAndPray(rarity, tinker);
								}
							}
						}	
					}
				}
				// Hitscan Weapon
			}
		}
		else
		{
			ClientCommand(client, "playgamesound items/medshotno1.wav");
			SetDefaultHudPosition(client);
			SetGlobalTransTarget(client);
			ShowSyncHudText(client, SyncHud_Notifaction, "%t", "Blacksmith Underleveled");

			ApplyBuildingCollectCooldown(entity, client, 2.0);
			return;
		}

		for(int i; i < sizeof(tinker.Attrib); i++)
		{
			if(!tinker.Attrib[i])
				break;
			
			PrintAttribValue(client, tinker.Attrib[i], tinker.Value[i], tinker.Luck[i]);
		}

		if(found == -1)
		{
			if(!Tinkers)
				Tinkers = new ArrayList(sizeof(TinkerEnum));
			
			Tinkers.PushArray(tinker);
		}
		else
		{
			Tinkers.SetArray(found, tinker);
		}
	}

	Store_ApplyAttribs(client);
	Store_GiveAll(client, GetClientHealth(client));	

	switch(rarity)
	{
		case -1:
		{
			ClientCommand(client, "playgamesound ui/quest_decode.wav");
		}
		case 0:
		{
			ClientCommand(client, "playgamesound ui/quest_status_tick_novice.wav");
		}
		case 1:
		{
			ClientCommand(client, "playgamesound ui/quest_status_tick_advanced.wav");
		}
		case 2:
		{
			ClientCommand(client, "playgamesound ui/quest_status_tick_expert.wav");
		}
	}

	float cooldown = Cooldowns[SmithLevel[owner]];
	if(client != owner && Store_HasWeaponKit(client))
		cooldown *= 0.5;
	
	ApplyBuildingCollectCooldown(entity, client, cooldown);

	if(!Rogue_Mode() && owner != client)
	{
		if(i_Healing_station_money_limit[owner][client] < 20)
		{
			i_Healing_station_money_limit[owner][client]++;
			Resupplies_Supplied[owner] += 2;
			GiveCredits(owner, 20, true);
			SetDefaultHudPosition(owner);
			SetGlobalTransTarget(owner);
			ShowSyncHudText(owner, SyncHud_Notifaction, "%t", "Blacksmith Used");
		}

		switch(rarity)
		{
			case 0:
			{
				ClientCommand(owner, "playgamesound ui/quest_status_tick_novice_friend.wav");
			}
			case 1:
			{
				ClientCommand(owner, "playgamesound ui/quest_status_tick_advanced_friend.wav");
			}
			default:
			{
				ClientCommand(owner, "playgamesound ui/quest_status_tick_expert_friend.wav");
			}
		}
	}
}

static bool AttribIsInverse(int attrib)
{
	switch(attrib)
	{
		case 5, 6, 96, 97, 205, 206, 343, 412:
			return true;
	}

	return false;
}

static void PrintAttribValue(int client, int attrib, float value, float luck)
{
	bool inverse = AttribIsInverse(attrib);
	
	char buffer[64];
	if(value < 1.0)
	{
		FormatEx(buffer, sizeof(buffer), "%d%% ", RoundToCeil((1.0 - value) * 100.0));
	}
	else
	{
		FormatEx(buffer, sizeof(buffer), "%d%% ", RoundToCeil((value - 1.0) * 100.0));
	}

	//inverse the inverse!
	bool inverse_color = false;
	if(attrib == 733)
	{
		inverse_color = true;
	}

	if(((value < 1.0) ^ inverse))
	{
		if(!inverse_color)
		{
			Format(buffer, sizeof(buffer), "{crimson}-%s", buffer);
		}
		else
		{
			Format(buffer, sizeof(buffer), "{green}-%s", buffer);
		}
	}
	else
	{
		if(!inverse_color)
		{
			Format(buffer, sizeof(buffer), "{green}+%s", buffer);
		}
		else
		{
			Format(buffer, sizeof(buffer), "{crimson}+%s", buffer);
		}
	}

	switch(attrib)
	{
		case 1:
			Format(buffer, sizeof(buffer), "%sPhysical Damage", buffer);
		
		case 2:
			Format(buffer, sizeof(buffer), "%sBase Damage", buffer);
		
		case 3, 4:
			Format(buffer, sizeof(buffer), "%sClip Size", buffer);
		
		case 5, 6:
			Format(buffer, sizeof(buffer), "%sFiring Speed", buffer);
		
		case 8:
			Format(buffer, sizeof(buffer), "%sHealing Rate", buffer);
		
		case 10:
			Format(buffer, sizeof(buffer), "%sÜberCharge Rate", buffer);
		
		case 26:
			Format(buffer, sizeof(buffer), "%sMax Health Bonus", buffer);
		
		case 45:
			Format(buffer, sizeof(buffer), "%sBullets Per Shot", buffer);
		
		case 94:
			Format(buffer, sizeof(buffer), "%sRepair Rate", buffer);
		
		case 96, 97:
			Format(buffer, sizeof(buffer), "%sReload Speed", buffer);
		
		case 99, 100:
			Format(buffer, sizeof(buffer), "%sBlast Radius", buffer);
		
		case 101, 102:
			Format(buffer, sizeof(buffer), "%sProjectile Range", buffer);
		
		case 103, 104:
			Format(buffer, sizeof(buffer), "%sProjectile Speed", buffer);
		
		case 107:
			Format(buffer, sizeof(buffer), "%sMovement Speed", buffer);
		
		case 149:
			Format(buffer, sizeof(buffer), "%sBleed Duration", buffer);
		
		case 205:
			Format(buffer, sizeof(buffer), "%sRanged Damage Resistance", buffer);
		
		case 206:
			Format(buffer, sizeof(buffer), "%sMelee Damage Resistance", buffer);
		
		case 287:
			Format(buffer, sizeof(buffer), "%sSentry Damage", buffer);
		
		case 319:
			Format(buffer, sizeof(buffer), "%sBuff Duration", buffer);
		
		case 343:
			Format(buffer, sizeof(buffer), "%sSentry Firing Speed", buffer);
		
		case 410:
			Format(buffer, sizeof(buffer), "%sBase Damage", buffer);
		
		case 412:
			Format(buffer, sizeof(buffer), "%sDamage Resistance", buffer);

		case 733:
			Format(buffer, sizeof(buffer), "%sMagic Shot Cost", buffer);

		case 4001:
			Format(buffer, sizeof(buffer), "%sExtra Melee Range", buffer);

		case 4002:
			Format(buffer, sizeof(buffer), "%sMore Medigun Overheal", buffer);

	}

	CPrintToChat(client, "%s {yellow}(%d%%)", buffer, RoundToCeil(luck * 100.0));
}

static void TinkerMeleeGlassy(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2;
	tinker.Attrib[1] = 205;
	tinker.Attrib[2] = 206;
	float DamageLuck = (0.1 * (tinker.Luck[0]));
	float RangedDmgVulLuck = (0.05 * (1.0 + (-1.0*(tinker.Luck[1]))));
	float MeleeDmgVulLuck = (0.05 * (1.0 + (-1.0*(tinker.Luck[2]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.1 + DamageLuck;
			tinker.Value[1] = 1.05 + RangedDmgVulLuck;
			tinker.Value[2] = 1.05 + MeleeDmgVulLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.15 + DamageLuck;
			tinker.Value[1] = 1.05 + RangedDmgVulLuck;
			tinker.Value[2] = 1.05 + MeleeDmgVulLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.2 + DamageLuck;
			tinker.Value[1] = 1.05 + RangedDmgVulLuck;
			tinker.Value[2] = 1.05 + MeleeDmgVulLuck;
		}
	}
}


static void TinkerMeleeRapidSwing(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //damage
	tinker.Attrib[1] = 6; //attackspeed
	//less damage
	//but faster attackspeed
	//inverts the luck
	float DamageLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[0]))));
	float AttackspeedLuck = (0.1 * (tinker.Luck[1]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 0.95 - DamageLuck;
			tinker.Value[1] = 0.9 - AttackspeedLuck;
		}
		case 1:
		{
			tinker.Value[0] = 0.85 - DamageLuck;
			tinker.Value[1] = 0.8 - AttackspeedLuck;
		}
		case 2:
		{
			tinker.Value[0] = 0.8 - DamageLuck;
			tinker.Value[1] = 0.7 - AttackspeedLuck;
		}
	}
}

static void TinkerMeleeHeavySwing(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //damage
	tinker.Attrib[1] = 6; //attackspeed
	//less damage
	//but faster attackspeed
	//inverts the luck
	float DamageLuck = (0.1 * (tinker.Luck[0]));
	float AttackspeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.25 + DamageLuck;
			tinker.Value[1] = 1.15 + AttackspeedLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.3 + DamageLuck;
			tinker.Value[1] = 1.2 + AttackspeedLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.4 + DamageLuck;
			tinker.Value[1] = 1.25 + AttackspeedLuck;
		}
	}
}

static void TinkerMeleeLongSwing(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //damage
	tinker.Attrib[1] = 6; //attackspeed
	tinker.Attrib[2] = 4001; //ExtraMeleeRange
	
	float DamageLuck = (0.1 * (tinker.Luck[0]));
	float AttackspeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));
	float ExtraRangeLuck = (0.1 * (tinker.Luck[2]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.10 + DamageLuck;
			tinker.Value[1] = 1.15 + AttackspeedLuck;
			tinker.Value[2] = 1.15 + ExtraRangeLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.15 + DamageLuck;
			tinker.Value[1] = 1.2 + AttackspeedLuck;
			tinker.Value[2] = 1.2 + ExtraRangeLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.20 + DamageLuck;
			tinker.Value[1] = 1.25 + AttackspeedLuck;
			tinker.Value[2] = 1.35 + ExtraRangeLuck;
		}
	}
}

static void TinkerHastyMage(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 6;
	tinker.Attrib[1] = 733;
	float AttackspeedLuck = (0.1 * (tinker.Luck[1]));
	float MageShootExtraCost = (0.15 * (1.0 + (-1.0*(tinker.Luck[1]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 0.8 - AttackspeedLuck;
			tinker.Value[1] = 1.25 + MageShootExtraCost;
		}
		case 1:
		{
			tinker.Value[0] = 0.75 - AttackspeedLuck;
			tinker.Value[1] = 1.35 + MageShootExtraCost;
		}
		case 2:
		{
			tinker.Value[0] = 0.7 - AttackspeedLuck;
			tinker.Value[1] = 1.45 + MageShootExtraCost;
		}
	}
}
static void TinkerHeavyMage(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 6;
	tinker.Attrib[1] = 733;
	tinker.Attrib[2] = 410;
	float AttackspeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));
	float MageShootExtraCost = (0.15 * (1.0 + (-1.0*(tinker.Luck[1]))));
	float DamageLuck = (0.1 * (tinker.Luck[2]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.1 + AttackspeedLuck;
			tinker.Value[1] = 1.55 + MageShootExtraCost;
			tinker.Value[2] = 1.25 + DamageLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.15 + AttackspeedLuck;
			tinker.Value[1] = 1.65 + MageShootExtraCost;
			tinker.Value[2] = 1.3 + DamageLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.2 + AttackspeedLuck;
			tinker.Value[1] = 1.75 + MageShootExtraCost;
			tinker.Value[2] = 1.35 + DamageLuck;
		}
	}
}

static void TinkerConcentrationMage(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 103;
	tinker.Attrib[1] = 410;
	float ProjectileSpeed = (0.1 * (tinker.Luck[0]));
	float DamageLuck = (0.1 * (tinker.Luck[1]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 0.4 + ProjectileSpeed;
			tinker.Value[1] = 1.15 + DamageLuck;
		}
		case 1:
		{
			tinker.Value[0] = 0.45 + ProjectileSpeed;
			tinker.Value[1] = 1.2 + DamageLuck;
		}
		case 2:
		{
			tinker.Value[0] = 0.5 + ProjectileSpeed;
			tinker.Value[1] = 1.25 + DamageLuck;
		}
	}
}


static void TinkerTankMage(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 733;
	tinker.Attrib[1] = 410;
	tinker.Attrib[2] = 205;
	tinker.Attrib[3] = 206;
	float MageShotCost = (0.1 * (1.0 + (-1.0*(tinker.Luck[0]))));
	float DamageLuck = (0.1 * (tinker.Luck[1]));
	float RangedDmgLuck = (0.05 * (tinker.Luck[2]));
	float MeleeDmgLuck = (0.05 * (tinker.Luck[3]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.15 + MageShotCost;
			tinker.Value[1] = 0.95 + DamageLuck;
			tinker.Value[2] = 0.95 - RangedDmgLuck;
			tinker.Value[3] = 0.95 - MeleeDmgLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.2 + MageShotCost;
			tinker.Value[1] = 0.93 + DamageLuck;
			tinker.Value[2] = 0.93 - RangedDmgLuck;
			tinker.Value[3] = 0.93 - MeleeDmgLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.25 + MageShotCost;
			tinker.Value[1] = 0.92 + DamageLuck;
			tinker.Value[2] = 0.9 - RangedDmgLuck;
			tinker.Value[3] = 0.9 - MeleeDmgLuck;
		}
	}
}


static void TinkerMedigun_FastHeal(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 8; //more heal rate
	tinker.Attrib[1] = 10; //Less uber rate
	tinker.Attrib[2] = 4002; //Less Overheal
	float MoreHealRateLuck = (0.1 * (tinker.Luck[0]));
	float LessUberRateLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));
	float LessOverhealRateLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[2]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.15 + MoreHealRateLuck;
			tinker.Value[1] = 0.95 - LessUberRateLuck;
			tinker.Value[2] = 0.95 - LessOverhealRateLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.25 + MoreHealRateLuck;
			tinker.Value[1] = 0.92 - LessUberRateLuck;
			tinker.Value[2] = 0.92 - LessOverhealRateLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.35 + MoreHealRateLuck;
			tinker.Value[1] = 0.88 - LessUberRateLuck;
			tinker.Value[2] = 0.88 - LessOverhealRateLuck;
		}
	}
}
static void TinkerMedigun_Overhealer(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 8;
	tinker.Attrib[1] = 4002; 
	float LessHealRateLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[0]))));
	float MoreOverhealLuck = (0.1 * (tinker.Luck[1]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.05 - LessHealRateLuck;
			tinker.Value[1] = 1.1 + MoreOverhealLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.0 - LessHealRateLuck;
			tinker.Value[1] = 1.15 + MoreOverhealLuck;
		}
		case 2:
		{
			tinker.Value[0] = 0.95 - LessHealRateLuck;
			tinker.Value[1] = 1.15 + MoreOverhealLuck;
		}
	}
}


static void TinkerMedigun_Uberer(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 8;
	tinker.Attrib[1] = 10;
	float LessHealRate = (0.1 * (1.0 + (-1.0*(tinker.Luck[0]))));
	float MoreUberRate = (0.1 * (tinker.Luck[1]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 0.9 - LessHealRate;
			tinker.Value[1] = 1.15 + MoreUberRate;
		}
		case 1:
		{
			tinker.Value[0] = 0.85 - LessHealRate;
			tinker.Value[1] = 1.2 + MoreUberRate;
		}
		case 2:
		{
			tinker.Value[0] = 0.8 - LessHealRate;
			tinker.Value[1] = 1.3 + MoreUberRate;
		}
	}
}


static void TinkerMedicWeapon_GlassyMedic(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 8; //more heal rate
	tinker.Attrib[1] = 6; 
	tinker.Attrib[2] = 205;
	tinker.Attrib[3] = 206;
	float HealRateLuck = (0.1 * (tinker.Luck[0]));
	float AttackRateLuck = (0.1 * (tinker.Luck[1]));
	float RangedDmgVulLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[2]))));
	float MeleeDmgVulLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[3]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.05 + HealRateLuck;
			tinker.Value[1] = 0.9 - AttackRateLuck;
			tinker.Value[2] = 1.05 + RangedDmgVulLuck;
			tinker.Value[3] = 1.05 + MeleeDmgVulLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.1 + HealRateLuck;
			tinker.Value[1] = 0.86 - AttackRateLuck;
			tinker.Value[2] = 1.075 + RangedDmgVulLuck;
			tinker.Value[3] = 1.075 + MeleeDmgVulLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.15 + HealRateLuck;
			tinker.Value[1] = 0.84 - AttackRateLuck;
			tinker.Value[2] = 1.10 + RangedDmgVulLuck;
			tinker.Value[3] = 1.10 + MeleeDmgVulLuck;
		}
	}
}


static void TinkerMedicWeapon_BurstHealMedic(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 8; //more heal rate
	tinker.Attrib[1] = 6; 
	tinker.Attrib[2] = 97; 
	float HealRateLuck = (0.2 * (tinker.Luck[0]));
	float AttackRateLuck = (0.12 * (tinker.Luck[1]));
	float ReloadRateLuck = (0.12 * (tinker.Luck[2]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.75 + HealRateLuck;
			tinker.Value[1] = 1.6 + AttackRateLuck;
			tinker.Value[2] = 1.6 + ReloadRateLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.9 + HealRateLuck;
			tinker.Value[1] = 1.75 + AttackRateLuck;
			tinker.Value[2] = 1.75 + ReloadRateLuck;
		}
		case 2:
		{
			tinker.Value[0] = 2.1 + HealRateLuck;
			tinker.Value[1] = 1.85 + AttackRateLuck;
			tinker.Value[2] = 1.85 + ReloadRateLuck;
		}
	}
}


static void TinkerBuilderLongSwing(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 6; //attackspeed
	tinker.Attrib[1] = 264; //ExtraMeleeRange
	tinker.Attrib[2] = 4001; //ExtraMeleeRange
	
	float AttackspeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[0]))));
	float ExtraRangeLuck = (0.1 * (tinker.Luck[1]));

	tinker.Luck[2] = tinker.Luck[1];

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.25 + AttackspeedLuck;
			tinker.Value[1] = 1.5 + ExtraRangeLuck;
			tinker.Value[2] = 1.5 + ExtraRangeLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.35 + AttackspeedLuck;
			tinker.Value[1] = 1.5 + ExtraRangeLuck;
			tinker.Value[2] = 1.75 + ExtraRangeLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.4 + AttackspeedLuck;
			tinker.Value[1] = 1.5 + ExtraRangeLuck;
			tinker.Value[2] = 2.0 + ExtraRangeLuck;
		}
	}
}


static void TinkerBuilderRepairMaster(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 95; //RepairRate
	tinker.Attrib[1] = 107; //movementspeed
	
	float RepairRate = (0.1 * (tinker.Luck[0]));
	float MovementSpeed = (0.05 * (1.0 + (-1.0*(tinker.Luck[1]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.25 + RepairRate;
			tinker.Value[1] = 0.98 - MovementSpeed;
		}
		case 1:
		{
			tinker.Value[0] = 1.3 + RepairRate;
			tinker.Value[1] = 0.98 - MovementSpeed;
		}
		case 2:
		{
			tinker.Value[0] = 1.4 + RepairRate;
			tinker.Value[1] = 0.98 - MovementSpeed;
		}
	}
}



static void TinkerRangedSlowHeavyProj(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //damage
	tinker.Attrib[1] = 103; //ProjectileSpeed
	tinker.Attrib[2] = 6; //attackspeed
	
	float DamageLuck = (0.1 * (tinker.Luck[0]));
	float ProjectileSpeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));
	float AttackspeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.15 + DamageLuck;
			tinker.Value[1] = 0.7 - ProjectileSpeedLuck;
			tinker.Value[2] = 1.05 + AttackspeedLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.20 + DamageLuck;
			tinker.Value[1] = 0.65 - ProjectileSpeedLuck;
			tinker.Value[2] = 1.1 + AttackspeedLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.3 + DamageLuck;
			tinker.Value[1] = 0.6 - ProjectileSpeedLuck;
			tinker.Value[2] = 1.12 + AttackspeedLuck;
		}
	}
}

static void TinkerRangedFastProj(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //damage
	tinker.Attrib[1] = 103; //ProjectileSpeed
	tinker.Attrib[2] = 6; //attackspeed
	
	float DamageLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[0]))));
	float ProjectileSpeedLuck = (0.1 * (tinker.Luck[1]));
	float AttackspeedLuck = (0.1 * (tinker.Luck[1]));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 0.9 - DamageLuck;
			tinker.Value[1] = 1.35 + ProjectileSpeedLuck;
			tinker.Value[2] = 0.95 - AttackspeedLuck;
		}
		case 1:
		{
			tinker.Value[0] = 0.9 - DamageLuck;
			tinker.Value[1] = 1.5 + ProjectileSpeedLuck;
			tinker.Value[2] = 0.93 - AttackspeedLuck;
		}
		case 2:
		{
			tinker.Value[0] = 0.85 - DamageLuck;
			tinker.Value[1] = 1.65 + ProjectileSpeedLuck;
			tinker.Value[2] = 0.9 - AttackspeedLuck;
		}
	}
}


static void TinkerIntensiveClip(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 6; //attackspeed
	tinker.Attrib[1] = 4; //Clipsize
	tinker.Attrib[2] = 97; //ReloadSpeed
	
	float AttackSpeedLuck = (0.07 * (tinker.Luck[0]));
	float ClipSizeLuck = (0.15 * (tinker.Luck[1]));
	float ReloadSpeedLuck = (0.15 * (1.0 + (-1.0*(tinker.Luck[2]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 0.95 - AttackSpeedLuck;
			tinker.Value[1] = 1.5 + ClipSizeLuck;
			tinker.Value[2] = 1.7 + ReloadSpeedLuck;
		}
		case 1:
		{
			tinker.Value[0] = 0.93 - AttackSpeedLuck;
			tinker.Value[1] = 1.65 + ClipSizeLuck;
			tinker.Value[2] = 1.8 + ReloadSpeedLuck;
		}
		case 2:
		{
			tinker.Value[0] = 0.92 - AttackSpeedLuck;
			tinker.Value[1] = 1.75 + ClipSizeLuck;
			tinker.Value[2] = 1.9 + ReloadSpeedLuck;
		}
	}
}

static void TinkerConcentratedClip(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //Damage
	tinker.Attrib[1] = 97; //ReloadSpeed
	
	float ExtraDamage = (0.1 * (tinker.Luck[0]));
	float ReloadSpeedLuck = (0.2 * (1.0 + (-1.0*(tinker.Luck[1]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.15 + ExtraDamage;
			tinker.Value[1] = 1.35 + ReloadSpeedLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.2 + ExtraDamage;
			tinker.Value[1] = 1.4 + ReloadSpeedLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.25 + ExtraDamage;
			tinker.Value[1] = 1.5 + ReloadSpeedLuck;
		}
	}
}


static void TinkerHeavyTrigger(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //Damage
	tinker.Attrib[1] = 6; //attackspeed
	
	float ExtraDamage = (0.1 * (tinker.Luck[0]));
	float attackspeedSpeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.2 + ExtraDamage;
			tinker.Value[1] = 1.2 + attackspeedSpeedLuck;
		}
		case 1:
		{
			tinker.Value[0] = 1.3 + ExtraDamage;
			tinker.Value[1] = 1.3 + attackspeedSpeedLuck;
		}
		case 2:
		{
			tinker.Value[0] = 1.35 + ExtraDamage;
			tinker.Value[1] = 1.35 + attackspeedSpeedLuck;
		}
	}
}

static void TinkerSprayAndPray(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 45; //BulletsPetShot
	tinker.Attrib[2] = 106; //Accuracy
	
	float BulletPetShotBonus = (0.1 * (tinker.Luck[0]));
	float AccuracySuffering = (0.2 * (1.0 + (-1.0*(tinker.Luck[2]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 1.25 + BulletPetShotBonus;
			tinker.Value[1] = 1.35 + AccuracySuffering;
		}
		case 1:
		{
			tinker.Value[0] = 1.3 + BulletPetShotBonus;
			tinker.Value[1] = 1.40 + AccuracySuffering;
		}
		case 2:
		{
			tinker.Value[0] = 1.35 + BulletPetShotBonus;
			tinker.Value[1] = 1.45 + AccuracySuffering;
		}
	}
}

static void TinkerSmallerSmarterBullets(int rarity, TinkerEnum tinker)
{
	tinker.Attrib[0] = 2; //Less Damage
	tinker.Attrib[1] = 6; //Faster Shooting
	tinker.Attrib[2] = 97; //faster Reload
	
	float DamageLuck = (0.1 * (tinker.Luck[0]));
	float AttackSpeedLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[1]))));
	float FasterReloadLuck = (0.1 * (1.0 + (-1.0*(tinker.Luck[2]))));

	switch(rarity)
	{
		case 0:
		{
			tinker.Value[0] = 0.85 + DamageLuck;
			tinker.Value[1] = 0.8 + AttackSpeedLuck;
			tinker.Value[2] = 0.8 + FasterReloadLuck;
		}
		case 1:
		{
			tinker.Value[0] = 0.8 + DamageLuck;
			tinker.Value[1] = 0.7 + AttackSpeedLuck;
			tinker.Value[2] = 0.7 + FasterReloadLuck;
		}
		case 2:
		{
			tinker.Value[0] = 0.7 + DamageLuck;
			tinker.Value[1] = 0.6 + AttackSpeedLuck;
			tinker.Value[2] = 0.6 + FasterReloadLuck;
		}
	}
}