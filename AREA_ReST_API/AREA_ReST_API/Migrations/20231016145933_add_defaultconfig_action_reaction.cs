using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AREA_ReST_API.Migrations
{
    /// <inheritdoc />
    public partial class add_defaultconfig_action_reaction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DefaultConfiguration",
                table: "Reactions",
                type: "longtext",
                nullable: false)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<string>(
                name: "DefaultConfiguration",
                table: "Actions",
                type: "longtext",
                nullable: false)
                .Annotation("MySql:CharSet", "utf8mb4");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DefaultConfiguration",
                table: "Reactions");

            migrationBuilder.DropColumn(
                name: "DefaultConfiguration",
                table: "Actions");
        }
    }
}
