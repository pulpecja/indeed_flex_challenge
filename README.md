# Challenge

## Project description

This is a checkout system that accepts 2 types of promotions, allows to add products and counts total amount of the items in the basket.

There are two types of promotions:
- `Percentage Promotion`, which lowers the total basket value by the specific percentage if total value is higher than specific amount.
- `Quantity Promotion`, which lowers the price of the products if they are bought at least in the specified quantity.

`QuantityPromotion` attributes:
- `product_code` - required - this is the code of the product which price can be reduced
- `minimum_amount` - required - this is the minimum items' quantity that needs to be bought to use the promotion
- `discounted_price` - required - this is the new, lower price that should be used to count basket's price

`PercentagePromotion` attributes:
- `minimum_amount` - required - this is the minimum total value of the basket that allows to use this promotion
- `percentage_discount` - required - this is the value of the discount counted.

Quantity promotions are counted before percentage promotions.
If there are multiple promotions available for the same item of basket's value, the best for the customer one will be used.

`Product` attributes:
- `code` - required - ID of the product
- `name` - required - name of the product
- `price` - required - initial price of the product

## Test data

Products values:
```
Product code  | Name                   | Price
----------------------------------------------------------
001           | Lavender heart         | £9.25
002           | Personalised cufflinks | £45.00
003           | Kids T-shirt           | £19.95
```

Output data:
```
Basket: 001,002,003
Total price expected: £66.78

Basket: 001,003,001
Total price expected: £36.95

Basket: 001,002,001,003
Total price expected: £73.76
```
Checkout usage:
```
co = Checkout.new(promotional_rules)
co.scan(item)
co.scan(item)
price = co.total
```

## Tech stack

Application was written in plain Ruby, version 3.1.0.
To install and run the application, run:

```
bundle install
```

To run test examples, run:
```
rspec
```

To check Rubocop, run:
```
rubocop
```

## What can be improved?

Some ideas for improvements:
1. The application currently does not have a database. If it was added, we could also add unique validation on the Product's code and use it as a primary key.
2. The application is ready for creating new types of promotions. It is enough to create new classes in the `promotions` directories.
3. The application currently does not handle currencies. We can add `Money` gem to keep also the data about the currency.










