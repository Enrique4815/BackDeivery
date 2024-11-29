USE delivery;

CREATE TABLE users(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(180) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    lastname VARCHAR(90) NOT NULL,
    phone VARCHAR(90) NOT NULL UNIQUE,
    image VARCHAR(255) NULL,
    password VARCHAR(90) NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL
);

CREATE TABLE roles(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(90) NOT NULL UNIQUE,
    image VARCHAR(255) NULL,
    route VARCHAR(180) NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL
);

INSERT INTO roles(
	name,
    route,
    created_at,
    updated_at
)
VALUES(
	'RESTAURANTE',
    '/restaurant/orders/list',
    '2024-11-15',
    '2024-11-15'
);

INSERT INTO roles(
	name,
    route,
    created_at,
    updated_at
)
VALUES(
	'REPARTIDOR',
    '/delivery/orders/list',
    '2024-11-15',
    '2024-11-15'
);

INSERT INTO roles(
	name,
    route,
    created_at,
    updated_at
)
VALUES(
	'CLIENTE',
    '/client/products/list',
    '2024-11-15',
    '2024-11-15'
);

CREATE TABLE user_has_roles(
	id_user BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    FOREIGN KEY(id_user) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(id_rol) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_user, id_rol)
);

CREATE TABLE categories(
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(180) NOT NULL,
    description TEXT NOT NULL,
    image VARCHAR(255) NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL
);

CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(180) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    price DECIMAL NOT NULL,
    image1 VARCHAR(255) NULL,
    image2 VARCHAR(255) NULL,
    image3 VARCHAR(255) NULL,
    id_category BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    FOREIGN KEY (id_category) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE address(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(255) NOT NULL,
    neighborhood VARCHAR(180) NOT NULL,
    lat DOUBLE NOT NULL,
    lng DOUBLE NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    id_user BIGINT NOT NULL,
    FOREIGN KEY(id_user) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_client BIGINT NOT NULL,
    id_delivery BIGINT NULL,
    id_address BIGINT NOT NULL,
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    status VARCHAR(90) NOT NULL,
    timestamp BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    FOREIGN KEY (id_client) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_delivery) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_address) REFERENCES address(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE order_has_products(
    id_order BIGINT NOT NULL,
    id_product BIGINT NOT NULL,
    quantity BIGINT NOT NULL,
    created_at TIMESTAMP(0) NOT NULL,
    updated_at TIMESTAMP(0) NOT NULL,
    PRIMARY KEY(id_order, id_product),
    FOREIGN KEY(id_order) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(id_product) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE
);





SELECT
	CONVERT(O.id, char) AS id,
    CONVERT(O.id_client, char) AS id_client,
    CONVERT(O.id_address, char) AS id_address,
    CONVERT(O.id_delivery, char) AS id_delivery,
    O.status,
    O.timestamp,
    JSON_OBJECT(
		'id', CONVERT(A.id, char),
        'address', A.address,
        'neighborhood', A.neighborhood,
        'lat', A.lat,
        'lng', A.lng
    ) AS address,
    JSON_OBJECT(
		'id', CONVERT(U.id, char),
        'name', U.name,
        'lastname', U.lastname,
        'image', U.image
    ) AS client,
    JSON_ARRAYAGG(
		JSON_OBJECT(
			'id', CONVERT(P.id, char),
            'name', P.name,
            'description', P.description,
            'image1', P.image1,
            'image2', P.image2,
            'image3', P.image3,
            'price', P.price,
            'quantity', OHP.quantity
        )
	) AS products
FROM
	orders AS O
INNER JOIN
	users AS U
ON
	U.id = O.id_client
INNER JOIN
	address AS A
ON
	A.id = O.id_address
INNER JOIN
	order_has_products AS OHP
ON
	OHP.id_order = O.id
INNER JOIN
	products AS P
ON
	P.id = OHP.id_product
WHERE
	status = 'PAGADO'
GROUP BY
	O.id;