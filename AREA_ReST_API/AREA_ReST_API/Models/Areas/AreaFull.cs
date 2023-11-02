using System.ComponentModel.DataAnnotations;

namespace AREA_ReST_API.Models;

public class AreaFull
{
    public int Id { get; set; }
    [Required] public required int UserId { get; set; }
    [Required] public required string Name { get; set; }
    [Required] public required bool Favorite { get; set; }
    [Required] public UserActionWithActionModel? UserAction { get; set; } = null!;
    [Required] public List<UserReactionWithReactionModel> UserReactions { get; set; } = null!;
}