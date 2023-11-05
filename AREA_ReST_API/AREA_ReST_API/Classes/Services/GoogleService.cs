using System.Net.Http.Headers;
using System.Runtime.InteropServices.JavaScript;
using AREA_ReST_API.Models;
using Newtonsoft.Json;
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
        var reaction = context.Reactions.First(r => r.Id == userReaction.ReactionId);
        switch (reaction.Name)
        {
            case "Send Mail":
                await SendMail(userReaction, userService);
                break;
            case "Create Draft":
                await CreateDraft(userReaction, userService);
                break;
        }
    }

    public override async Task RefreshToken(UserServicesModel userService, AppDbContext context)
    {
        const string uri = "https://oauth2.googleapis.com/token";
        var client = new HttpService();
        var data = new Dictionary<string, string>
        {
            { "client_id", "315267877885-2np97bt3qq9s6er73549ldrfme2b67pi.apps.googleusercontent.com" },
            { "client_secret", "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" },
            { "refresh_token", userService.RefreshToken},
            { "grant_type", "refresh_token" },
        };
        var result = await client.PostAsync(uri, data, "application/x-www-forms-urlencoded", "");
        Console.WriteLine(result);
        var jsonRes = JObject.Parse(result);
        userService.AccessToken = jsonRes["access_token"]!.ToString();
        userService.ExpiresIn = (int)jsonRes["expires_in"]!;
        context.UserServices.Update(userService);
        await context.SaveChangesAsync();
    }

    private async Task<bool> GetRecentMail(UserActionsModel userAction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var epochTime = DateTimeOffset.Now.ToUnixTimeSeconds();
        var modifiedEpoch = DateTimeOffset.FromUnixTimeSeconds(epochTime).AddSeconds(-1 * userAction.Timer)
            .ToUnixTimeSeconds();
        const string uri = "https://gmail.googleapis.com/gmail/v1/users/me/messages?q=";
        string queryParameters = $"after:{modifiedEpoch}";
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri + Uri.EscapeDataString(queryParameters));

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
        return (int)json["resultSizeEstimate"]! != 0;
    }

    private async Task SendMail(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://gmail.googleapis.com/gmail/v1/users/me/messages/send";

        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);
        var mailToSend = CreateMail(userReaction);
        requestMessage.Content = JsonContent.Create(new { raw = mailToSend });
        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
    }

    private async Task CreateDraft(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://gmail.googleapis.com/gmail/v1/users/me/drafts";

        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);
        var draftToCreate = CreateMail(userReaction);
        var content = new { message = new { raw = draftToCreate } };
        requestMessage.Content = new StringContent(JsonConvert.SerializeObject(content));
        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);
        var response = await client.SendAsync(requestMessage);
        var json = JObject.Parse(await response.Content.ReadAsStringAsync());
        Console.WriteLine(json);
    }

    private string CreateMail(UserReactionsModel userReaction)
    {
        var json = JObject.Parse(userReaction.Configuration);
        var receiver = $"To: <{json["receiver"]!}>\n";
        var subject = $"Subject: {json["subject"]!}\n";
        var body = json["body"]!.ToString();
        var textByte = System.Text.Encoding.UTF8.GetBytes($"{receiver}{subject}\n\r{body}");

        return Convert.ToBase64String(textByte);
    }
}