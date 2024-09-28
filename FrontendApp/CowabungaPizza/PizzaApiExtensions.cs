using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;

namespace CowabungaPizza;

public static class PizzaApiExtensions
{

    public static WebApplication MapPizzaApi(this WebApplication app)
    {

        // Notification Subscription

        app.MapPut("/notifications/subscribe", [Authorize] async (
            HttpContext context,
            PizzaStoreContext db,
            NotificationSubscription subscription) => {

                // One Subscription per User

                var userId = GetUserId(context);
                if (userId is null)
                {
                    return Results.Unauthorized();
                }
                var oldSubscriptions = db.NotificationSubscriptions.Where(e => e.UserId == userId);
                db.NotificationSubscriptions.RemoveRange(oldSubscriptions);

                // Saves new subscription

                subscription.UserId = userId;
                db.NotificationSubscriptions.Attach(subscription);

                await db.SaveChangesAsync();
                return Results.Ok(subscription);

            });


        // Specials

        app.MapGet("/specials", async (PizzaStoreContext db) => {

            var specials = await db.Specials.ToListAsync();
            return Results.Ok(specials);

        });

        // Toppings

        app.MapGet("/toppings", async (PizzaStoreContext db) => {
            var toppings = await db.Toppings.OrderBy(t => t.Name).ToListAsync();
            return Results.Ok(toppings);
        });

        return app;

    }


    // Extracts user ID
    public static string? GetUserId(HttpContext context) => context.User.FindFirstValue(ClaimTypes.NameIdentifier);

}