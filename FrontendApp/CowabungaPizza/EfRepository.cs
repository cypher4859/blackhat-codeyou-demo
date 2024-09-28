
using Microsoft.EntityFrameworkCore;

namespace CowabungaPizza;

// EF Core - Data Access Logic 

public class EfRepository : IRepository
{
	private readonly PizzaStoreContext _Context;

	// Initialize DB Context
	public EfRepository(PizzaStoreContext context)
	{
		_Context = context;
	}

	// Returns a LIST of all ORDERS in the database - ordered by CreatedTime
	public async Task<List<OrderWithStatus>> GetOrdersAsync()
	{
		var orders = await _Context.Orders
						.Include(o => o.DeliveryLocation)
						.Include(o => o.Pizzas).ThenInclude(p => p.Special)
						.Include(o => o.Pizzas).ThenInclude(p => p.Toppings).ThenInclude(t => t.Topping)
						.OrderByDescending(o => o.CreatedTime)
						.ToListAsync();

		return orders.Select(o => OrderWithStatus.FromOrder(o)).ToList();
	}

	// Returns a SINGLE ORDER by Id
	public async Task<OrderWithStatus> GetOrderWithStatus(int orderId)
	{

						var order = await _Context.Orders
						.Where(o => o.OrderId == orderId)
						.Include(o => o.DeliveryLocation)
						.Include(o => o.Pizzas).ThenInclude(p => p.Special)
						.Include(o => o.Pizzas).ThenInclude(p => p.Toppings).ThenInclude(t => t.Topping)
						.SingleOrDefaultAsync();

		if (order is null) throw new ArgumentNullException(nameof(order));

		return OrderWithStatus.FromOrder(order);

	}

	// Returns a LIST of all PIZZA SPECIALS
	public async Task<List<PizzaSpecial>> GetSpecials()
	{
		return await _Context.Specials.ToListAsync();
	}

	// Returns a LIST of all TOPPINGS
	public async Task<List<Topping>> GetToppings()
	{
		return await _Context.Toppings.OrderBy(t => t.Name).ToListAsync();
	}

	// Placeholder 
	public Task<int> PlaceOrder(Order order)
	{
		throw new NotImplementedException();
	}
}