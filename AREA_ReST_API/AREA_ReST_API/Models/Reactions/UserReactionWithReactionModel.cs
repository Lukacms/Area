using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AREA_ReST_API.Models;

public class UserReactionWithReactionModel
{
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)] public int Id { get; set; }

    [Required] public required ReactionsModel Reaction { get; set; }
    [Required] public required int AreaId { get; set; }
    [Required] public required string Configuration { get; set; }
}