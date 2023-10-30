using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Mail;
using System.Security.Claims;
using System.Text;
using System.Text.Json.Nodes;
using AREA_ReST_API.Classes;
using AREA_ReST_API.Classes.Jwt;
using AREA_ReST_API.Classes.Login;
using AREA_ReST_API.Classes.Register;
using AREA_ReST_API.Middleware;
using AREA_ReST_API.Models;
using AREA_ReST_API.Models.OAuth.Google;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json.Linq;

namespace AREA_ReST_API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly HttpService _client;
    private readonly string _googleUrl = "https://oauth2.googleapis.com/token";

    public UsersController(AppDbContext context)
    {
        _context = context;
        _client = new HttpService();
    }

    [HttpGet("")]
    public ActionResult<IEnumerable<UsersModel>> GetAllUsers([FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        if (decodedUser.Admin != true)
            return new UnauthorizedObjectResult(new JsonObject{{"message", "Not authorize to get data"}});
        return new OkObjectResult(_context.Users.ToList());
    }

    [HttpGet("{id:int}")]
    public ActionResult<UsersModel?> GetUser([AsParameters] int id, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        if (decodedUser.Admin != true)
            return new UnauthorizedObjectResult(new JsonObject{{"message", "Not authorize to get data"}});
        var requestedUser = _context.Users.FirstOrDefault(user => user.Id == id);
        if (requestedUser == null)
            return new NotFoundObjectResult("User not found");
        return new OkObjectResult(requestedUser);
    }

    [HttpGet("me")]
    public ActionResult<UsersModel?> GetMe([FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);
        var requestedUser = _context.Users.FirstOrDefault(user => user.Id == decodedUser.Id);
        if (requestedUser == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "User not found" } });
        return new OkObjectResult(requestedUser);
    }

    [HttpDelete("{id:int}")]
    public ActionResult DeleteUser([AsParameters] int id)
    {
        var deletedUser = _context.Users.FirstOrDefault(user => user.Id == id);
        if (deletedUser == null)
            return new NotFoundObjectResult(new JsonObject {{"message", "User does not exist"}});
        _context.Users.Remove(deletedUser);
        _context.SaveChanges();
        return new OkObjectResult(new JsonObject {{"message", "User successfully deleted"}});
    }

    private async void SendVerifEmail(UsersModel newUser)
    {
        string body = $"Hello {newUser.Username},<br/><br/>" +
                      $"Click the link below to complete the login process:<br/>" +
                      $"<a href=\"http://localhost:8081/register/verify?id={BCrypt.Net.BCrypt.EnhancedHashPassword(newUser.Id.ToString(), 13)}&email={newUser.Email}\">login</a>";

        MailMessage mail = new MailMessage();
        mail.From = new MailAddress("noreply.fastr@gmail.com", "NoReply");
        mail.To.Add(newUser.Email!);
        mail.Subject = "FastR - Verify your email in one click";
        mail.SubjectEncoding = System.Text.Encoding.UTF8;
        mail.Body = body;
        mail.BodyEncoding = System.Text.Encoding.UTF8;
        mail.IsBodyHtml = true;

        SmtpClient client = new SmtpClient("smtp.gmail.com", 587);
        client.UseDefaultCredentials = false;
        client.Credentials = new NetworkCredential("noreply.fastr@gmail.com", "wdro dohf rfuz wdjh ");
        client.EnableSsl = true;
        try
        {
            await client.SendMailAsync(mail);
        } catch (Exception e) {
          Console.WriteLine("failure " + e);
        }
    }

    [AllowAnonymous]
    [HttpPost("register")]
    public ActionResult CreateNewUser([FromBody] RegisterClass userInfo)
    {
        var checkedUser = _context.Users.FirstOrDefault(user => user.Email == userInfo.Email);

        if (checkedUser != null)
            return new ConflictObjectResult(new JsonObject { { "message", "Email is already used" } });
        if (!IsUserValid(userInfo))
            return new BadRequestObjectResult(new JsonObject { { "message", "Request is not valid" } });
        var hashPassword = BCrypt.Net.BCrypt.EnhancedHashPassword(userInfo.Password, 13);
        var newUser = new UsersModel
        {
            Username = userInfo.Username,
            Email = userInfo.Email,
            Password = hashPassword,
            Name = userInfo.Name,
            Surname = userInfo.Surname,
            Admin = false,
        };
        var user = _context.Users.Add(newUser);
        _context.SaveChanges();
        SendVerifEmail(user.Entity);
        return new CreatedResult("URI", user.Entity);
    }

    [AllowAnonymous]
    [HttpPost("verifyMail")]
    public ActionResult VerifyUserEmail([FromBody] UserMailVerification user)
    {
        var checkedUser = _context.Users.FirstOrDefault(search => search.Email == user.Email);

        if (checkedUser == null)
            return new ConflictObjectResult(new JsonObject { { "message", "User does not exists" } });
        if (BCrypt.Net.BCrypt.EnhancedVerify(checkedUser.Id.ToString(), user.HashId) == false)
            return new ConflictObjectResult(new JsonObject { { "message", "Invalid code." } });
        checkedUser.IsMailVerified = true;
        _context.Users.Update(checkedUser);
        _context.SaveChanges();
        return new OkObjectResult("Successfully verified mail");
    }

    private static bool IsUserValid(RegisterClass newUser)
    {
        try {
            var addr = new MailAddress(newUser.Email);
        } catch {
            return false;
        }
        return !newUser.Username.IsNullOrEmpty() && !newUser.Name.IsNullOrEmpty() && !newUser.Password.IsNullOrEmpty();
    }

    [AllowAnonymous]
    [HttpPost("login")]
    public ActionResult LoginUser([FromBody] Credentials credentials, JwtOptions jwtOptions)
    {
        var email = credentials.Email;
        var password = credentials.Password;
        var requestedUser = _context.Users.FirstOrDefault(user => user.Email == email);

        if (requestedUser == null)
            return new NotFoundObjectResult(new JsonObject { { "message", "User not found" } });
        if (email.IsNullOrEmpty() || password.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { { "message", "Request is not valid" } });
        if (requestedUser.IsMailVerified == false)
            return new UnauthorizedObjectResult(new JsonObject {{"message", "User must validate account via the link send in mail." }});
        if (BCrypt.Net.BCrypt.EnhancedVerify(password, requestedUser.Password) == false)
            return new UnauthorizedObjectResult(new JsonObject {{"message", "Wrong password" }});
        var token = GenerateJwtToken(requestedUser, jwtOptions);
        return new OkObjectResult(new JsonObject { { "access_token", token } });
    }

    private static string GenerateJwtToken(UsersModel user, JwtOptions jwtOptions)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(jwtOptions.SigningKey);

        var claims = new List<Claim>
        {
            new Claim("username", user.Username!),
            new Claim("email", user.Email!),
            new Claim("admin", user.Admin.ToString()),
            new Claim("id", user.Id.ToString()),
        };

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Issuer = jwtOptions.Issuer,
            Audience = jwtOptions.Audience,
            Expires = DateTime.Now.AddYears(1),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        var jwt = tokenHandler.WriteToken(token);
        return jwt;
    }

    [HttpPut("")]
    public ActionResult ModifyUser([FromBody] UsersModel modifiedUser, [FromHeader] string authorization)
    {
        var decodedUser = JwtDecoder.Decode(authorization);

        if (!decodedUser.Admin)
            return new UnauthorizedObjectResult(new JsonObject
                { { "message", "You are not authorized to modify this user" } });
        if (modifiedUser.Name.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Name cannot be empty or null" } });
        if (modifiedUser.Surname.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Surname cannot be empty or null" } });
        if (modifiedUser.Username.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Username cannot be empty or null" } });
        if (modifiedUser.Password.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Password cannot be empty or null" } });
        if (modifiedUser.Email.IsNullOrEmpty())
            return new BadRequestObjectResult(new JsonObject { {"message", "Email cannot be empty or null" } });
        var hashedPassword = BCrypt.Net.BCrypt.EnhancedHashPassword(modifiedUser.Password, 13)!;
        modifiedUser.Password = hashedPassword;
        var user = _context.Users.Update(modifiedUser);
        _context.SaveChanges();
        return new CreatedResult("User successfully modified", user.Entity);
    }

    [HttpPut("partialModif")]
    public ActionResult ModifyPartiallyUser([FromBody] UsersModel modifiedUser, [FromHeader] string authorization)
    {
      var decodedUser = JwtDecoder.Decode(authorization);

      var user = _context.Users.Update(modifiedUser);
      _context.SaveChanges();
      return new CreatedResult("User successfully modified", user.Entity);
    }

    [AllowAnonymous]
    [HttpPost("googleLogin")]
    public async Task<ActionResult> GoogleLogin([FromBody] GoogleModel googleCodes, JwtOptions jwtOptions)
    {
        const string googleInfos = "https://www.googleapis.com/oauth2/v1/userinfo";
        var data = new Dictionary<string, string>
        {
            { "code", googleCodes.Code },
            { "client_id", "315267877885-2np97bt3qq9s6er73549ldrfme2b67pi.apps.googleusercontent.com" },
            { "client_secret", "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" },
            { "redirect_uri", googleCodes.callbackUri!},
            { "grant_type", "authorization_code" },
        };
        var result = await _client.PostAsync(_googleUrl, data, "application/x-www-forms-urlencoded", "");
        var jsonRes = JObject.Parse(result);
        var query = $"?alt=json&access_token={jsonRes["access_token"]!.ToString()}";
        var userInfo = await _client.GetWithQueryAsync(googleInfos, query, "",
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8");
        var userJson = JObject.Parse(userInfo);
        var userMail = await _client.GetAsyncAuth($"https://gmail.googleapis.com/gmail/v1/users/{userJson["id"]!.ToString()}/profile", null, "application/x-www-forms-urlencoded", jsonRes["access_token"]!.ToString());
        Console.WriteLine(userMail);
        var userMailJson = JObject.Parse(userMail);
        var client = _context.Users.FirstOrDefault(user => user.Email == userMailJson["emailAddress"]!.ToString());
        if (client == null || client.Email == null)
        {
            client = new UsersModel
            {
                Username = userJson["name"]!.ToString(),
                Email = userMailJson["emailAddress"]!.ToString(),
                Password = "",
                Name = userJson["family_name"]!.ToString(),
                Surname = userJson["given_name"]!.ToString(),
                Admin = false,
                IsGoogleConnected = true,
            };
            var createdUser = _context.Users.Add(client);
            await _context.SaveChangesAsync();
            var userService = new UserServicesModel
            {
                ServiceId = _context.Services.First(service => service.Name == "Google").Id,
                UserId = createdUser.Entity.Id,
                AccessToken = jsonRes["access_token"]!.ToString(),
                RefreshToken = jsonRes["refresh_token"]!.ToString(),
                ExpiresIn = (int)jsonRes["expires_in"]!,
            };
            _context.UserServices.Add(userService);
            await _context.SaveChangesAsync();
        }
        var token = GenerateJwtToken(client, jwtOptions);
        return new OkObjectResult(new JsonObject { { "access_token", token } });
    }
}
