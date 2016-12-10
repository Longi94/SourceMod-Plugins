#include <sourcemod>

#define PLUGIN_VERSION "1.0"

// Plugin definitions
public Plugin myinfo =
{
    name = "Hugs and kisses",
    author = "klay",
    description = "Simple replica of the hug and kiss commands from the Panda servers",
    version = PLUGIN_VERSION,
    url = ""
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_hug", Hug);
    RegConsoleCmd("sm_kiss", Kiss);
}

public Action Hug(int client, int args)
{
    if (args < 1)
    {
        PrintToChat(client, "[SM] Usage: sm_hug <name>");
        return Plugin_Handled;
    }

    new String:nameStr[MAX_NAME_LENGTH];
    new String:otherName[MAX_NAME_LENGTH];
    char param[32];
    int count = 0;
    int target = -1;
    
    GetClientName(client, nameStr, MAX_NAME_LENGTH);

    GetCmdArg(1, param, sizeof(param));
 
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientConnected(i))
        {
            continue;
        }
        GetClientName(i, otherName, MAX_NAME_LENGTH);
        if (StrContains(otherName, param, false) > -1)
        {
            target = i;
            count++;
        }
    }
 
    if (count == 0)
    {
        PrintToChat(client, "[SM] Could not find any player with the name: \"%s\"", param);
        return Plugin_Handled;
    } else if (count > 1) {
        PrintToChat(client, "[SM] More than one matching clients found!");
        return Plugin_Handled;
    }
 
    GetClientName(target, otherName, MAX_NAME_LENGTH);
    PrintToChatAll("\x07FF00BF%s hugged %s!", nameStr, otherName);
 
    return Plugin_Handled;
}

public Action Kiss(int client, int args)
{
if (args < 1)
    {
        PrintToChat(client, "[SM] Usage: sm_hug <name>");
        return Plugin_Handled;
    }

    new String:nameStr[MAX_NAME_LENGTH];
    new String:otherName[MAX_NAME_LENGTH];
    char param[32];
    int count = 0;
    int target = -1;
    
    GetClientName(client, nameStr, MAX_NAME_LENGTH);

    GetCmdArg(1, param, sizeof(param));
 
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientConnected(i))
        {
            continue;
        }
        GetClientName(i, otherName, MAX_NAME_LENGTH);
        if (StrContains(otherName, param, false) > -1)
        {
            target = i;
            count++;
        }
    }
 
    if (count == 0)
    {
        PrintToChat(client, "[SM] Could not find any player with the name: \"%s\"", param);
        return Plugin_Handled;
    } else if (count > 1) {
        PrintToChat(client, "[SM] More than one matching clients found!");
        return Plugin_Handled;
    }
 
    GetClientName(target, otherName, MAX_NAME_LENGTH);
    PrintToChatAll("\x07CC0000%s kissed %s!", nameStr, otherName);
 
    return Plugin_Handled;
}