using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.SqlServer;
using System.Collections.Generic;

var builder = WebApplication.CreateBuilder(args);

// Agrega la dependencia de Entity Framework Core para SQL Server
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("MiWebAppContext")));


var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;

    try
    {
        var context = services.GetRequiredService<ApplicationDbContext>();
        context.Database.Migrate();
    }
    catch (Exception ex)
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "An error occurred applying migrations.");
    }
}

app.MapGet("/", async (ApplicationDbContext db) =>
{
    // Realiza una consulta simple a la base de datos
    try
    {
        var count = await db.Test.CountAsync(); // Reemplaza YourTable con el nombre de tu tabla
        return $"Hello World! Database count: {count}";
    }
    catch (Exception ex)
    {
        return $"Error: {ex.Message}"; // Muestra el error para depuración
    }

});


app.Run();



// Define un contexto de datos para Entity Framework Core
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    // Define un DbSet para tu tabla. Reemplaza YourTable y TestModel con los nombres correctos
    public DbSet<TestModel> Test { get; set; }
}


// Define un modelo para tu tabla. Reemplaza TestModel y las propiedades con las de tu tabla
public class TestModel
{
    public int Id { get; set; }
    // ... otras propiedades de tu tabla
}

