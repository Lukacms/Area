using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AREA_ReST_API.Migrations
{
    /// <inheritdoc />
    public partial class test3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Actions_Areas_AreaModelId",
                table: "Actions");

            migrationBuilder.DropForeignKey(
                name: "FK_Reactions_Areas_AreaModelId",
                table: "Reactions");

            migrationBuilder.DropIndex(
                name: "IX_Reactions_AreaModelId",
                table: "Reactions");

            migrationBuilder.DropIndex(
                name: "IX_Actions_AreaModelId",
                table: "Actions");

            migrationBuilder.DropColumn(
                name: "AreaModelId",
                table: "Reactions");

            migrationBuilder.DropColumn(
                name: "AreaModelId",
                table: "Actions");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AreaModelId",
                table: "Reactions",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AreaModelId",
                table: "Actions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Reactions_AreaModelId",
                table: "Reactions",
                column: "AreaModelId");

            migrationBuilder.CreateIndex(
                name: "IX_Actions_AreaModelId",
                table: "Actions",
                column: "AreaModelId");

            migrationBuilder.AddForeignKey(
                name: "FK_Actions_Areas_AreaModelId",
                table: "Actions",
                column: "AreaModelId",
                principalTable: "Areas",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Reactions_Areas_AreaModelId",
                table: "Reactions",
                column: "AreaModelId",
                principalTable: "Areas",
                principalColumn: "Id");
        }
    }
}
