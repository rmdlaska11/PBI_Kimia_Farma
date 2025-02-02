-- Membuat tabel analisa
CREATE TABLE rakamin-kf-analytics-448809.kimia_farma.kf_analysis AS
SELECT
    ft.transaction_id,
    ft.date,
    kc.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    p.product_id,
    p.product_name,
    p.price AS actual_price,
    ft.discount_percentage,
    -- Menghitung persentase gross laba berdasarkan kondisi harga
    CASE 
        WHEN p.price <= 50000 THEN 10
        WHEN p.price > 50000  AND p.price <= 100000 THEN 15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 25
        ELSE 30
    END AS persentase_gross_laba,
    -- Menghitung nett_sales setelah diskon
    p.price * (1 - ft.discount_percentage / 100) AS nett_sales,
    -- Menghitung nett_profit
    (p.price * (1 - ft.discount_percentage / 100)) * 
    (CASE 
        WHEN p.price <= 50000 THEN 10 / 100.0
        WHEN p.price > 50000  AND p.price <= 100000 THEN 15 / 100.0
        WHEN p.price > 100000 AND p.price <= 300000 THEN 20 / 100.0
        WHEN p.price > 300000 AND p.price <= 500000 THEN 25 / 100.0
        ELSE 30 / 100.0
    END) AS nett_profit,
    ft.rating AS rating_transaksi
FROM
    `kimia_farma.kf_final_transaction` ft
JOIN
    `kimia_farma.kf_kantor_cabang` kc ON ft.branch_id = kc.branch_id
JOIN
    `kimia_farma.kf_product` p ON ft.product_id = p.product_id;