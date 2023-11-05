using System.Net.Http.Headers;
using System.Text;
using AREA_ReST_API.Models;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Classes.Services;

public class MicrosoftService : IService
{
    public override Task<bool> ActionSelector(UserActionsModel userAction, UserServicesModel userService, AppDbContext context)
    {
        return Task.FromResult(false);
    }

    public override async Task ReactionSelector(UserReactionsModel userReaction, UserServicesModel userService, AppDbContext context)
    {
        var reaction = context.Reactions.First(r => r.Id == userReaction.ReactionId);
        switch (reaction.Name)
        {
            case "Send Mail":
                await SendMail(userReaction, userService);
                break;
            case "Create Notebook":
                await CreateNotebook(userReaction, userService);
                break;
            case "Create Draft":
                await CreateDraft(userReaction, userService);
                break;
        }
    }

    private async Task SendMail(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://graph.microsoft.com/v1.0/me/sendMail";
        var createdMail = CreateMail(userReaction);

        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);
        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);

        requestMessage.Content = new StringContent(createdMail, Encoding.UTF8,"text/plain");
        var response = await client.SendAsync(requestMessage);
    }

    private async Task CreateDraft(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://graph.microsoft.com/v1.0/me/messages";
        var createdDraft = CreateMail(userReaction);

        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);
        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);

        requestMessage.Content = new StringContent(createdDraft, Encoding.UTF8,"text/plain");
        var response = await client.SendAsync(requestMessage);
    }

    private async Task CreateNotebook(UserReactionsModel userReaction, UserServicesModel userService)
    {
        var client = new HttpClient();
        var uri = "https://graph.microsoft.com/v1.0/me/onenote/notebooks";
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);
        var config = JObject.Parse(userReaction.Configuration);

        requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", userService.AccessToken);

        var content = "{displayName: \"" + config["name"]!.ToString() + "\"}";
        requestMessage.Content = new StringContent(content, Encoding.UTF8,"application/json");
        var response = await client.SendAsync(requestMessage);
    }

    public override async Task RefreshToken(UserServicesModel userService, AppDbContext context)
    {
        const string uri = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
        var client = new HttpService();
        var data = new Dictionary<string, string>
        {
            { "client_id", "5731d8cc-7d4b-47dc-812f-f4615f65b38d" },
            { "refresh_token", userService.RefreshToken },
            { "grant_type", "refresh_token" },
            { "client_secret", "eHV8Q~MgohheH_~OxgTyRgbht8RvdEIZ5MkWQc50" }
        };
        var result = await client.PostAsync(uri, data, "application/x-www-forms-urlencoded", "");
        Console.WriteLine(result);
        var jsonRes = JObject.Parse(result);

        userService.AccessToken = jsonRes["access_token"]!.ToString();
        userService.RefreshToken = jsonRes["refresh_token"]!.ToString();
        userService.ExpiresIn = (int)jsonRes["expires_in"]!;
        context.UserServices.Update(userService);
        await context.SaveChangesAsync();
    }

    private string CreateMail(UserReactionsModel userReaction)
    {
        var config = JObject.Parse(userReaction.Configuration);
        var receiver = $"To: <{config["receiver"]!}>\n";
        var subject = $"Subject: {config["subject"]!}\n";
        var body = config["body"]!.ToString();

        var textByte = System.Text.Encoding.UTF8.GetBytes($"{receiver}{subject}\n\r{body}");
        return Convert.ToBase64String(textByte);
    }
}