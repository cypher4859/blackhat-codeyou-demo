using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CowabungaPizza;

// Route Definition / API Controller

[Route("orders")]
[ApiController]



public class OrdersController : Controller
{
    private readonly PizzaStoreContext _db;

    // Initialize controller with DB Context

    public OrdersController(PizzaStoreContext db)
    {
        _db = db;
    }

    // GET - Returns a LIST of all ORDERS in DB

    [HttpGet]
    public async Task<ActionResult<List<OrderWithStatus>>> GetOrders()
    {
        var orders = await _db.Orders
                // .Where(o => o.UserId == PizzaApiExtensions.GetUserId(HttpContext))
                .Include(o => o.DeliveryLocation)
                .Include(o => o.Pizzas).ThenInclude(p => p.Special)
                .Include(o => o.Pizzas).ThenInclude(p => p.Toppings).ThenInclude(t => t.Topping)
                .OrderByDescending(o => o.CreatedTime)
                .ToListAsync();

        return orders.Select(o => OrderWithStatus.FromOrder(o)).ToList();
    }

    // GET - Returns a SINGLE ORDER by Id

    [HttpGet("{orderId}")]
    public async Task<ActionResult<OrderWithStatus>> GetOrderWithStatus(int orderId)
    {
        var order = await _db.Orders
                .Where(o => o.OrderId == orderId)
                // .Where(o => o.UserId == PizzaApiExtensions.GetUserId(HttpContext))
                .Include(o => o.DeliveryLocation)
                .Include(o => o.Pizzas).ThenInclude(p => p.Special)
                .Include(o => o.Pizzas).ThenInclude(p => p.Toppings).ThenInclude(t => t.Topping)
                .SingleOrDefaultAsync();

        if (order == null)
        {
            return NotFound();
        }

        return OrderWithStatus.FromOrder(order);
    }

    // POST - Place an ORDER

    [HttpPost]
    public async Task<ActionResult<int>> PlaceOrder(Order order)
    {
        order.CreatedTime = DateTime.Now;
        order.DeliveryLocation = new LatLong(51.5001, -0.1239);
       
        foreach (var pizza in order.Pizzas)
        {
            pizza.SpecialId = pizza.Special?.Id ?? 0;
            pizza.Special = null;

            foreach (var topping in pizza.Toppings)
            {
                topping.ToppingId = topping.Topping?.Id ?? 0;
                topping.Topping = null;
            }
        }

        // Attaches the order to the DB Context, Save to DB

        _db.Orders.Attach(order);
        await _db.SaveChangesAsync();


        // PUSH NOTIFICATIONS - Sends notifications to user (Future Feature for Order Tracking)

        var subscription = await _db.NotificationSubscriptions.Where(e => e.UserId == PizzaApiExtensions.GetUserId(HttpContext)).SingleOrDefaultAsync();
        if (subscription != null)
        {
            _ = TrackAndSendNotificationsAsync(order, subscription);
        }

        return order.OrderId;
    }

	// Tracks the order and sends notifications at different stages (Future Feature for Order Tracking)

	private static async Task TrackAndSendNotificationsAsync(Order order, NotificationSubscription subscription)
    {
        // Simulates order preparation, dispatch, and delivery

        await Task.Delay(OrderWithStatus.PreparationDuration);
        await SendNotificationAsync(order, subscription, "Your order has been dispatched!");

        await Task.Delay(OrderWithStatus.DeliveryDuration);
        await SendNotificationAsync(order, subscription, "Your order is now delivered. Enjoy!");
    }

    private static Task SendNotificationAsync(Order order, NotificationSubscription subscription, string message)
    {
        // This will be implemented later
        return Task.CompletedTask;
    }
}