using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class AreaModel
{
    [Required] public required int Id { get; set; }
    [Required] public required string Name { get; set; }
    [Required] public required bool Favorite { get; set; }
    [Required] public required int User { get; set; }
    [Required] public required ICollection<ActionModel> Action { get; set; }
    [Required] public required ICollection<ReactionModel> Reaction { get; set; }
}