using System.Net;
using System.Text;

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

    public async Task<string> PostAsync(string uri, string data, string contentType)
    {
        using var content = new StringContent(data, Encoding.UTF8, contentType);

        var request = new HttpRequestMessage
        {
            Content = content,
            Method = HttpMethod.Post,
            RequestUri = new Uri(uri)
        };
        using var response = await _client.SendAsync(request);

        return await response.Content.ReadAsStringAsync();
    }
}