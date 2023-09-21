namespace AREA_ReST_API.Classes.Jwt;

public class JwtOptions
{
    public string Issuer { get; set; }
    public string Audience { get; set; }
    public string SigningKey { get; set; }
    public double ExpirationSeconds { get; set; }
}