using System.Net.Http.Headers;
using AREA_ReST_API.Models;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class XIVService : IService
{
    public override async Task<bool> ActionSelectorWithoutUserService(UserActionsModel userAction, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        Console.WriteLine(action.Name);
        return action.Name switch
        {
            "Get Character Level" => await GetCharacterLevel(userAction),
            _ => false
        };
    }

    private async Task<bool> GetCharacterLevel(UserActionsModel userAction)
    {
        var client = new HttpClient();
        const string uri = "https://xivapi.com/character/search?";
        var config = JObject.Parse(userAction.Configuration);
        var queryParameters = $"name={config["name"]!}&server={config["server"]}";
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri + queryParameters);

        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
        var characterId = (int)json["Results"]![0]!["ID"]!;
        requestMessage = new HttpRequestMessage(HttpMethod.Get, $"https://xivapi.com/character/{characterId}");
        response = await client.SendAsync(requestMessage);
        json = JObject.Parse(await response.Content.ReadAsStringAsync());
        return (int)config["targeted_level"]! == (int)json["Character"]!["ActiveClassJob"]!["Level"]!;
    }
}