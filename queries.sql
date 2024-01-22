-- Add new users
INSERT INTO "users" ("username", "password", "first_name", "last_name", "phone_number")
VALUES ('johnnyjohn', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'John', 'Doe', '48500600700');
INSERT INTO "users" ("username", "password", "first_name", "last_name", "phone_number")
VALUES ('lukydan', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Dan', 'Boe', '48501600700');

-- Add new address
INSERT INTO "addresses" ("user_id", "country", "city", "postal_code", "street", "house_number")
VALUES (1, 'Poland', 'Poznan', '64-000', 'st. Martin', '1/1A');
INSERT INTO "addresses" ("user_id", "country", "city", "postal_code", "street", "house_number")
VALUES (2, 'Poland', 'Sosnowiec', '00-000', 'Some Street', '1/1A');

-- Add new listings
INSERT INTO "listings" ("seller_id", "address_id", "category", "state", "name", "description", "price")
VALUES (1, 1, 'Laptops', 'used', 'MacBooklet Atmosphere', 'Used MacBooklet Atmosphere from 2021\nConfiguration...', '1500');
INSERT INTO "listings" ("seller_id", "address_id", "category", "state", "name", "description", "price")
VALUES (1, 1, 'Laptops', 'new', 'MacBooklet Atmosphere', 'New MacBooklet Atmosphere from 2024\nConfiguration...', '5000');


-- Add new message
INSERT INTO "messages" ("from_user_id", "to_user_id", "status", "content")
VALUES (2, 1, 'sent', 'Hello there!');

-- Add transaction
INSERT INTO "transactions" ("listing_id", "buyer_id", "type")
VALUES (2, 2, 'payment');

-- Create new order after transaction
INSERT INTO "orders" ("transaction_id", "delivery_address", "state")
VALUES (1, 2, 'ready_to_send');

-- Update message status
UPDATE "messages"
SET "status" = 'delivered'
WHERE "id" = 1;

-- Update order status
UPDATE "orders"
SET "state" = 'in_delivery'
WHERE "id" = 1;

-- Update phone number status
UPDATE "users"
SET "is_phone_number_verified" = 1
WHERE "phone_number" = '48500600700';

-- Find listings from given category and ordered by date
SELECT * FROM "listings"
WHERE "category" = 'Laptops'
ORDER BY "date" ASC;

-- Find listings with given name sorted by price
SELECT * FROM "listings"
WHERE "name" LIKE '%macbooklet%'
ORDER BY "price" ASC;

-- Find all active listings sorted by newest
SELECT * FROM "active_listings";

-- Find all archieved listings sorted by oldest
SELECT * FROM "archived_listings";

-- Find all payments of user
SELECT * FROM "payments"
WHERE "buyer_id" = 1;

-- Find all refunds given to user
SELECT * FROM "refunds"
WHERE "buyer_id" = 1;
