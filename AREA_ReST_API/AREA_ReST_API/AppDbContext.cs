using AREA_ReST_API.Models;
using Microsoft.EntityFrameworkCore;

namespace AREA_ReST_API;
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }


    public virtual DbSet<UsersModel> Users { get; set; }
    public virtual DbSet<UserServicesModel> UserServices { get; set; }
    public virtual DbSet<ServicesModel> Services { get; set; }
    public virtual DbSet<AreasModel> Areas { get; set; }
    public virtual DbSet<UserActionsModel> UserActions { get; set; }
    public virtual DbSet<ActionsModel> Actions { get; set; }
    public virtual DbSet<UserReactionsModel> UserReactions { get; set; }
    public virtual DbSet<ReactionsModel> Reactions { get; set; }
}