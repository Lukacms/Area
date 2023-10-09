using System.Net;
using System.Net.Http.Headers;

namespace AREA_ReST_API.Classes;

public class HttpService
{
    private readonly HttpClient _client;

    public HttpService()
    {
        var handler = new HttpClientHandler
        {
            AutomaticDecompression = DecompressionMethods.All
        };
        _client = new HttpClient();
    }

    public async Task<string> GetAsync(string uri)
    {
        using var response = await _client.GetAsync(uri);

        return await response.Content.ReadAsStringAsync();
    }

    public async Task<string> PostAsync(string uri, Dictionary<string, string> data, string contentType, string authentication)
    {
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);

        if (authentication.Length > 0)
            requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Basic", authentication);
        requestMessage.Content = new FormUrlEncodedContent(data);
        var response = await _client.SendAsync(requestMessage);
        return await response.Content.ReadAsStringAsync();
    }
}