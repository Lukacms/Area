using System.Net.Http.Headers;
using AREA_ReST_API.Models;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class WeatherService : IService
{
    public override async Task<bool> ActionSelectorWithoutUserService(UserActionsModel userAction, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        return action.Name switch
        {
            "Get Current Temperature" => await GetCurrentTemperature(userAction),
            _ => false
        };
    }

    private async Task<bool> GetCurrentTemperature(UserActionsModel userAction)
    {
        var client = new HttpClient();
        const string uri = "https://api.openweathermap.org/data/2.5/weather";
        var config = JObject.Parse(userAction.Configuration);
        var queryParameters = $"?q={config["city"]!}&appid=f4b50a2c4b2cc946e56c066d56df50bf&units=metric";
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri + queryParameters);

        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
        var min = (int)config["min_temperature"]!;
        var max = (int)config["max_temperature"]!;
        var currentTemp = (int)json["main"]!["temp"]!;
        return currentTemp > min && currentTemp < max;
    }
}