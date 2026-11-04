# ER Diagram

Entity-relationship diagram of `ecommerce_db` (GitHub renders the Mermaid block below).

```mermaid
erDiagram
    CUSTOMERS ||--o{ ADDRESSES : has
    CUSTOMERS ||--o{ ORDERS : places
    CUSTOMERS ||--o{ REVIEWS : writes
    ADDRESSES |o--o{ ORDERS : "ships to"
    CATEGORIES |o--o{ CATEGORIES : "parent of"
    CATEGORIES ||--o{ PRODUCTS : groups
    PRODUCTS ||--|| INVENTORY : "stock of"
    PRODUCTS ||--o{ ORDER_ITEMS : "appears in"
    PRODUCTS ||--o{ REVIEWS : receives
    ORDERS ||--|{ ORDER_ITEMS : contains
    ORDERS ||--o{ PAYMENTS : "paid by"

    CUSTOMERS {
        int customer_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone
        char password_hash
        datetime created_at
        boolean is_active
    }
    ADDRESSES {
        int address_id PK
        int customer_id FK
        varchar label
        varchar line1
        varchar city
        varchar province
        varchar postal_code
        boolean is_default
    }
    CATEGORIES {
        int category_id PK
        varchar name UK
        int parent_id FK
    }
    PRODUCTS {
        int product_id PK
        int category_id FK
        varchar sku UK
        varchar name
        decimal price "CHECK > 0"
        boolean is_active
    }
    INVENTORY {
        int product_id PK, FK
        int quantity "CHECK >= 0"
        int reorder_level
    }
    ORDERS {
        int order_id PK
        int customer_id FK
        int shipping_address_id FK
        datetime order_date
        enum status
        decimal total_amount
    }
    ORDER_ITEMS {
        int order_id PK, FK
        int product_id PK, FK
        int quantity "CHECK > 0"
        decimal unit_price
    }
    PAYMENTS {
        int payment_id PK
        int order_id FK
        enum method
        decimal amount
        enum status
        datetime paid_at
    }
    REVIEWS {
        int review_id PK
        int product_id FK
        int customer_id FK
        tinyint rating "CHECK 1-5"
        varchar comment
    }
```

## Relationships

| Relationship | Type | Enforced by |
|---|---|---|
| customer → addresses | 1 : N | `fk_addresses_customer` (ON DELETE CASCADE) |
| customer → orders | 1 : N | `fk_orders_customer` (ON DELETE RESTRICT, order history is kept) |
| category → sub-categories | 1 : N (self) | `fk_categories_parent` |
| category → products | 1 : N | `fk_products_category` |
| product → inventory | 1 : 1 | `inventory.product_id` is both PK and FK |
| orders ↔ products | M : N | resolved by `order_items` (composite PK) |
| order → payments | 1 : N | `fk_payments_order` (allows a failed attempt + a retry) |
| customer ↔ product reviews | M : N | `reviews` with `UNIQUE (product_id, customer_id)` |

## Normalization notes

- The schema is in **3NF**: every non-key column depends only on its table's key.
- `order_items.unit_price` looks like duplication of `products.price` but it is intentional: it is a **snapshot** of the price at the time of the order, so changing a product price later does not change old invoices.
- `orders.total_amount` is a derived value kept in sync by triggers, so reports don't have to re-sum the items each time.
