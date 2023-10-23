using System.Net.Http.Headers;
using AREA_ReST_API.Models;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class SpotifyService : IService
{

    public override async Task<bool> ActionSelector(UserActionsModel userAction, UserServicesModel userService, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        return action.Name switch
        {
            "Get Current Track" => await GetCurrentTrackAndCompare(userAction, userService),
            "Get Followers" => await GetFollowerAndCompare(userAction, userService),
            _ => false
        };
    }

    public override async Task ReactionSelector(UserReactionsModel userReaction, UserServicesModel userService, AppDbContext context)
    {
        var reaction = context.Reactions.First(r => r.Id == userReaction.ReactionId);
        switch (reaction.Name)
        {
            case "Next Music":
                await ToNextMusic(userReaction, userService);
                break;
            case "Previous Music":
                await ToPreviousMusic(userReaction, userService);
                break;
            case "Pause Music":
                await PauseMusic(userReaction, userService);
                break;
        }
    }

    private async Task<bool> GetCurrentTrackAndCompare(UserActionsModel userAction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.spotify.com/v1/me/player/currently-playing";
        var config = JObject.Parse(userAction.Configuration);
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);

        var response = await client.SendAsync(requestMessage);
        var responseJson = JObject.Parse(await response.Content.ReadAsStringAsync());
        var currentTrack = responseJson["item"]!["name"]!.ToString().ToUpper();
        var seekedTrack = config["track_name"]!.ToString().ToUpper();
        return currentTrack.Contains(seekedTrack);
    }

    private async Task<bool> GetFollowerAndCompare(UserActionsModel userAction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.spotify.com/v1/me";
        var config = JObject.Parse(userAction.Configuration);
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);

        var response = await client.SendAsync(requestMessage);
        var responseContent = await response.Content.ReadAsStringAsync();
        var responseJson = JObject.Parse(responseContent);
        return (int)responseJson["followers"]!["total"]! == (int)config["followers"]!;
    }

    private async Task ToNextMusic(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.spotify.com/v1/me/player/next";
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        var response = await client.SendAsync(requestMessage);
    }

    private async Task ToPreviousMusic(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.spotify.com/v1/me/player/previous";
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        var response = await client.SendAsync(requestMessage);
    }

    private async Task PauseMusic(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.spotify.com/v1/me/player/pause";
        var requestMessage = new HttpRequestMessage(HttpMethod.Put, uri);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        var response = await client.SendAsync(requestMessage);
    }
}