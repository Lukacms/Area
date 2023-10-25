using System.Net;
using System.Net.Http.Headers;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using HttpContent = System.Net.Http.HttpContent;

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

    public async Task<string> PostAsync(string uri, Dictionary<string, string> data, string contentType, string? authentication)
    {
        var requestMessage = new HttpRequestMessage(HttpMethod.Post, uri);

        if (!authentication.IsNullOrEmpty())
            requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Basic", authentication);
        requestMessage.Content = new FormUrlEncodedContent(data);
        var response = await _client.SendAsync(requestMessage);
        return await response.Content.ReadAsStringAsync();
    }

    public async Task<string> PostWithQueryAsync(string url, string query, string contentType, string accept)
    {
      var request = new HttpRequestMessage(HttpMethod.Post, url + query);

      if (accept.Length > 0)
          request.Headers.Add("Accept", accept);
      request.Content = new StringContent(query, Encoding.UTF8, contentType);
      Console.WriteLine(request);
      var response = await _client.SendAsync(request);
      return await response.Content.ReadAsStringAsync();
    }

    public async Task<string> GetWithQueryAsync(string url, string query, string contentType, string accept)
    {
      var request = new HttpRequestMessage(HttpMethod.Get, url + query);

      if (accept.Length > 0)
          request.Headers.Add("Accept", accept);
      if (contentType.Length > 0)
          request.Content = new StringContent(query, Encoding.UTF8, contentType);
      var response = await _client.SendAsync(request);
      return await response.Content.ReadAsStringAsync();
    }
    public async Task<string> GetAsyncAuth(string uri, Dictionary<string, string>? data, string contentType, string? authentication)
    {
        var requestMessage = new HttpRequestMessage(HttpMethod.Get, uri);

        if (!authentication.IsNullOrEmpty())
            requestMessage.Headers.Authorization = new AuthenticationHeaderValue("Bearer", authentication);
        if (data != null)
            requestMessage.Content = new FormUrlEncodedContent(data);
        var response = await _client.SendAsync(requestMessage);
        return await response.Content.ReadAsStringAsync();
    }

}
