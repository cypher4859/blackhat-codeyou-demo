global using CowabungaPizza.Shared;
using CowabungaPizza;
using CowabungaPizza.Client;
using CowabungaPizza.Components;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// SERVICES

builder.Services.AddRazorComponents()
		.AddInteractiveServerComponents()
		.AddInteractiveWebAssemblyComponents();

// builder.Services.AddDbContext<PizzaStoreContext>(options =>
// 				options.UseSqlite("Data Source=pizza.db"));
builder.Services.AddDbContext<PizzaStoreContext>(options =>
				options.UseMySql(
					builder.Configuration.GetConnectionString("mysql-database"),
					ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("mysql-database"))
				));

builder.Services.AddScoped<IRepository, EfRepository>();
builder.Services.AddScoped<OrderState>();

builder.Services.AddControllers();

var app = builder.Build();

// DB INITIALIZATION

var scopeFactory = app.Services.GetRequiredService<IServiceScopeFactory>();
using (var scope = scopeFactory.CreateScope())
{
	var db = scope.ServiceProvider.GetRequiredService<PizzaStoreContext>();
	if (db.Database.EnsureCreated())
	{
		SeedData.Initialize(db);
	}
}


// Configure the HTTP request pipeline

if (app.Environment.IsDevelopment())
{
	app.UseWebAssemblyDebugging();
}
else
{
	app.UseExceptionHandler("/Error", createScopeForErrors: true);
	app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseAntiforgery();

app.MapPizzaApi();

app.MapControllers();

app.MapRazorComponents<App>()
		.AddInteractiveServerRenderMode()
		.AddInteractiveWebAssemblyRenderMode()
		.AddAdditionalAssemblies(typeof(CowabungaPizza.Client._Imports).Assembly);

app.Run();
