using System.ComponentModel.DataAnnotations.Schema;

namespace AREA_ReST_API.Models;

public class UsersModel
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)] public int Id { get; set; }
    public string? Username { get; set; }
    public string? Email { get; set; }
    public string? Name { get; set; }
    public string? Surname { get; set; }
    public string? Password { get; set; }
    public bool Admin { get; set; }
    public bool IsGoogleConnected { get; set; } = false;
    public bool IsMailVerified { get; set; } = false;
}
