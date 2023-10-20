using System.Runtime.InteropServices.JavaScript;
using AREA_ReST_API.Models;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class GoogleService : IService
{
    public override async Task<bool> ActionSelector(UserActionsModel userAction, UserServicesModel userService, AppDbContext context)
    {
        var action = context.Actions.First(a => a.Id == userAction.ActionId);
        return action.Name switch
        {
            "Get Recent Mail" => await GetRecentMail(userAction, userService),
            // "Get Calendar" => await GetFollowerAndCompare(userAction, userService),
            _ => false
        };
    }

    public override async Task ReactionSelector(UserReactionsModel userReaction, UserServicesModel userService, AppDbContext context)
    {
        var reaction = context.Reactions.First(r => r.Id == userReaction.Id);
        switch (reaction.Name)
        {
            case "Send Mail":
                await SendMail(userReaction, userService);
                break;
        }
    }

    private async Task<bool> GetRecentMail(UserActionsModel userAction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var epochTime = DateTimeOffset.Now.ToUnixTimeSeconds();
        var modifiedEpoch = DateTimeOffset.FromUnixTimeSeconds(epochTime).AddSeconds(-1 * userAction.Timer)
            .ToUnixTimeSeconds();
        const string uri = "https://gmail.googleapis.com/gmail/v1/users/me/messages?";
        string queryParameters = $"q=after:1697533317";
        var config = JObject.Parse(userAction.Configuration);
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri + Uri.EscapeDataString(queryParameters));

        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
        return (int)json["resultSizeEstimate"]! != 0;
    }

    private async Task SendMail(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://gmail.googleapis.com/gmail/v1/users/me/messages/send";

        var config = JObject.Parse(userReaction.Configuration);
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri);
        var mailToSend = CreateMail(userReaction);
        requestMessage.Content = JsonContent.Create(new { raw = mailToSend });
        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
    }

    private string CreateMail(UserReactionsModel userReaction)
    {
        var json = JObject.Parse(userReaction.Configuration);
        var receiver = $"To: <{json["Receiver"]!}>\n";
        var subject = $"Subject: {json["Subject"]!}\n";
        var body = json["Body"]!.ToString();
        var textByte = System.Text.Encoding.UTF8.GetBytes($"{receiver}{subject}{body}");

        return Convert.ToBase64String(textByte);
    }
}