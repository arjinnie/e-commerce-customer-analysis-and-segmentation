-- En çok sipariş verilen kanalı bulma
-- Bu sorgu, sipariş kanallarına göre toplam sipariş sayısını hesaplar ve en popüler kanalı gösterir.
SELECT order_channel, 
       SUM(order_num_total_ever_online + order_num_total_ever_offline) AS toplam_siparis
FROM FLO
GROUP BY order_channel
ORDER BY toplam_siparis DESC;

-- Müşterilerin toplam harcamalarını ve sipariş sayılarını listeleme
-- Her müşterinin toplam sipariş sayısını ve harcamasını hesaplar, yüksek değerli müşterileri öne çıkarır.
SELECT master_id, 
       (order_num_total_ever_online + order_num_total_ever_offline) AS toplam_siparis,
       (customer_value_total_ever_online + customer_value_total_ever_offline) AS toplam_harcama
FROM FLO
WHERE (order_num_total_ever_online + order_num_total_ever_offline) > 0
ORDER BY toplam_harcama DESC;



--Bonus en iyi 100 müşteri

SELECT TOP 100 master_id, 
       (order_num_total_ever_online + order_num_total_ever_offline) AS toplam_siparis,
       (customer_value_total_ever_online + customer_value_total_ever_offline) AS toplam_harcama
FROM FLO
WHERE (order_num_total_ever_online + order_num_total_ever_offline) > 0
  AND (customer_value_total_ever_online + customer_value_total_ever_offline) > 100
ORDER BY toplam_harcama DESC;



-- Zaman Bazlı Analiz: Son 6 aydaki aktif müşteriler
-- Son 6 ayda (2021-01-01 sonrası) sipariş veren müşterileri ve toplam harcamalarını listeler.
SELECT 
    master_id,
    last_order_date,
    (customer_value_total_ever_online + customer_value_total_ever_offline) AS toplam_harcama
FROM FLO
WHERE last_order_date >= '2021-01-01'
ORDER BY last_order_date DESC;

-- Sadık müşterilerin segmentasyonu
-- Ortalama sipariş sıklığı ve harcama tutarına göre müşterileri segmentlere ayırır(örnk: yüksek değerli müşteriler).
WITH MusteriSegment AS (
    SELECT 
        master_id,
        (order_num_total_ever_online + order_num_total_ever_offline) AS toplam_siparis,
        (customer_value_total_ever_online + customer_value_total_ever_offline) AS toplam_harcama,
        DATEDIFF(DAY, first_order_date, last_order_date) / NULLIF((order_num_total_ever_online + order_num_total_ever_offline), 0) AS ortalama_siparis_araligi
    FROM FLO
    WHERE (order_num_total_ever_online + order_num_total_ever_offline) > 0
)
SELECT 
    master_id,
    toplam_siparis,
    toplam_harcama,
    CASE 
        WHEN toplam_harcama > 1000 AND ortalama_siparis_araligi < 90 THEN 'Yüksek Değerli Sadık Müşteri'
        WHEN toplam_harcama BETWEEN 500 AND 1000 THEN 'Orta Değerli Müşteri'
        ELSE 'Düşük Değerli Müşteri'
    END AS musteri_segmenti
FROM MusteriSegment
ORDER BY toplam_harcama DESC;