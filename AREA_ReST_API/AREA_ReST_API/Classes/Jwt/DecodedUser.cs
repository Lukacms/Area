namespace AREA_ReST_API.Classes.Jwt;

public class DecodedUser
{
    public required int Id { get; set; }
    public required string Username { get; set; }
    public required string Email { get; set; }
    public required bool Admin { get; set; }
}