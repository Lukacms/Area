using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class ReactionModel
{
    [Required]
    public int Id { get; set; }
    
    [Required]
    public int Service { get; set; }
    
    [Required]
    public required string Token { get; set; }
    
    [Required]
    public required string Endpoint { get; set; }
}