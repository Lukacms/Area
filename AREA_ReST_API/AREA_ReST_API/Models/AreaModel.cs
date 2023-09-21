using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class AreaModel
{
    [Required]
    public required int Id { get; set; }
    
    [Required]
    public required int User { get; set; }

    [Required]
    public required ActionModel Action { get; set; }
    
    [Required]
    public required ICollection<ReactionModel> Reaction { get; set; }
}