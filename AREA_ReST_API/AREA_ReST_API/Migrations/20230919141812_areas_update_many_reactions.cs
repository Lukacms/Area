using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AREA_ReST_API.Migrations
{
    /// <inheritdoc />
    public partial class areas_update_many_reactions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Areas_Reactions_ReactionId",
                table: "Areas");

            migrationBuilder.DropIndex(
                name: "IX_Areas_ReactionId",
                table: "Areas");

            migrationBuilder.DropColumn(
                name: "ReactionId",
                table: "Areas");

            migrationBuilder.AddColumn<int>(
                name: "AreaModelId",
                table: "Reactions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Reactions_AreaModelId",
                table: "Reactions",
                column: "AreaModelId");

            migrationBuilder.AddForeignKey(
                name: "FK_Reactions_Areas_AreaModelId",
                table: "Reactions",
                column: "AreaModelId",
                principalTable: "Areas",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reactions_Areas_AreaModelId",
                table: "Reactions");

            migrationBuilder.DropIndex(
                name: "IX_Reactions_AreaModelId",
                table: "Reactions");

            migrationBuilder.DropColumn(
                name: "AreaModelId",
                table: "Reactions");

            migrationBuilder.AddColumn<int>(
                name: "ReactionId",
                table: "Areas",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Areas_ReactionId",
                table: "Areas",
                column: "ReactionId");

            migrationBuilder.AddForeignKey(
                name: "FK_Areas_Reactions_ReactionId",
                table: "Areas",
                column: "ReactionId",
                principalTable: "Reactions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
