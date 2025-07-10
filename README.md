# E-Ticaret Müşteri Analizi ve Segmentasyonu



## Proje Amacı
FLO e-ticaret veri seti (`FLO.csv`) kullanılarak müşteri davranışlarını analiz eden MS SQL sorgularını içerir. Proje, müşteri segmentasyonu, sipariş kanalı performansı, kategori bazlı harcama trendleri ve zaman bazlı müşteri aktivite analizleri 
vb. iş zekası uygulamalarına odaklanmakta. Veri odaklı içgörüler sağlayarak pazarlama ve CRM stratejilerine destek olmayı hedefler.


## Veri Seti / Data Set
**Kolonlar**:
  - `master_id`: Müşteri ID'si
  - `order_channel`: Sipariş kanalı (Android App, Mobile, Desktop, Ios App)
  - `last_order_channel`: Son sipariş kanalı
  - `first_order_date`, `last_order_date`: İlk ve son sipariş tarihleri
  - `last_order_date_online`, `last_order_date_offline`: Son online/offline sipariş tarihleri
  - `order_num_total_ever_online`, `order_num_total_ever_offline`: Toplam online/offline sipariş sayıları
  - `customer_value_total_ever_online`, `customer_value_total_ever_offline`: Toplam online/offline harcama tutarları
  - `interested_in_categories_12`: Son 12 ayda ilgi gösterilen kategoriler
  - `store_type`: Mağaza tipi (A, B, C)
  
  
## Gereksinimler / Requierements

- Microsoft SQL Server (Express sürümü yeterli)
- SQL Server Management Studio (SSMS) veya Azure Data Studio
- Veri seti / Data Set: FLO.csv



## Kullanım Adımları / Getting Started  

- Veri setini 'FLO.csv' indirin.
- SQL Server Management Studio (SSMS) üzerinde yeni bir veritabanı oluşturun:
  ```sql
  CREATE DATABASE CUSTOMERS;
  ```
- Oluşturduğunuz veritabanına sağ tıklayın → "Tasks" → "Import Flat File".
- Kaynak olarak FLO.csv dosyasını seçin.
- Hedef tablo adını FLO olarak belirleyin ve sütunları eşleştirin.

- Verinin doğru yüklendiğini kontrol etmek için:
- 
   ```sql
  SELECT TOP 10 * FROM FLO;
  
  ```
- `SQLQueryFLO.sql` ve `SQLQueryFLO2.sql` dosyalarındaki sorguları SQL Server Management Studio (SSMS) ile çalıştırın.



## SQL Sorguları / SQL Queries
Aşağıdaki örnek sorgular, MS SQL Server için optimize edilmiştir ve tüm sorgular `SQLQueryFLO.sql` ve `SQLQueryFLO2.sql`dosyalarında bulunmaktadır.


### 1. Sadık müşterilerin segmentasyonu
 Ortalama sipariş sıklığı ve harcama tutarına göre müşterileri segmentlere ayırır(örnk: yüksek değerli müşteriler).

```sql

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
```







## Lisans / License

This project is open source and available under the [MIT License](LICENSE).


## Katkılar / Contributing
Bu projeyi geliştirmek veya özelleştirmek isterseniz, lütfen bir pull request gönderin veya iletişime geçin.

## İletişim / Contact
Proje hakkında sorularınız varsa veya özelleştirme talebiniz varsa, bana şu adresten ulaşabilirsiniz:

GitHub: arjinnie





