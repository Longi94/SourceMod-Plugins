#include <sourcemod>

#define PLUGIN_VERSION "1.0"
#define HAMMER_TO_KILOMETER 0.0686
#define HAMMER_TO_MILES 0.0426

float prevSpeed = 0.0;
float currSpeed = 0.0;

int prevDefl = 0;
int currDefl = 0;

// Plugin definitions
public Plugin myinfo =
{
	name = "Dodgeball Speed Announcer",
	author = "klay",
	description = "You know what this is.",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
    RegServerCmd("tf_db_announce_death", DeathAnnounce);
    RegServerCmd("tf_db_new_rocket", NewRocket);
    RegServerCmd("tf_db_on_deflect", OnDeflect);
}

public Action:NewRocket(args)
{
    if (args != 2)
    {
        PrintToServer("Usage: tf_db_new_rocket @speed @deflections");
        return Plugin_Handled;
    }
    
    new String:strBuffer[32];
    
    prevSpeed = currSpeed;
    prevDefl = currDefl;
   
    GetCmdArg(1, strBuffer, sizeof(strBuffer));
    currSpeed = StringToFloat(strBuffer);
    
    GetCmdArg(2, strBuffer, sizeof(strBuffer)); 
    currDefl = StringToInt(strBuffer, 10);
    
    PrintSpeedHint();

    return Plugin_Handled;
}

public Action:OnDeflect(args)
{
    if (args != 2)
    {
        PrintToServer("Usage: tf_db_on_deflect @speed @deflections");
        return Plugin_Handled;
    }
    
    new String:strBuffer[32];
   
    GetCmdArg(1, strBuffer, sizeof(strBuffer));
    currSpeed = StringToFloat(strBuffer);
    
    GetCmdArg(2, strBuffer, sizeof(strBuffer)); 
    currDefl = StringToInt(strBuffer, 10);
    
    PrintSpeedHint();
    
    return Plugin_Handled;
}

void PrintSpeedHint()
{
    new speedHammer = RoundToNearest(currSpeed);
    new speedMph = RoundToNearest(currSpeed * HAMMER_TO_MILES);

    new speedHammerPrev = RoundToNearest(prevSpeed);
    new speedMphPrev = RoundToNearest(prevSpeed * HAMMER_TO_MILES);

    PrintHintTextToAll("Current: %d mph (%d), %d deflects\nPrevious: %d mph (%d), %d deflects", 
        speedMph, speedHammer, currDefl, speedMphPrev, speedHammerPrev, prevDefl);
}

public Action:DeathAnnounce(args)
{
    if (args != 3)
    {
        PrintToServer("Usage: tf_db_announce_death @dead @speed @deflections");
        return Plugin_Handled;
    }
    
    new String:strBuffer[32];
    
    GetCmdArg(1, strBuffer, sizeof(strBuffer)); 
    new dead = StringToInt(strBuffer, 10);
    
    GetCmdArg(2, strBuffer, sizeof(strBuffer));
    new Float:speed = StringToFloat(strBuffer);
    new speedHammer = RoundToNearest(speed);
    new speedMph = RoundToNearest(speed * HAMMER_TO_MILES);
    
    GetCmdArg(3, strBuffer, sizeof(strBuffer)); 
    new deflections = StringToInt(strBuffer, 10);
    
    return AnnounceToAll(dead, speedHammer, speedMph, deflections);
}

public Action:AnnounceToAll(dead, speedHammer, speedMph, deflections)
{
	new String:strDeadName[MAX_NAME_LENGTH], String:strDeadColour[32];
	GetClientName(dead, strDeadName, sizeof(strDeadName));
	FindTeamColour(dead, strDeadColour, sizeof(strDeadColour));
	
	PrintToChatAll("%s%s \x07FFFFFFwas killed by a rocket travelling at \x070FFF0F%d mph \x07FFFFFF(\x070FFF0F%d\x07FFFFFF) after \x070FFF0F%d \x07FFFFFFdeflects!",
        strDeadColour, strDeadName, speedMph, speedHammer, deflections);
	return Plugin_Handled;
}

stock FindTeamColour(client, String:strBuffer[], MaxLength)
{
	switch (GetClientTeam(client))
	{
		case 0: Format(strBuffer, MaxLength, "\0x7FFFFFF");
		case 2: Format(strBuffer, MaxLength, "\x07B8383B");
		case 3: Format(strBuffer, MaxLength, "\x075885A2");
		default: Format(strBuffer, MaxLength, "\x07FFFFFF");
	}
}