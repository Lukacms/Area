using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class AreaWithActionReaction
{
    public int Id { get; set; }
    [Required] public required int UserId { get; set; }
    [Required] public required string Name { get; set; }
    [Required] public required bool Favorite { get; set; }
    [Required] public UserActionsModel UserAction { get; set; } = null!;
    [Required] public List<UserReactionsModel> UserReactions { get; set; } = null!;
}