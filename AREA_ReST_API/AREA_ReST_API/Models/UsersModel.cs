using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace AREA_ReST_API.Models;

public class UsersModel
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)] public int Id { get; set; }
    [Required] public required string Username { get; set; }
    [Required] public required string Email { get; set; }
    [Required] public required string Password { get; set; }
    [Required] public required bool Admin { get; set; }
}