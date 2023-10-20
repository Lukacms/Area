using System.Net.Http.Headers;
using AREA_ReST_API.Models;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class WeatherService : IService
{
    public override async Task<bool> ActionSelector(UserActionsModel userAction, UserServicesModel userService, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        return action.Name switch
        {
            "Get Current Temperature" => await GetCurrentTemperature(userAction, userService),
            _ => false
        };
    }

    public override async Task ReactionSelector(UserReactionsModel userReaction, UserServicesModel userService, AppDbContext context)
    {
    }

    private async Task<bool> GetCurrentTemperature(UserActionsModel userAction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.openweathermap.org/data/2.5/weather";
        var config = JObject.Parse(userAction.Configuration);
        var queryParameters = $"q={config["city"]!}&appid=f4b50a2c4b2cc946e56c066d56df50bf&units=metric";
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri + Uri.EscapeDataString(queryParameters));

        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
        return json["main"]!["temp"]! == config["temp"];
    }
}