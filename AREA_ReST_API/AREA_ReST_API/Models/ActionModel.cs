using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class ActionModel
{
    [Required]
    public required int Id { get; set; }
    
    [Required]
    public required int Service { get; set; }
    
    [Required]
    public required string Token { get; set; }

    [Required]
    public required string Endpoint { get; set; }
    
    [Required]
    public required int Refresh { get; set; }
}