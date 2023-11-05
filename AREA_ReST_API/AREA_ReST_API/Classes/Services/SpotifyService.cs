using System.Net.Http.Headers;
using AREA_ReST_API.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class SpotifyService : IService
{

    public override async Task<bool> ActionSelector(UserActionsModel userAction, UserServicesModel userService, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        Console.WriteLine(action.Name);
        return action.Name switch
        {
            "Get Playing Device" => await GetPlayingDevice(userAction, userService),
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

    public override async Task RefreshToken(UserServicesModel userService, AppDbContext context)
    {
        const string uri = "https://accounts.spotify.com/api/token";
        var authentication = $"834ee184a29945b2a2a3dc8108a5bbf4:b589f784bb3f4b3897337acbfdd80f0d";
        var base64str = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(authentication));
        var client = new HttpService();
        var data = new Dictionary<string, string>
        {
            { "refresh_token", userService.RefreshToken },
            { "grant_type", "refresh_token" },
        };
        var result = await client.PostAsync(uri, data, "application/x-www-forms-urlencoded", base64str);
        Console.WriteLine(result);
        var jsonRes = JObject.Parse(result);
        userService.AccessToken = jsonRes["access_token"]!.ToString();
        userService.ExpiresIn = (int)jsonRes["expires_in"]!;
        context.UserServices.Update(userService);
        await context.SaveChangesAsync();
    }

    private async Task<bool> GetCurrentTrackAndCompare(UserActionsModel userAction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.spotify.com/v1/me/player/currently-playing";
        var config = JObject.Parse(userAction.Configuration);
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);

        var response = await client.SendAsync(requestMessage);
        Console.WriteLine(await response.Content.ReadAsStringAsync());
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

    private async Task<bool> GetPlayingDevice(UserActionsModel userAction, UserServicesModel userService)
    {
        var client = new HttpClient();
        const string uri = "https://api.spotify.com/v1/me/player";
        var config = JObject.Parse(userAction.Configuration);
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);

        var response = await client.SendAsync(requestMessage);
        var responseContent = await response.Content.ReadAsStringAsync();
        var responseJson = JObject.Parse(responseContent);
        return string.Equals(responseJson["device"]!["name"]!.ToString(), config["target_device"]!.ToString());
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