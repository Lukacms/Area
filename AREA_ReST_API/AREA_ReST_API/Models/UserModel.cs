using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class UserModel
{
    [Required] public int Id { get; set; }
    [Required] public required string Username { get; set; }
    [Required] public required string Password { get; set; }
    [Required] public required string Email { get; set; }
    [Required] public bool Admin { get; set; }
    public ICollection<AreaModel>? Areas { get; set; }
}