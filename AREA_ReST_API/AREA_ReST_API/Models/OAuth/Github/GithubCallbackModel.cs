namespace AREA_ReST_API.Models.OAuth.Github;

public class GithubCallbackModel
{
    public required string AccessToken { get; set; }
    public required string TokenType { get; set; }
    public required int ExpiresIn { get; set; }
    public required string RefreshToken { get; set; }
    public required string Scope { get; set; }
}
