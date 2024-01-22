--Represent users of service, both sellers and buyers
CREATE TABLE "users" (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL UNIQUE,
    "is_phone_number_verified" NUMERIC NOT NULL DEFAULT 0,
    "joined" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id")
);

--Represent addresses of users
CREATE TABLE "addresses" (
    "id" INTEGER,
    "user_id" INTEGER,
    "country" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "postal_code" NUMERIC NOT NULL,
    "street" TEXT,
    "house_number" TEXT NOT NULL,
    "main" NUMERIC NOT NULL DEFAULT 0,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id")
);

-- Represent messages between users
CREATE TABLE "messages" (
    "id" INTEGER,
    "from_user_id" INTEGER,
    "to_user_id" INTEGER,
    "sent_timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT NOT NULL CHECK("status" IN ('sent', 'delivered', 'read')),
    "content" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("from_user_id") REFERENCES "users"("id"),
    FOREIGN KEY("to_user_id") REFERENCES "users"("id")
);

--Represent listings published by sellers
CREATE TABLE "listings" (
    "id" INTEGER,
    "seller_id" INTEGER,
    "address_id" INTEGER,
    "category" TEXT NOT NULL,
    "state" TEXT NOT NULL CHECK("state" IN ('new', 'used', 'broken')),
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "img_URL" TEXT NOT_NULL DEFAULT 'no_image.png',
    "price" INTEGER NOT NULL,
    "date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_active" NUMERIC NOT NULL DEFAULT 1,
    "is_deleted" NUMERIC NOT NULL DEFAULT 0,
    PRIMARY KEY("id"),
    FOREIGN KEY("seller_id") REFERENCES "users"("id"),
    FOREIGN KEY("address_id") REFERENCES "addresses"("id")
);

--Represent transactions
CREATE TABLE "transactions" (
    "id" INTEGER,
    "listing_id" INTEGER,
    "buyer_id" INTEGER,
    "date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL CHECK("type" IN ('payment', 'refund')),
    PRIMARY KEY("id"),
    FOREIGN KEY("listing_id") REFERENCES "listings"("id"),
    FOREIGN KEY("buyer_id") REFERENCES "users"("id")
);

--Represent orders made by user
CREATE TABLE "orders" (
    "id" INTEGER,
    "transaction_id" INTEGER,
    "delivery_address" INTEGER,
    "state" TEXT NOT NULL CHECK("state" IN ('ready_to_send', 'in_delivery', 'delivered')),
    "date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id"),
    FOREIGN KEY("transaction_id") REFERENCES "transactions"("id"),
    FOREIGN KEY("delivery_address") REFERENCES "addresses"("id")
);


-- Create indexes to speed common searches
CREATE INDEX "listing_name_search" ON "listings" ("name");
CREATE INDEX "listing_category_search" ON "listings" ("category");

-- Create index to speed ordering listings
CREATE INDEX "listing_date_order" ON "listings" ("date");
CREATE INDEX "listing_price_order" ON "listings" ("price");


-- Create view with archived listings, oldest on top by default
CREATE VIEW "archived_listings" AS
SELECT  "id", "seller_id", "date", "category", "state", "name", "description", "img_URL", "price" FROM "listings"
WHERE "is_active" = 0 AND "is_deleted" = 0
ORDER BY "date" ASC;

-- Create view with active listings, newest on top by default
CREATE VIEW "active_listings" AS
SELECT  "id", "seller_id", "date", "category", "state", "name", "description", "img_URL", "price" FROM "listings"
WHERE "is_active" = 1 AND "is_deleted" = 0
ORDER BY "date" DESC;

-- Create view with with all payments
CREATE VIEW "payments" AS
SELECT "id", "listing_id", "buyer_id", "date" FROM "transactions"
WHERE "type" = 'payment';

-- Create view with with all refunds
CREATE VIEW "refunds" AS
SELECT "id", "listing_id", "buyer_id", "date" FROM "transactions"
WHERE "type" = 'refund';

-- Create trigger to deactive listing while inserting transaction
CREATE TRIGGER "archive_listing" AFTER INSERT ON "transactions"
WHEN NEW."type" != 'refund'
BEGIN
    UPDATE "listings" SET "is_active" = 0
    WHERE "id" = NEW."listing_id";
END;
