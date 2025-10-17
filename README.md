# Analisa Gudang Penyimpanan

## Daftar Isi:
*	Laporan Eksekutif
* Tujuan
*	Deskripsi Data
*	Laporan Kinerja Penjualan
    * Performa Menyeluruh
    * Penjualan Produk
    * Periode Terbaik
    *	Demografi Pelanggan
    *	Performa Berdasarkan Wilayah
*	Tingkat Pertumbuhan
    *	Produk dengan kestabilan paling baik
    *	Negara dengan kenaikan paling stabil
*	Rekomendasi
*	Kekurangan dan Peringatan

## Ringkasan Eksekutif

Data memperlihatkan penjualan selama  tahun (2011-2013) dan bulan pertama pada 2014. Total revenue yang dihasilkan sebesar **$29.3M**. **Kuartal ke-4** selalu menjadi periode paling stabil dengan total laba sebesar **$9M**. 
Penjualan produk **Sepeda** mengalami peningkatan setiap tahun dengan puncaknya pada **tahun 2013 sebesar $16 M**, dan Produk sepeda yang paling diminati adalah **Road Bikes** atau **Sepeda Jalan** dengan total revenue **$14.5 M**. **AS** menjadi menjadi wilayah paling menguntungkan bagi perusahaan, pelanggan AS menyumbang **$9.1 M (30.8% revenue berdasarkan wilayah)**, **Pelanggan VIP** mengalami kenaikan signifikan dan semakin mendominasi demografi yang pada awalnya hanya **7% pada 2010** menjadi **76% pada tahun 2013.**

<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/bi_1.png" width=700 height=600>
</p>

## Tujuan

Analisis ini bertujuan untuk memberikan gambaran menyeluruh mengenai kinerja bisnis Gold Bike Store, perusahaan yang bergerak di bidang penjualan sepeda dan perlengkapannya, berdasarkan data penjualan periode 2011–2013 dan Januari 2014.
Secara khusus, laporan ini memiliki beberapa tujuan utama:
*	**Mengidentifikasi tren penjualan** secara tahunan dan musiman untuk memahami periode terbaik serta faktor yang memengaruhi fluktuasi penjualan.
*	**Menganalisis performa produk** berdasarkan kategori (Bikes, Components, Clothing, Accessories) dan subkategori guna mengetahui produk yang paling menguntungkan dan paling stabil.
*	**Menganalisis karakteristik pelanggan** berdasarkan usia, kelas pelanggan (VIP, Regular, New), dan wilayah negara untuk mengidentifikasi segmen pelanggan potensial serta perilaku pembelian mereka.
*	**Menilai kontribusi tiap wilayah** terhadap total pendapatan perusahaan serta menemukan peluang ekspansi di pasar dengan pertumbuhan stabil.
*	**Memberikan rekomendasi strategis** untuk meningkatkan penjualan, loyalitas pelanggan, serta efisiensi operasional berdasarkan temuan data.

## Deskripsi Data

Data yang digunakan dalam analisis ini merupakan kumpulan data historis dari sistem penjualan **Gold Bike Store** selama periode **2011–2013** dan sebagian **Januari 2014**. Data ini mencakup berbagai dimensi utama yang merepresentasikan aktivitas bisnis perusahaan, antara lain:

<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/ERD.png" width=400 height=300>
</p>


*	**Dimensi Pelanggan (Customer Data)**: Berisi informasi mengenai asal negara pelanggan, kelas pelanggan (VIP, Regular, New Customer), dan kelompok usia. Variabel ini digunakan untuk memahami karakteristik serta perilaku pelanggan terhadap pembelian produk.
*	**Dimensi Produk (Product Data)**: Mencakup kategori dan subkategori produk seperti Bikes, Components, Clothing, dan Accessories, beserta detail Product Line seperti Road, Mountain, dan Touring. Variabel ini menjadi dasar dalam mengukur performa dan kontribusi tiap produk terhadap total penjualan.
*	**Dimensi Waktu (Time Dimension)**: Merekam transaksi berdasarkan tahun, kuartal, dan bulan, yang memungkinkan analisis tren musiman dan perbandingan kinerja antarperiode.
*	**Fakta Penjualan (Fact Sales)**: Memuat informasi nilai pendapatan (revenue), jumlah unit terjual, dan margin laba untuk tiap kombinasi produk dan pelanggan.

## Laporan Kinerja Penjualan
*	**Performa Menyeluruh**: Penjualan mengalami puncak pada tahun 2013 dengan penghasilan sebesar $16 M dan Kuartal ke-4 dengan total penghasilan senilai $9 M. Produk Sepeda menjadi yang paling diminati dengan total laba $28 M yang menyumbangkan 96% kedalam total penjualan dari 2011 – 2014 .

<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/pertumbuhan_perbulan.png" width=700 height=600>
</p>

*	**Penjualan Produk**: 
      *	**Profit Produk**: Produk Road Bike selalu mendominasi tiap tahun dengan total penghasilan sebesar $14.5. Tires and tubes menjadi barang yang paling sering dibeli dengan total unit terjual sebanyak 17K walaupun hanya menghasilkan $244K namun Tires and tubes terbukti menjadi salah satu produk yang paling memiliki penjualan paling stabil.
      *  **Performa terlemah**: Produk yang memiliki performa paling buruk ada pada kategori kaus kaki (kategori pakaian/clothing) dalam segi penjualan hanya berhasil menghasilkan $5.1K dengan unit yang terjual hanya sebanyak 586 (di-posisi ke-4 dalam kuantitas penjualan namun terburuk dari segi penghasilan).
      *  **Jumlah Unit Terjual**: Aksesoris menguasi jumlah unit penjualan dengan 36.1K unit aksesoris terjual dengan Tires and tube yang paling besar (17.3K unit) dan Sepeda/Bikes memiliki penjualan yang paling rendah namun (249 unit).
        

## Periode Terbaik:
*	**Analisa Kuartal**: Kuartal pertama disetiap tahun memiliki performa yang kurang stabil. Q1 Tahun 2011 mendominasi penjualan pada tahun tersebut, namun pada 2012 dan 2013 performa Q1 malah menjadi yang terburuk pada tahun masing-masing. Q1 pada 2014 hanya memiliki data pada Januari, namun berdasarkan pola setiap tahun, periode ini memerlukan perhatian lebih.

<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/pertumbuhan_perkualtal.PNG" width=500 height=500>
</p>
  
*	**Perbandingan antar Tahun**: 2013 menjadi tahun paling menguntungkan dengan keuntungan sebesar $16 M dengan jumlah unit terjual sebanyak 56K. Walaupun pada tahun sebelumnya (2012) mengalami performa yang kurang baik, namun hal ini bisa dijadikan sebagai bahan untuk Menyusun strategi pada periode atau tahun berikutnya.
<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/penjualan_berdasarkan_tahun.png" width=500 height=300>
</p>

## Demografi Pelanggan:
*	**Distribusi Usia**: Kelompok usia 50-59 merupakan segmen pelanggan terbesar berdasarkan revenue dengan $10 M, walaupun kuantitas pelanggan didominasi oleh kelompok usia 30-39 tahun dengan … . Menunjukkan kelompok usia 50-59 tahun memiliki finansial yang lebih stabil dibandingkan dengan kelompok usia yang lain.
*	**Distribusi Kelas**: Dari sisi kelas pelanggan, mayoritas pelanggan masuk dalam kategori Regular, yaitu pelanggan dengan masa langganan lebih dari 12 bulan dan total pembelanjaan di bawah $5000. Sementara itu, jumlah pelanggan VIP relatif lebih kecil namun menunjukkan tren kenaikan dari tahun ke tahun, menandakan keberhasilan perusahaan dalam membangun loyalitas pelanggan berharga tinggi.
*	**Korelasi Demografi dan Produk**: 
      *	Usia 60 ke atas lebih menyukai sepeda Mountain-200 Silver-38 dengan total sales $504 K 
      *	Usia 50-59 menyukai Mountain-200 Black- 42 dengan total sales $480 K , usia 40-49 menyukai Mountain-200 Black- 46 dengan total sales $464 K 
      *	Usia 30-39 lebih suka Road-150 Red- 48 dengan total sales $28 K
<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/jumlah_pelanggan_setiap_grup_umur.png" width=200 height=200>
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/jumlah_pelanggan_setiap_kelas.png" width=300 height=300>
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/demografi_pelanggan_pertahun.png" width=800 height=700>
</p>

## Performa Berdasarkan Wilayah:
*	**Negara Paling Mendominasi**: Berdasarkan grafik penjualan produk per negara, terlihat bahwa Amerika Serikat (AS) menjadi kontributor terbesar terhadap total pendapatan Gold Bike Store dengan total penjualan mencapai $9,1 juta, atau sekitar 31% dari keseluruhan penjualan global. Negara lain yang memberikan kontribusi cukup besar adalah Australia dengan pendapatan sekitar $5 juta, diikuti Jerman dan Kanada dengan nilai penjualan yang relatif stabil dari tahun ke tahun. 
*	**Negara Terlemah**: Sementara itu, Prancis tercatat sebagai negara dengan penjualan terendah, dengan nilai di bawah $2 juta selama periode pengamatan. Meskipun volumenya kecil, tren di Prancis menunjukkan pertumbuhan positif yang stabil setiap tahun, menandakan adanya potensi pasar baru yang sedang berkembang.
*	**Informasi Berdasarkan Negara**: Secara keseluruhan, wilayah berbahasa Inggris (AS, Australia, Inggris) masih menjadi tulang punggung utama penjualan perusahaan. Hal ini dapat dikaitkan dengan faktor daya beli, infrastruktur olahraga yang mendukung, dan budaya bersepeda yang kuat di negara-negara tersebut.

<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/kontribusi_setiap_negara_terhadap_penjualan.png" width=300 height=200>
</p>
<p align="center">
   <img src="https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/blob/main/gambar/penjualan_perbulan_berdasarkan_negara.png" width=600 height=500>
</p>

## Perhatian Lebih
*	**Informasi Gender**: Perbedaan antara jumlah gender tidak terlalu besar, memperlihatkan kalau kategori gender bukan hal yang perlu di fokuskan, terutama untuk team marketing, kesalahan promosi dengan menyajikan keuntungan pada salah satu gender kemungkinan akan menghilangkan gender yang lain.
*	**Kelas Pelanggan**: Diperlukan adanya Analisa mendalam terhadap naiknya dominasi pelanggan VIP dalam hal persentase setiap tahun walaupun secara jumlah mereka tetap paling sedikit 

# Rekomendasi
*	Ciptakan program loyalitas khusus bagi pelanggan VIP, seperti bonus servis gratis atau potongan harga untuk pembelian berikutnya.
*	Kembangkan strategi untuk menarik pelanggan muda (under 20), misalnya dengan memperkenalkan produk entry-level yang lebih terjangkau atau kampanye digital di media sosial yang relevan.
*	Pasar Eropa seperti Prancis berpotensi tumbuh, sehingga perlu strategi lokal seperti kolaborasi dengan toko sepeda setempat atau promosi pada event balap sepeda tahunan.
*	Perbedaan preferensi antarnegara juga bisa dijadikan acuan untuk strategi produk tersegmentasi (contoh: promosi Mountain Bike untuk wilayah pegunungan, Road Bike untuk wilayah perkotaan).

# Kekurangan dan Peringatan
*	Data menampilkan data dalam jangka waktu yang terlalu pendek, dengan detail yang terlalu kompleks. Waktu data hanya 2011–2013 (+ awal 2014), sehingga tidak mencerminkan tren jangka panjang. Masih terlalu dini untuk memutuskan dimensi/variabel mana saja yang mendominasi tren penjualan, hal ini terlihat dari persentase pertumbuhan VIP setiap  tahun walaupun secara total keseluruhan jumlah mereka masih sedikit.
*	Terdapat 7 produk tanpa keterangan lengkap yaitu produk 252, 253, 254, 255, 256, 257, 258

Kunjungi query SQL yang digunakan untuk analisis: [SQL](https://github.com/AlHafidzLuhurDarma/Toman_bike_Analisis/tree/main/sql).

Download presentasi Power BI yang telah dibuat untuk analisis: [PowerBI](https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/tree/main/presentasi_powerbi)

Lihat berbagai visualisasi data yang didapatkan selama analisa: [Gambar](https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/tree/main/gambar).

Kunjungi program python yang digunakan untuk ML: [Python](https://github.com/AlHafidzLuhurDarma/Analisa-Gudang-Penyimpanan/tree/main/python_analisis).

Kunjungi Website saya untuk project lainnya: [Situs](..)
