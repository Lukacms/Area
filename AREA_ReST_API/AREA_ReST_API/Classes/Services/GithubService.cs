using System.Net.Http.Headers;
using AREA_ReST_API.Models;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class GithubService : IService
{
    public override async Task<bool> ActionSelector(UserActionsModel userAction, UserServicesModel userService, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        return action.Name switch
        {
            // "Get Recent Mail" => await GetRecentMail(userAction, userService),
            // "Get Calendar" => await GetFollowerAndCompare(userAction, userService),
            _ => false
        };
    }

    public override async Task ReactionSelector(UserReactionsModel userReaction, UserServicesModel userService, AppDbContext context)
    {
        var reaction = context.Reactions.First(r => r.Id == userReaction.ReactionId);
        Console.WriteLine($"GITHUB IN : {reaction.Name}");
        switch (reaction.Name)
        {
            case "Fork A Repository":
                await ForkRepository(userReaction, userService);
                break;
            case "Delete A Repository":
                await DeleteRepository(userReaction, userService);
                break;
        }
    }

    public override async Task RefreshToken(UserServicesModel userService, AppDbContext context)
    {
        const string uri = "https://github.com/login/oauth/access_token";
        var query = $"?client_id=Iv1.f47bfd491f94b532&client_secret=c8f7c650f3d4c47462ddbf0ca06b1113478c9f6e&grant_type=refresh_token&refresh_token={userService.RefreshToken}";
        var client = new HttpClient();
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri + query);
        requestMessage.Headers.Add("Accept", "application/json");
        var response = await client.SendAsync(requestMessage);
        var responseText = await response.Content.ReadAsStringAsync();
        var responseJson = JObject.Parse(responseText);

        userService.AccessToken = responseJson["access_token"]!.ToString();
        userService.RefreshToken = responseJson["refresh_token"]!.ToString();
        userService.ExpiresIn = (int)responseJson["expires_in"]!;
        context.UserServices.Update(userService);
        await context.SaveChangesAsync();
    }

    private async Task ForkRepository(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://api.github.com/repos/";

        var config = JObject.Parse(userReaction.Configuration);
        uri += config["owner"]! + "/" + config["repo"]! + "/forks";
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);
        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        requestMessage.Headers.UserAgent.Add(new ProductInfoHeaderValue("Area", "1.0"));
        var response = await client.SendAsync(requestMessage);
        var content = await response.Content.ReadAsStringAsync();
        var responseJson = JObject.Parse(await response.Content.ReadAsStringAsync());
    }

    private async Task DeleteRepository(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://api.github.com/repos/";

        var config = JObject.Parse(userReaction.Configuration);
        uri += config["owner"]! + "/" + config["repo"]!;
        var requestMessage = new HttpRequestMessage(HttpMethod.Delete, uri);
        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        requestMessage.Headers.UserAgent.Add(new ProductInfoHeaderValue("Area", "1.0"));

        await client.SendAsync(requestMessage);
    }
}