{{ config(materialized='table') }}

with 
customers as (

  select 
    id as customer_id,
    name,
    email

  from {{ source('coffee_shop', 'customers') }} as customers
  {# `analytics-engineers-club.coffee_shop.customers` #}
),

orders_per_customer as(

  select 
    customer_id,
    min(created_at) as first_order_at,
    count(*)        as number_of_orders

  from {{ source('coffee_shop', 'orders') }} as orders
  {# from `analytics-engineers-club.coffee_shop.orders` #}
  group by 1
),

final as (

  select 
    customer_id,
    name,
    email,
    first_order_at,
    number_of_orders

  from customers
  left join orders_per_customer using (customer_id)
)

select * from final
order by first_order_at 