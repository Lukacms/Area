using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AREA_ReST_API.Models;

public class UserServicesModel
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)] public int Id { get; set; }
    [Required] public required int ServiceId { get; set; }
    [Required] public required int UserId { get; set; }
    [Required] public required string AccessToken { get; set; }
    [Required] public required string RefreshToken { get; set; }
}